# dotfiles

My dotfiles for Neovim, zsh, tmux, and alacritty, optimized for web development
on macOS. Managed with [Dotbot](https://github.com/anishathalye/dotbot).

## Terminal

I use [Alacritty](https://alacritty.org/) as my terminal emulator.

- [ohmyzsh](https://ohmyz.sh/) as my shell, which some custom plugins. plugin includes [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) and [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

- Neovim on [0.8.2](https://github.com/neovim/neovim/releases/tag/v0.8.2)

```
curl -LO https://github.com/neovim/neovim/releases/download/v0.8.2/nvim-macos.tar.gz
tar xzf nvim-macos.tar.gz
./nvim-macos/bin/nvim
```

- [fnm](https://github.com/Schniz/fnm), fast and simple node version manager. faster than [nvm](https://github.com/nvm-sh/nvm)

- [trash-cli](https://github.com/sindresorhus/trash-cli), safeguard `rm`. Version 5 sometimes runs into node issues, stick with version 4 `npm install --global trash-cli@v4.0.0`. requires node

- [starship prompts](https://starship.rs/), minimal customizable prompts

- [homebrew](https://brew.sh/), package manager for macOS

```
brew install tmux lazygit jesseduffield/lazydocker/lazydocker exa zoxide fd ripgrep
```

- [tmux](https://github.com/tmux/tmux), terminal multiplexer

- [lazygit](https://github.com/jesseduffield/lazygit), simple terminal UI for git commands, requires git to be installed first

- [lazydocker](https://github.com/jesseduffield/lazydocker), the lazyier way to manage docker, requires docker to be installed first

- [exa](https://github.com/ogham/exa), replacement for `ls`

- [zoxide](https://github.com/ajeetdsouza/zoxide), smarter `cd`

- [fd](https://github.com/sharkdp/fd), simple, fast and user-friendly alternative to `find`

- [ripgrep](https://github.com/BurntSushi/ripgrep), fast regex text searching in directories

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

- [vlc](https://www.videolan.org/vlc/) - Best media player

## Font

- [Hack Nerd Font](https://www.nerdfonts.com/font-downloads)

## Interesting programs I may or may not pickup

- [nnn](https://github.com/jarun/nnn) terminal file manager
- [vimium c](https://github.com/gdh1995/vimium-c) vim key bindings for the browser
- [lf](https://github.com/gokcehan/lf) another terminal file manager
- [helix](https://github.com/helix-editor/helix) text editor inspired by neovim and kakoune
- [zellij](https://github.com/zellij-org/zellij) a terminal workspace, alternative to tmux
