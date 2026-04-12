# tmux aliases (adapted from oh-my-zsh tmux plugin)

if ! (( $+commands[tmux] )); then
  return 0
fi

# Helper to build smart aliases that auto-append -t/-s flags
function _build_tmux_alias {
  setopt localoptions no_rc_expand_param
  eval "function $1 {
    if [[ -z \$1 ]] || [[ \${1:0:1} == '-' ]]; then
      tmux $2 \"\$@\"
    else
      tmux $2 $3 \"\$@\"
    fi
  }"
}

# Simple aliases
alias tksv='tmux kill-server'
alias tl='tmux list-sessions'

# Smart aliases (auto-append session flag when argument provided)
_build_tmux_alias "ta" "attach" "-t"
_build_tmux_alias "to" "new-session -A" "-s"
_build_tmux_alias "ts" "new-session" "-s"
_build_tmux_alias "tkss" "kill-session" "-t"

unfunction _build_tmux_alias
