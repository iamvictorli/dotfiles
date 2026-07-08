/**
 * Contextual Input Editor
 *
 * Replaces pi's external-editor action (`app.editor.external`, Ctrl+G by default)
 * The external editor opens a temporary Markdown file with a frontmatter-style
 * input block at the top, followed by the active branch's user/assistant
 * conversation in reverse chronological order.
 *
 * On save, only text inside the top frontmatter block is copied back into pi's
 * input box. Edits to the conversation context are intentionally ignored, and
 * tool calls/tool results are omitted from the generated context.
 */

import type {
  AppKeybinding,
  ExtensionAPI,
  ExtensionContext,
  KeybindingsManager,
  SessionMessageEntry,
} from "@earendil-works/pi-coding-agent";
import { Editor, setKeybindings, type EditorComponent, type EditorTheme, type TUI } from "@earendil-works/pi-tui";
import { spawnSync } from "node:child_process";
import { randomUUID } from "node:crypto";
import { readFileSync, unlinkSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";

const FRONTMATTER_DELIMITER = "---";

type EditorFactory = NonNullable<ReturnType<ExtensionContext["ui"]["getEditorComponent"]>>;

type CustomEditorLike = EditorComponent & {
  actionHandlers: Map<AppKeybinding, () => void>;
  onEscape?: () => void;
  onCtrlD?: () => void;
  onPasteImage?: () => void;
  onExtensionShortcut?: (data: string) => boolean | undefined;
};

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null;
}

function isCustomEditorLike(editor: EditorComponent): editor is CustomEditorLike {
  return isRecord(editor) && editor.actionHandlers instanceof Map;
}

function isFocusableEditor(
  editor: EditorComponent,
): editor is EditorComponent & { focused: boolean } {
  return isRecord(editor) && typeof editor.focused === "boolean";
}

function extractTextFromContent(content: unknown): string {
  if (typeof content === "string") return content;
  if (!Array.isArray(content)) return "";

  return content
    .map((block) => {
      if (!isRecord(block)) return "";
      if (block.type === "text" && typeof block.text === "string") return block.text;
      if (block.type === "image") return "[image omitted]";
      return "";
    })
    .filter((text) => text.length > 0)
    .join("\n");
}

function extractMessageText(message: SessionMessageEntry["message"]): string {
  if (!isRecord(message) || !("content" in message)) return "";
  return extractTextFromContent(message.content).trimEnd();
}

function extractFrontmatterInput(fileContent: string): string | undefined {
  const lines = fileContent.split(/\r?\n/);
  if (lines[0] !== FRONTMATTER_DELIMITER) return undefined;

  const endIndex = lines.findIndex((line, index) => index > 0 && line === FRONTMATTER_DELIMITER);
  if (endIndex === -1) return undefined;

  return lines.slice(1, endIndex).join("\n");
}

function stripEmbeddedContextualInputEditorSnapshot(text: string): string {
  if (
    text.startsWith(`${FRONTMATTER_DELIMITER}\n`) ||
    text.startsWith(`${FRONTMATTER_DELIMITER}\r\n`)
  ) {
    const frontmatterInput = extractFrontmatterInput(text);
    if (frontmatterInput !== undefined) return frontmatterInput.trimEnd();
  }

  return text;
}

function buildConversationMarkdown(ctx: ExtensionContext): string {
  const sections: string[] = [];
  const branch = ctx.sessionManager.getBranch();

  for (let index = branch.length - 1; index >= 0; index--) {
    const entry = branch[index];
    if (!entry || entry.type !== "message") continue;
    if (entry.message.role !== "user" && entry.message.role !== "assistant") continue;

    const extractedText = extractMessageText(entry.message);
    const text =
      entry.message.role === "user"
        ? stripEmbeddedContextualInputEditorSnapshot(extractedText)
        : extractedText;
    if (text.trim().length === 0) continue;

    const title = entry.message.role === "user" ? "User" : "Assistant";
    sections.push(`## ${title}\n\n${text}`);
  }

  return sections.join("\n\n");
}

function splitEditorCommand(editorCommand: string): string[] {
  return editorCommand.split(" ").filter((part) => part.length > 0);
}

function openContextualInputEditor(
  ctx: ExtensionContext,
  tui: TUI,
  editor: Pick<EditorComponent, "getText" | "getExpandedText" | "setText">,
): void {
  const editorCommand = process.env.VISUAL || process.env.EDITOR;
  if (!editorCommand) {
    ctx.ui.notify("No editor configured. Set $VISUAL or $EDITOR.", "warning");
    return;
  }

  const nonce = randomUUID();
  const currentText = editor.getExpandedText?.() ?? editor.getText();
  const tmpFile = join(tmpdir(), `pi-contextual-input-editor-${Date.now()}-${nonce}.md`);
  const fileContent = [
    FRONTMATTER_DELIMITER,
    currentText,
    FRONTMATTER_DELIMITER,
    "",
    buildConversationMarkdown(ctx),
    "",
  ].join("\n");

  let tuiStopped = false;
  try {
    writeFileSync(tmpFile, fileContent, "utf8");
    tui.stop();
    tuiStopped = true;

    const [command, ...args] = splitEditorCommand(editorCommand);
    if (!command) {
      ctx.ui.notify("No editor configured. Set $VISUAL or $EDITOR.", "warning");
      return;
    }

    const result = spawnSync(command, [...args, tmpFile], {
      cwd: ctx.cwd,
      stdio: "inherit",
      shell: process.platform === "win32",
    });

    if (result.error) {
      ctx.ui.notify(`External editor failed: ${result.error.message}`, "error");
      return;
    }
    if (result.status !== 0) return;

    const savedContent = readFileSync(tmpFile, "utf8");
    const inputText = extractFrontmatterInput(savedContent);
    if (inputText === undefined) {
      ctx.ui.notify("Frontmatter input block was removed; keeping existing input.", "warning");
      return;
    }

    editor.setText(inputText);
  } finally {
    try {
      unlinkSync(tmpFile);
    } catch {
      // Ignore cleanup errors.
    }

    if (tuiStopped) {
      tui.start();
      tui.requestRender(true);
    }
  }
}

class LocalCustomEditor extends Editor {
  public actionHandlers: Map<AppKeybinding, () => void> = new Map();
  public onEscape?: () => void;
  public onCtrlD?: () => void;
  public onPasteImage?: () => void;
  public onExtensionShortcut?: (data: string) => boolean | undefined;

  constructor(
    tui: TUI,
    theme: EditorTheme,
    protected readonly keybindings: KeybindingsManager,
  ) {
    super(tui, theme);
  }

  onAction(action: AppKeybinding, handler: () => void): void {
    this.actionHandlers.set(action, handler);
  }

  override handleInput(data: string): void {
    if (this.onExtensionShortcut?.(data)) return;

    if (this.keybindings.matches(data, "app.clipboard.pasteImage")) {
      this.onPasteImage?.();
      return;
    }

    if (this.keybindings.matches(data, "app.interrupt")) {
      if (!this.isShowingAutocomplete()) {
        const handler = this.onEscape ?? this.actionHandlers.get("app.interrupt");
        if (handler) {
          handler();
          return;
        }
      }
      super.handleInput(data);
      return;
    }

    if (this.keybindings.matches(data, "app.exit")) {
      if (this.getText().length === 0) {
        const handler = this.onCtrlD ?? this.actionHandlers.get("app.exit");
        if (handler) handler();
        return;
      }
    }

    for (const [action, handler] of this.actionHandlers) {
      if (action !== "app.interrupt" && action !== "app.exit" && this.keybindings.matches(data, action)) {
        handler();
        return;
      }
    }

    super.handleInput(data);
  }
}

class ContextualInputExternalEditor extends LocalCustomEditor {
  constructor(
    tui: TUI,
    theme: EditorTheme,
    keybindings: KeybindingsManager,
    private readonly ctx: ExtensionContext,
  ) {
    super(tui, theme, keybindings);
  }

  override handleInput(data: string): void {
    if (this.keybindings.matches(data, "app.editor.external")) {
      openContextualInputEditor(this.ctx, this.tui, this);
      return;
    }
    super.handleInput(data);
  }
}

class ContextualInputEditorWrapper implements EditorComponent {
  private focusedValue = false;

  constructor(
    protected readonly inner: EditorComponent,
    private readonly ctx: ExtensionContext,
    private readonly tui: TUI,
    private readonly keybindings: KeybindingsManager,
  ) {}

  get focused(): boolean {
    return isFocusableEditor(this.inner) ? this.inner.focused : this.focusedValue;
  }
  set focused(value: boolean) {
    this.focusedValue = value;
    if (isFocusableEditor(this.inner)) this.inner.focused = value;
  }

  get onSubmit(): ((text: string) => void) | undefined {
    return this.inner.onSubmit;
  }
  set onSubmit(value: ((text: string) => void) | undefined) {
    this.inner.onSubmit = value;
  }

  get onChange(): ((text: string) => void) | undefined {
    return this.inner.onChange;
  }
  set onChange(value: ((text: string) => void) | undefined) {
    this.inner.onChange = value;
  }

  get borderColor(): ((str: string) => string) | undefined {
    return this.inner.borderColor;
  }
  set borderColor(value: ((str: string) => string) | undefined) {
    this.inner.borderColor = value;
  }

  get wantsKeyRelease(): boolean | undefined {
    return this.inner.wantsKeyRelease;
  }
  set wantsKeyRelease(value: boolean | undefined) {
    this.inner.wantsKeyRelease = value;
  }

  render(width: number): string[] {
    return this.inner.render(width);
  }

  handleInput(data: string): void {
    if (this.keybindings.matches(data, "app.editor.external")) {
      openContextualInputEditor(this.ctx, this.tui, this.inner);
      return;
    }
    this.inner.handleInput(data);
  }

  invalidate(): void {
    this.inner.invalidate();
  }

  getText(): string {
    return this.inner.getText();
  }

  setText(text: string): void {
    this.inner.setText(text);
  }

  addToHistory(text: string): void {
    this.inner.addToHistory?.(text);
  }

  insertTextAtCursor(text: string): void {
    this.inner.insertTextAtCursor?.(text);
  }

  getExpandedText(): string {
    return this.inner.getExpandedText?.() ?? this.inner.getText();
  }

  setAutocompleteProvider(
    provider: Parameters<NonNullable<EditorComponent["setAutocompleteProvider"]>>[0],
  ): void {
    this.inner.setAutocompleteProvider?.(provider);
  }

  setPaddingX(padding: number): void {
    this.inner.setPaddingX?.(padding);
  }

  setAutocompleteMaxVisible(maxVisible: number): void {
    this.inner.setAutocompleteMaxVisible?.(maxVisible);
  }
}

class CustomContextualInputEditorWrapper extends ContextualInputEditorWrapper {
  constructor(
    inner: CustomEditorLike,
    ctx: ExtensionContext,
    tui: TUI,
    keybindings: KeybindingsManager,
  ) {
    super(inner, ctx, tui, keybindings);
    this.actionHandlers = inner.actionHandlers;
  }

  public actionHandlers: Map<AppKeybinding, () => void>;

  private get customInner(): CustomEditorLike {
    return this.inner as CustomEditorLike;
  }

  get onEscape(): (() => void) | undefined {
    return this.customInner.onEscape;
  }
  set onEscape(value: (() => void) | undefined) {
    this.customInner.onEscape = value;
  }

  get onCtrlD(): (() => void) | undefined {
    return this.customInner.onCtrlD;
  }
  set onCtrlD(value: (() => void) | undefined) {
    this.customInner.onCtrlD = value;
  }

  get onPasteImage(): (() => void) | undefined {
    return this.customInner.onPasteImage;
  }
  set onPasteImage(value: (() => void) | undefined) {
    this.customInner.onPasteImage = value;
  }

  get onExtensionShortcut(): ((data: string) => boolean | undefined) | undefined {
    return this.customInner.onExtensionShortcut;
  }
  set onExtensionShortcut(value: ((data: string) => boolean | undefined) | undefined) {
    this.customInner.onExtensionShortcut = value;
  }
}

export default function (pi: ExtensionAPI) {
  let previousFactory: EditorFactory | undefined;
  let installedFactory: EditorFactory | undefined;

  pi.on("session_start", (_event, ctx) => {
    previousFactory = ctx.ui.getEditorComponent();

    const factory: EditorFactory = (tui, editorTheme, keybindings) => {
      // This extension may resolve its own @earendil-works/pi-tui instance from ~/.pi/node_modules.
      // Keep that instance's global keybinding manager synced so the fallback Editor honors user bindings.
      setKeybindings(keybindings);

      if (!previousFactory) {
        return new ContextualInputExternalEditor(tui, editorTheme, keybindings, ctx);
      }

      const previousEditor = previousFactory(tui, editorTheme, keybindings);
      if (isCustomEditorLike(previousEditor)) {
        return new CustomContextualInputEditorWrapper(previousEditor, ctx, tui, keybindings);
      }
      return new ContextualInputEditorWrapper(previousEditor, ctx, tui, keybindings);
    };

    installedFactory = factory;
    ctx.ui.setEditorComponent(factory);
  });

  pi.on("session_shutdown", (_event, ctx) => {
    if (installedFactory && ctx.ui.getEditorComponent() === installedFactory) {
      ctx.ui.setEditorComponent(previousFactory);
    }
    installedFactory = undefined;
    previousFactory = undefined;
  });
}
