# dotfiles

My dotfiles for Neovim, zsh, tmux, and ghostty on macOS. Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Installation

1. Install [Homebrew](https://brew.sh/):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install prerequisites:

```bash
brew install git stow
```

3. Clone the repo:

```bash
git clone git@github.com:iamvictorli/dotfiles.git ~/workspace/dotfiles
cd ~/workspace/dotfiles
```

4. Run the install script:

```bash
./install
```

This requires Homebrew, `git`, and GNU Stow to already be installed, then stows the packages from `stow/`, installs everything else from `Brewfile`, installs the latest LTS Node.js via `fnm`, and installs `trash-cli`.

5. (Optional) Cleanup packages not in Brewfile:

```bash
brew bundle cleanup --force
```

### Stow individual packages

Stow packages live under `stow/`.

```bash
cd ~/workspace/dotfiles
stow -d stow -t ~ zsh     # Just zsh config
stow -d stow -t ~ nvim    # Just nvim config
stow -d stow -t ~ -D zsh  # Unstow (remove symlinks)
```

### Available packages

| Package    | Description             |
| ---------- | ----------------------- |
| `zsh`      | Shell configuration     |
| `tmux`     | Terminal multiplexer    |
| `ssh`      | SSH configuration       |
| `nvim`     | Neovim configuration    |
| `ghostty`  | Ghostty terminal        |
| `starship` | Starship prompt         |
| `lazygit`  | Lazygit configuration   |
| `yazi`     | Yazi file manager theme |
| `opencode` | OpenCode configuration  |


## Mac Settings

- System preferences > Accessibility > Display > Reduce Motion. Toggle on

- System preferences > Accessibility > Display > Increase contrast. Toggle on

- System preferences > Accessibility > Display > Reduce Transparency. Toggle on

- System preferences > Accessibility > Pointer > Reduce mouse pointer to locate. Toggle on

- System preferences > Accessibility > Pointer > Pointer size. Slider to largest

- Dock > Size. Slider on 20%

- Dock > Magnification. Slider on Small

- Dock > Position on screen. Select Left

- Dock > Minimize windows into application icon. Toggle off

- Dock > Automatically hide and show the Dock. Toggle on

- Dock > Animate opening applications. Toggle on

- Dock > Show indicators for open applications. Toggle on

- Dock > Show recent applications in Dock. Toggle off

- Keyboard > Key Repeat. Fastest. Slider to largest

- Keyboard > Delay until Repeat. Shortest. Slider to largest

- Accessibility > Vision > Display > Pointer > Pointer Size. Largest. Slider to largest

- Desktop & Screen Saver > [Wallpaper](https://raw.githubusercontent.com/catppuccin/wallpapers/main/minimalistic/flamingo_unicat.png)

## Keyboard modifier keys

<details>
<summary>Apple Internal Keyboard</summary>
<img src="https://github.com/iamvictorli/dotfiles/blob/main/assets/apple_internal_keyboard.png?raw=true" alt="Apple Internal Keyboard screenshot" />
</details>

<details>
<summary>Custom Mechanical Keyboard</summary>
<img src="https://github.com/iamvictorli/dotfiles/blob/main/assets/custom_mech_keyboard.png?raw=true" alt="Custom Mechanical Keyboard screenshot" />
</details>

## Programs

- [Orb Stack](https://orbstack.dev/), faster and lighter way to run docker containers
- [IINA](https://iina.io/), modern media player for MacOS
- [Tailscale](https://tailscale.com/download)
- [TextSniper](https://textsniper.app/)
- [1password](https://1password.com/)
- [Yaak](https://yaak.app/)

## Font

- [JetBrainsMono Nerd Font](https://www.programmingfonts.org/#jetbrainsmono)

## Interesting programs I may or may not pickup

- [vimium c](https://github.com/gdh1995/vimium-c) vim key bindings for the browser
- [helix](https://github.com/helix-editor/helix) text editor inspired by neovim and kakoune
- [zellij](https://github.com/zellij-org/zellij) a terminal workspace, alternative to tmux
- [mise](https://github.com/jdx/mise), better tool management for dev environments
- [television](https://github.com/alexpasmantier/television), similar to fzf, but with more customization?
- [dozzle](https://github.com/amir20/dozzle), real time log viewer for containers
- [dtop](https://github.com/amir20/dtop), Terminal dashboard for Docker monitoring
- [herdr](https://github.com/ogulcancelik/herdr), tui for agent orchestration, similar to cmux, inspired by tmux

## Interesting Paid Products I may or may not pickup

- [TablePlus](https://tableplus.com/)
- [ProxyMan](https://proxyman.com/)
