import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { isAbsolute, relative, resolve, sep } from "node:path";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

const PRIORITY_SERVICE_TIER = "priority";
const STATE_FILE = joinPiStateFile("openai-codex-priority-mode.json");

type PriorityState = {
  enabled: boolean;
};

function joinPiStateFile(fileName: string): string {
  return `${homedir()}/.pi/agent/${fileName}`;
}

function loadPriorityEnabled(): boolean {
  try {
    if (!existsSync(STATE_FILE)) return false;
    const state = JSON.parse(readFileSync(STATE_FILE, "utf8")) as Partial<PriorityState>;
    return state.enabled === true;
  } catch {
    return false;
  }
}

function savePriorityEnabled(enabled: boolean): void {
  writeFileSync(STATE_FILE, `${JSON.stringify({ enabled }, null, 2)}\n`, "utf8");
}

let priorityEnabled = loadPriorityEnabled();
let currentThinkingLevel = loadDefaultThinkingLevel();

function loadDefaultThinkingLevel(): string | undefined {
  try {
    const settingsPath = joinPiStateFile("settings.json");
    if (!existsSync(settingsPath)) return undefined;
    const settings = JSON.parse(readFileSync(settingsPath, "utf8")) as { defaultThinkingLevel?: unknown };
    return typeof settings.defaultThinkingLevel === "string" ? settings.defaultThinkingLevel : undefined;
  } catch {
    return undefined;
  }
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

function isOpenAICodexResponsesPayload(payload: unknown): payload is Record<string, unknown> {
  if (!isRecord(payload)) return false;

  const model = payload.model;
  if (typeof model === "string" && model.includes("codex")) return true;

  // Pi's OpenAI Codex Responses payload has this shape. This catches Codex-provider
  // requests even if a non-codex model id is routed through that provider.
  return (
    payload.stream === true &&
    typeof payload.instructions === "string" &&
    Array.isArray(payload.input) &&
    payload.tool_choice === "auto" &&
    "prompt_cache_key" in payload
  );
}

function formatTokens(count: number): string {
  if (count < 1000) return count.toString();
  if (count < 10000) return `${(count / 1000).toFixed(1)}k`;
  if (count < 1000000) return `${Math.round(count / 1000)}k`;
  if (count < 10000000) return `${(count / 1000000).toFixed(1)}M`;
  return `${Math.round(count / 1000000)}M`;
}

function formatCwdForFooter(cwd: string, home: string | undefined): string {
  if (!home) return cwd;

  const resolvedCwd = resolve(cwd);
  const resolvedHome = resolve(home);
  const relativeToHome = relative(resolvedHome, resolvedCwd);
  const isInsideHome =
    relativeToHome === "" ||
    (relativeToHome !== ".." && !relativeToHome.startsWith(`..${sep}`) && !isAbsolute(relativeToHome));

  if (!isInsideHome) return cwd;
  return relativeToHome === "" ? "~" : `~${sep}${relativeToHome}`;
}

function getUsageNumber(value: unknown): number {
  return typeof value === "number" && Number.isFinite(value) ? value : 0;
}

function installFooter(ctx: ExtensionContext): void {
  ctx.ui.setFooter((_tui, theme, footerData) => ({
    invalidate() {},
    render(width) {
      let totalInput = 0;
      let totalOutput = 0;
      let totalCacheRead = 0;
      let totalCacheWrite = 0;
      let totalCost = 0;

      for (const entry of ctx.sessionManager.getEntries()) {
        if (entry.type !== "message" || entry.message.role !== "assistant") continue;
        const usage = entry.message.usage;
        totalInput += getUsageNumber(usage.input);
        totalOutput += getUsageNumber(usage.output);
        totalCacheRead += getUsageNumber(usage.cacheRead);
        totalCacheWrite += getUsageNumber(usage.cacheWrite);
        totalCost += getUsageNumber(usage.cost?.total);
      }

      let pwd = formatCwdForFooter(ctx.sessionManager.getCwd(), process.env.HOME || process.env.USERPROFILE);
      const branch = footerData.getGitBranch();
      if (branch) pwd = `${pwd} (${branch})`;
      const sessionName = ctx.sessionManager.getSessionName();
      if (sessionName) pwd = `${pwd} • ${sessionName}`;

      const statsParts: string[] = [];
      if (totalInput) statsParts.push(`↑${formatTokens(totalInput)}`);
      if (totalOutput) statsParts.push(`↓${formatTokens(totalOutput)}`);
      if (totalCacheRead) statsParts.push(`R${formatTokens(totalCacheRead)}`);
      if (totalCacheWrite) statsParts.push(`W${formatTokens(totalCacheWrite)}`);
      if (totalCost) statsParts.push(`$${totalCost.toFixed(3)}`);

      const contextUsage = ctx.getContextUsage();
      const contextWindow = contextUsage?.contextWindow ?? ctx.model?.contextWindow ?? 0;
      const contextPercentValue = contextUsage?.percent ?? 0;
      const contextPercent = contextUsage?.percent !== null && contextUsage?.percent !== undefined
        ? contextPercentValue.toFixed(1)
        : "?";
      const contextDisplay = contextPercent === "?" ? `?/${formatTokens(contextWindow)}` : `${contextPercent}%/${formatTokens(contextWindow)}`;
      if (contextPercentValue > 90) statsParts.push(theme.fg("error", contextDisplay));
      else if (contextPercentValue > 70) statsParts.push(theme.fg("warning", contextDisplay));
      else statsParts.push(contextDisplay);

      let statsLeft = statsParts.join(" ");
      let statsLeftWidth = visibleWidth(statsLeft);
      if (statsLeftWidth > width) {
        statsLeft = truncateToWidth(statsLeft, width, "...");
        statsLeftWidth = visibleWidth(statsLeft);
      }

      const modelName = ctx.model?.id || "no-model";
      let rightSideWithoutProvider = modelName;
      if (ctx.model?.reasoning && currentThinkingLevel) {
        rightSideWithoutProvider =
          currentThinkingLevel === "off" ? `${modelName} • thinking off` : `${modelName} • ${currentThinkingLevel}`;
      }

      const tier = priorityEnabled ? theme.fg("accent", "priority") : "non-priority";
      rightSideWithoutProvider = `${rightSideWithoutProvider} • ${tier}`;

      let rightSide = rightSideWithoutProvider;
      if (footerData.getAvailableProviderCount() > 1 && ctx.model) {
        rightSide = `(${ctx.model.provider}) ${rightSideWithoutProvider}`;
        if (statsLeftWidth + 2 + visibleWidth(rightSide) > width) rightSide = rightSideWithoutProvider;
      }

      const rightSideWidth = visibleWidth(rightSide);
      let statsLine: string;
      if (statsLeftWidth + 2 + rightSideWidth <= width) {
        statsLine = statsLeft + " ".repeat(width - statsLeftWidth - rightSideWidth) + rightSide;
      } else {
        const availableForRight = width - statsLeftWidth - 2;
        if (availableForRight > 0) {
          const truncatedRight = truncateToWidth(rightSide, availableForRight, "");
          statsLine = statsLeft + " ".repeat(Math.max(0, width - statsLeftWidth - visibleWidth(truncatedRight))) + truncatedRight;
        } else {
          statsLine = statsLeft;
        }
      }

      const pwdLine = truncateToWidth(theme.fg("dim", pwd), width, theme.fg("dim", "..."));
      const dimStatsLeft = theme.fg("dim", statsLeft);
      const remainder = statsLine.slice(statsLeft.length);
      const dimRemainder = theme.fg("dim", remainder);
      return [pwdLine, dimStatsLeft + dimRemainder];
    },
  }));
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    installFooter(ctx);
  });

  pi.on("model_select", (_event, ctx) => {
    installFooter(ctx);
  });

  pi.on("thinking_level_select", (event, ctx) => {
    currentThinkingLevel = event.level;
    installFooter(ctx);
  });

  pi.registerCommand("priority-toggle", {
    description: "Toggle OpenAI Codex priority service tier",
    handler: async (_args, ctx) => {
      priorityEnabled = !priorityEnabled;
      savePriorityEnabled(priorityEnabled);
      installFooter(ctx);
      ctx.ui.notify(`OpenAI Codex service tier: ${priorityEnabled ? "priority" : "non-priority"}`, "info");
    },
  });

  pi.on("before_provider_request", (event) => {
    if (!priorityEnabled) return;
    if (!isOpenAICodexResponsesPayload(event.payload)) return;

    return {
      ...event.payload,
      service_tier: PRIORITY_SERVICE_TIER,
    };
  });
}
