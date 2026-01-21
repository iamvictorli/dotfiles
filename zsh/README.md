# Zsh Configuration

Optimized zsh setup focused on fast startup times and developer productivity.

## Structure

```
zsh/
├── .zshrc              # Main configuration
├── tmux.zsh            # Tmux aliases
├── .cache/             # Cached init scripts (auto-generated)
└── .stow-local-ignore  # Stow exclusions
```

## Features

### Fast Startup

- **Cached init scripts**: Tools like `starship`, `fnm`, and `fzf` init scripts are cached and only regenerated when the binary changes
- **Lazy compinit**: Completion system only initializes on first Tab press

### Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `rm` | `trash` | Safe delete (moves to trash) |
| `vim` / `code` | `nvim` | Opens current dir if no args |
| `ll` | `eza -l -g --icons --git` | Detailed file listing |
| `llt` | `eza -1 --icons --tree --git-ignore` | Tree view |
| `lg` | `lazygit` | Git TUI |
| `lzd` | `lazydocker` | Docker TUI |
| `gds` | `git diff --staged \| delta` | Staged diff with delta |
| `gdu` | `git diff \| delta` | Unstaged diff with delta |
| `oc` | `opencode` | OpenCode CLI |
| `ks` | `tmux kill-server` | Kill tmux |
| `scratch` | `nvim -c "setlocal buftype=nofile"` | Temp scratch buffer |
| `y` | yazi wrapper | File manager with cwd sync |

### Tmux Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `ta [name]` | `tmux attach [-t name]` | Attach to session |
| `to [name]` | `tmux new-session -A [-s name]` | Attach or create session |
| `ts [name]` | `tmux new-session [-s name]` | New session |
| `tkss [name]` | `tmux kill-session [-t name]` | Kill session |
| `tl` | `tmux list-sessions` | List sessions |
| `tksv` | `tmux kill-server` | Kill server |

## Dependencies

- [starship](https://starship.rs/) - Prompt
- [fnm](https://github.com/Schniz/fnm) - Node version manager
- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder
- [eza](https://github.com/eza-community/eza) - Modern ls
- [delta](https://github.com/dandavison/delta) - Git diff viewer
- [yazi](https://yazi-rs.github.io/) - File manager
- [trash-cli](https://github.com/sindresorhus/trash-cli) - Safe rm
- [lazygit](https://github.com/jesseduffield/lazygit) - Git TUI
- [lazydocker](https://github.com/jesseduffield/lazydocker) - Docker TUI

## Installation

Uses [GNU Stow](https://www.gnu.org/software/stow/):

```sh
cd ~/dotfiles
stow zsh
```
