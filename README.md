# dotfiles

My dotfiles for Neovim, zsh, tmux, and ghostty on macOS. Managed with [Dotbot](https://github.com/anishathalye/dotbot).

## Installation

Install dotbot and symlink:

`git clone git@github.com:iamvictorli/dotfiles.git && cd dotfiles && ./install`

Install with `Brewfile`:

`brew bundle install`

Cleanup anything not in the `Brewfile`:

`brew bundle cleanup --force`

## Terminal

I use [Ghostty](https://ghostty.org/) as my terminal emulator.

- [homebrew](https://brew.sh/), package manager for macOS

- [ohmyzsh](https://ohmyz.sh/) with zsh shell.

- [fnm](https://github.com/Schniz/fnm), fast and simple node version manager. faster than [nvm](https://github.com/nvm-sh/nvm)

- [trash-cli](https://github.com/sindresorhus/trash-cli), safeguard `rm`. Version 5 sometimes runs into node issues, stick with version 4 `npm install --global trash-cli@v4.0.0`. requires node

- [starship prompts](https://starship.rs/), minimal customizable prompts

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
- [OrbStack](https://orbstack.dev/), replaces Docker Desktop

## Interesting Paid Products I may or may not pickup

- [TablePlus](https://tableplus.com/)
- [ProxyMan](https://proxyman.com/)
