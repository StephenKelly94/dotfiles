export EDITOR='nvim'
export PAGER='less'

export PATH=$PATH:\
$HOME/bin:\
$HOME/.local/bin:\
$HOME/.bun/bin:\
$HOME/.config/emacs/bin

# mise shims: makes mise-managed tools resolve in non-interactive shells too
# (tmux run-shell, scripts), not just interactive ones via `mise activate`.
export PATH="$HOME/.local/share/mise/shims:$PATH"

export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
