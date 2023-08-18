alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias lg="lazygit"
alias fd="fdfind"
alias zshconfig="$EDITOR ~/.zshrc"
# alias tmux="tmux -2"
alias weather="curl 'wttr.in/copenhagen?m'"

if [ $(command -v exa) ]; then
    alias ls='exa'                 # just replace ls by exa and allow all other exa arguments
    alias l='ls -lbF'              #   list, size, type
    alias ll='ls -la'              # long, all
    alias llm='ll --sort=modified' # list, long, sort by modification date
    alias la='ls -lbhHigUmuSa'     # all list
    alias lx='ls -lbhHigUmuSa@'    # all list and extended
    alias tree='exa --tree'        # tree view
    alias lS='exa -1'              # one column by just names
fi
