# ~/.zshrc — interactive zsh config.
# oh-my-zsh removed; prompt is starship, plugins managed by sheldon.
# Completion (compinit + styles) and history come from zephyr — see plugins.toml.

# --- Shell behaviour ---
setopt auto_pushd           # cd pushes the old dir onto the stack
setopt pushd_ignore_dups
setopt interactive_comments # allow inline # comments

autoload -Uz zmv            # batch rename/copy/link; see mmv/zcp/zln in .aliases

# Edit the current command line in $EDITOR (ctrl-x ctrl-e).
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# --- Plugins (managed by sheldon; see ~/.config/sheldon/plugins.toml) ---
# (mise shims are on PATH via .zshenv, so the sheldon shim resolves here.)
command -v sheldon >/dev/null 2>&1 && eval "$(sheldon source)"

# --- Aliases & functions ---
zsh_sources=(
    "$HOME/.aliases"
    "$HOME/.functions"
)
for _f in "$zsh_sources[@]"; do [ -r "$_f" ] && source "$_f"; done
unset _f zsh_sources

# --- Tool integrations ---
[ -f "$HOME/.local/bin/mise" ] && eval "$($HOME/.local/bin/mise activate zsh)"
command -v fzf      >/dev/null 2>&1 && source <(fzf --zsh)
command -v zoxide   >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
