# ~/.zshrc — interactive zsh config.
# oh-my-zsh removed; prompt is starship, plugins managed by sheldon.
# Completion (compinit + styles) and history come from zephyr — see plugins.toml.

# --- Shell behaviour ---
setopt auto_pushd           # cd pushes the old dir onto the stack
setopt pushd_ignore_dups
setopt interactive_comments # allow inline # comments

# --- zsh-vi-mode config (set before the plugin loads below) ---
# Bind eagerly, not lazily, so our custom vicmd binds reliably win over zvm's.
ZVM_LAZY_KEYBINDINGS=false
# Called by zsh-vi-mode after it initialises (so our binds override its own).
# `zce` widget comes from the zce.zsh plugin loaded via sheldon.
function zvm_after_init() {
    bindkey -M vicmd 's' zce                              # vi normal mode: s → ace-jump
    command -v fzf >/dev/null 2>&1 && source <(fzf --zsh) # re-apply fzf keybinds after zvm
}

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
