# DOTFILES KNOWLEDGE BASE

GNU Stow-managed macOS dotfiles. Each package under `stow/` mirrors paths below `$HOME`.

## STRUCTURE

```
dotfiles/
├── install-laptop       # entry point on laptop: ./install with Brewfile.laptop
├── install-homelab      # entry point on homelab: checks, pull, ./install with Brewfile.homelab, logs
├── install              # shared steps: Homebrew, stow, vite-plus, skills, opensrc bootstrap
├── Brewfile.laptop      # Homebrew packages for laptop
├── Brewfile.homelab     # Homebrew packages for homelab
├── benchmark-zsh        # hyperfine wrapper for interactive/login zsh startup
├── logs/                # install-homelab run logs and last-run.json (ignored)
├── opensrc-repos        # repositories commit-checked by ./install
├── assets/              # keyboard modifier reference images
└── stow/
    ├── agents/          # ~/.agents skill inventory and lock
    ├── bin/             # ~/.local/bin wrapper scripts (e.g. tailscale CLI)
    ├── ghostty/         # ~/.config/ghostty
    ├── herdr/           # ~/.config/herdr
    ├── hunk/            # ~/.config/hunk
    ├── lazygit/         # ~/Library/Application Support/lazygit
    ├── nvim/            # LazyVim under ~/.config/nvim
    ├── pi/              # ~/.pi settings, keybindings, extensions, workspace
    ├── rex/             # ~/.config/rex/init.lua (Rex keybindings)
    ├── ssh/             # ~/.ssh/config
    ├── starship/        # ~/.config/starship.toml
    ├── yazi/            # ~/.config/yazi
    ├── yt-dlp/          # ~/.config/yt-dlp
    └── zsh/             # ~/.zshrc; generated cache is ignored
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Bootstrap or restow everything | `install-laptop`, `install-homelab` | Both run shared `install` with their Brewfile; also upgrades Brew bundle and refreshes external sources |
| Add/remove a stow package | `stow/<package>/`, `PACKAGES` in `install` | Both must change |
| Add/remove Homebrew dependencies | `Brewfile.homelab`, `Brewfile.laptop` | No shared base; each `install-<machine>` passes its own file to `install`. Cleanup is a separate destructive command |
| Change shell startup or aliases | `stow/zsh/.zshrc` | `_cache_init` owns generated init snippets |
| Change homelab install | `install-homelab` | Scheduled run uses `SKIP_BREW=1 ./install-homelab`; pause with `logs/paused` |
| Measure shell startup | `benchmark-zsh` | Supports interactive/login and cache controls |
| Change Neovim behavior | `stow/nvim/.config/nvim/lua/config/` | LazyVim-style config split |
| Change Neovim plugins | `stow/nvim/.config/nvim/lua/plugins/plugins.lua` | Lockfile: `lazy-lock.json` |
| Update global agent skills | `stow/agents/.agents/.skill-lock.json`, `stow/agents/.agents/skills/` | Keep lock metadata and installed content aligned |
| Change Pi defaults or keys | `stow/pi/.pi/agent/settings.json`, `keybindings.json` | Product configuration, not local runtime state |
| Change Pi extensions | `stow/pi/.pi/agent/extensions/` | Standalone extensions plus workspace packages |
| Change skill toggle behavior | `stow/pi/.pi/agent/extensions/pi-skill-toggle/src/` | Tests colocated by domain |
| Change diff review defaults | `stow/hunk/.config/hunk/config.toml` | Hunk configuration |
| Change file manager behavior | `stow/yazi/.config/yazi/` | Lua plugin directories end in `.yazi/` |
| Inspect third-party source | `~/.opensrc/repos/github.com/<owner>/<repo>/<ref>/` | Consult local source for implementation questions; e.g. `yt-dlp/yt-dlp/master/` |
| Change refreshed source inventory | `opensrc-repos`, `refresh_opensrc_repo_if_commit_changed()` in `install` | One repository slug per line |
| Find ignored local state | `.gitignore` | Pi auth/sessions, SSH material, Herdr/Rex/Lazygit state |

## CONVENTIONS

- Stow from repository root with `stow -d stow -t ~ <package>`; package roots mirror `$HOME` exactly.
- Hidden paths are product paths: inspect `.config`, `.pi`, `.agents`, `.ssh`, and macOS `Library/` trees.
- Tokyo Night Storm spans terminal, prompt, fzf, Neovim-adjacent tools, and file manager themes.
- JetBrainsMono Nerd Font Mono is primary; Symbols Nerd Font supplies icon coverage.
- `nvim` is the editor; `vim()` opens `nvim .` with no arguments; `c` aliases to it.
- `rm` aliases to `trash`; use the underlying command explicitly only when permanent deletion is intended.
- Node setup uses vite-plus when available; `stow/pi/.pi` is an npm workspace for `agent/extensions/*`.
- `install` may skip unavailable optional tools and continue after skill or opensrc refresh failures.

## ANTI-PATTERNS

- Treat every file under `stow/<package>/` as deployable payload; an `AGENTS.md` there would also be linked into `$HOME`.
- Leave `stow/zsh/.cache/` generated; change `_cache_init` calls in `.zshrc`, then regenerate through shell startup.
- Keep local state and secrets untracked: Pi auth/models/trust/sessions/package checkouts, SSH keys, Herdr state, and Lazygit state.
- Keep `stow/pi/.pi/node_modules/` untracked; restore it from `package-lock.json`.
- Update `PACKAGES` when adding or removing a directory under `stow/`; otherwise bootstrap silently skips it.
- Run stow from repository root, not from inside a package, so source and target roots remain explicit.
- Preserve cached shell initialization; raw `eval "$(...)"` calls create startup regressions measured by `benchmark-zsh`.
- Review ignored local state before broad restows; tracked config and untracked runtime files share directories.

## COMMANDS

```bash
./install-laptop                               # broad bootstrap on the laptop: upgrades, restows, refreshes
./install-homelab                              # same on the homelab, with Brewfile.homelab
brew bundle install --file=Brewfile.laptop     # install declared Homebrew dependencies (Brewfile.homelab on the homelab)
brew bundle cleanup --force --file=Brewfile.laptop  # remove dependencies absent from that Brewfile
./benchmark-zsh                                # interactive shell startup benchmark
./benchmark-zsh -l                             # login shell benchmark
stow -v -d stow -t ~ zsh                       # stow one package
stow -v -d stow -t ~ -D zsh                    # unstow one package
(cd stow/pi/.pi && npm install)                # restore Pi workspace dependencies
(cd stow/pi/.pi/agent/extensions/pi-skill-toggle && npm test)
(cd stow/pi/.pi/agent/extensions/pi-skill-toggle && npm run typecheck)
env -u XDG_STATE_HOME npx skills update --global --yes
```

## KEY CONFIGS

| Tool | Entry | Notes |
|------|-------|-------|
| Bootstrap | `install-laptop`, `install-homelab`, `install` | Wrappers pick the Brewfile; `install` holds `PACKAGES`, vite-plus globals, skill update, opensrc refresh |
| Homebrew | `Brewfile.homelab`, `Brewfile.laptop` | One full Brewfile per machine, chosen by the install script you run |
| zsh | `stow/zsh/.zshrc` | Lazy completion, cached init, aliases, fzf theme |
| Neovim | `stow/nvim/.config/nvim/` | LazyVim config and lockfile |
| Pi workspace | `stow/pi/.pi/package.json` | npm workspaces and shared Pi dependencies |
| Pi agent | `stow/pi/.pi/agent/` | Settings, keybindings, extensions |
| Agent skills | `stow/agents/.agents/.skill-lock.json` | Sources, hashes, install/update metadata |
| Hunk | `stow/hunk/.config/hunk/config.toml` | Diff viewer defaults |
| Yazi | `stow/yazi/.config/yazi/*.toml` | Behavior, keymap, theme |
| yt-dlp | `stow/yt-dlp/.config/yt-dlp/config` | Clears default JS runtimes and enables only Node; Homebrew may still install Deno as a dependency |

## VALIDATION

- Shell changes: run `./benchmark-zsh`; open a fresh interactive zsh when practical.
- Stow layout changes: run `stow -v -d stow -t ~ <package>` before `./install-laptop` or `./install-homelab`.
- Pi skill toggle changes: run its `npm test` and `npm run typecheck` scripts.
- Neovim changes: start `nvim` and check LazyVim startup/load errors.
- Bootstrap changes: inspect ignored local state before running `./install-laptop` or `./install-homelab`.

## NOTES

- `./install` (via either wrapper) runs `brew update`, bundle install, and bundle upgrade before restowing packages.
- Opensrc repo refreshes track remote HEAD in `~/.opensrc/repo-commits.json`; pre-state checkouts are tree-verified, while changed or missing checkouts install through a temporary cache.
- Pi package sources under `stow/pi/.pi/agent/git/` are runtime checkouts, not repository source.
- Tracked third-party skills are refreshed from `.skill-lock.json`; preserve source/hash context when updating them.
