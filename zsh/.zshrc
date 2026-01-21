export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY
setopt autocd

# Cache init scripts - regenerate only when binary changes
_cache_init() {
  local name=$1 bin=$2 cmd=$3
  local cache_dir="${${(%):-%x}:A:h}/.cache"
  local cache_file="$cache_dir/$name.zsh"
  
  [[ -d $cache_dir ]] || mkdir -p "$cache_dir"
  
  if [[ ! -f $cache_file || $bin -nt $cache_file ]]; then
    eval "$cmd" > "$cache_file"
  fi
  source "$cache_file"
}

# Lazy-load compinit - only runs on first Tab press
autoload -Uz compinit
_lazy_compinit() {
  if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
  else
    compinit -C
  fi
  compdef -d oc  # disable completions for oc alias
  zle -A expand-or-complete _complete_orig  # restore original Tab
  unfunction _lazy_compinit
  zle expand-or-complete  # run completion for this Tab press
}
zle -A expand-or-complete _complete_orig  # save original
zle -N expand-or-complete _lazy_compinit  # override Tab

export EDITOR='nvim'

# https://yazi-rs.github.io/docs/quick-start
# y shell wrapper that provides the ability to change the current working directory when exiting Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# https://github.com/folke/tokyonight.nvim/blob/main/extras/fzf/tokyonight_storm.sh
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none \
  --color=bg+:#2e3c64 \
  --color=bg:#1f2335 \
  --color=border:#29a4bd \
  --color=fg:#c0caf5 \
  --color=gutter:#1f2335 \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#29a4bd \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"

# https://github.com/sindresorhus/trash-cli?tab=readme-ov-file#tip
alias rm=trash

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# View staged files with delta
alias gds="git diff --staged --color=always | delta --paging=always"
# View unstaged files with delta
alias gdu="git diff --color=always | delta --paging=always"

alias lzd="lazydocker"
alias lg="lazygit"
alias oc='opencode'
alias ks='tmux kill-server'
alias scratch='nvim -c "setlocal buftype=nofile"'

# vim: open current dir if no args
vim() {
  if [[ $# -eq 0 ]]; then
    nvim .
  else
    nvim "$@"
  fi
}

alias c='vim'

# better "ls" with eza
alias ll="eza -l -g --icons --git"
alias llt="eza -1 --icons --tree --git-ignore"

_cache_init starship "$(which starship)" 'starship init zsh'

_cache_init fnm "$(which fnm)" 'fnm env --use-on-cd --shell zsh'

_cache_init fzf "$(which fzf)" 'fzf --zsh'

source "${${(%):-%x}:A:h}/tmux.zsh"
