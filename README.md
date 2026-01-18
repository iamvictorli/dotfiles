# dotfiles

My dotfiles for Neovim, zsh, tmux, and alacritty on macOS. Managed with [Dotbot](https://github.com/anishathalye/dotbot).

## Installation

`git clone git@github.com:iamvictorli/dotfiles.git && cd dotfiles && ./install`

## Terminal

I use [Alacritty](https://alacritty.org/) as my terminal emulator.

- [ohmyzsh](https://ohmyz.sh/) as my shell, which some custom plugins. plugin includes [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) and [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

- Neovim on [0.11.2](https://github.com/neovim/neovim/releases/tag/v0.11.2), slowly migrating to [lazyvim](https://www.lazyvim.org/)

```
curl -LO https://github.com/neovim/neovim/releases/download/v0.11.2/nvim-macos.tar.gz
xattr -c ./nvim-macos-x86_64.tar.gz
tar xzvf nvim-macos-x86_64.tar.gz
./nvim-macos/bin/nvim
```

- [fnm](https://github.com/Schniz/fnm), fast and simple node version manager. faster than [nvm](https://github.com/nvm-sh/nvm)

- [trash-cli](https://github.com/sindresorhus/trash-cli), safeguard `rm`. Version 5 sometimes runs into node issues, stick with version 4 `npm install --global trash-cli@v4.0.0`. requires node

- [starship prompts](https://starship.rs/), minimal customizable prompts

- [homebrew](https://brew.sh/), package manager for macOS

```
# Replace with Brewfile
brew install zsh-autosuggestions zsh-syntax-highlighting tmux lazygit jesseduffield/lazydocker/lazydocker eza zoxide fd ripgrep fzf yazi ffmpeg sevenzip jq poppler resvg imagemagick font-symbols-only-nerd-font git-delta
```

- [yazi](https://github.com/sxyazi/yazi), terminal file manager

- [tmux](https://github.com/tmux/tmux), terminal multiplexer

- [lazygit](https://github.com/jesseduffield/lazygit), simple terminal UI for git commands, requires git to be installed first

- [lazydocker](https://github.com/jesseduffield/lazydocker), the lazier way to manage docker, requires docker to be installed first

- [eza](https://github.com/eza-community/eza), replacement for `ls`

- [zoxide](https://github.com/ajeetdsouza/zoxide), smarter `cd`

- [fd](https://github.com/sharkdp/fd), simple, fast and user-friendly alternative to `find`

- [ripgrep](https://github.com/BurntSushi/ripgrep), fast regex text searching in directories

- [fzf](https://github.com/junegunn/fzf), command line fuzzy finder

- [delta](https://github.com/dandavison/delta), A syntax-highlighting pager for git diff, <https://x.com/rauchg/status/1831421759666676165>, <https://cpojer.net/posts/the-perfect-development-environment#bat-and-delta>

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

- [Docker Desktop](https://docs.docker.com/desktop/setup/install/mac-install/)
- [vlc](https://www.videolan.org/vlc/) - Best media player
- [Tailscale](https://tailscale.com/download)
- [TextSniper](https://textsniper.app/), could be replaced with Raycast
- [1password](https://1password.com/)

## Font

- [JetBrainsMono Nerd Font](https://www.programmingfonts.org/#jetbrainsmono)

## Interesting programs I may or may not pickup

- [vimium c](https://github.com/gdh1995/vimium-c) vim key bindings for the browser
- [helix](https://github.com/helix-editor/helix) text editor inspired by neovim and kakoune
- [zellij](https://github.com/zellij-org/zellij) a terminal workspace, alternative to tmux
- [mise](https://github.com/jdx/mise), better tool management for dev environments
- [brewfile](https://docs.brew.sh/Brew-Bundle-and-Brewfile), A Brewfile is a plain-text manifest (written in a simple Ruby DSL) that lists everything you want Homebrew to “bundle” for you—taps, formulae, casks, Mac App Store apps, fonts, and even macOS defaults. Think of it like a Gemfile or package.json for your Homebrew setup.
- [Ghostty](https://github.com/ghostty-org/ghostty), Another terminal emulator, can replace tmux as well?
- [Raycast](https://www.raycast.com/), replaces command prompt, comes with clipboard history, window management, and more
- [OrbStack](https://orbstack.dev/), replaces Docker Desktop
- [IINA](https://iina.io/), another media player, but for macos, can replace vlc

## Paid Products

- [TablePlus](https://tableplus.com/)
- [ProxyMan](https://proxyman.com/)
