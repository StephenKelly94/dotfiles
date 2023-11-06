alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias lg="lazygit"
alias lzd="lazydocker"
alias fd="fdfind"
alias zshconfig="$EDITOR ~/.zshrc"
alias weather="curl 'wttr.in/copenhagen?m'"
alias ftldr="tldr --list | fzf --preview 'tldr {} --color always' | xargs tldr"
alias fta="tmux_switcher"
alias ftk="tmux_kill_session"

if [ $(command -v eza) ]; then
    alias ls='eza'                 # just replace ls by eza and allow all other eza arguments
    alias l='ls -lbF'              #   list, size, type
    alias ll='ls -lah'              # long, all
    alias llm='ll --sort=modified' # list, long, sort by modification date
    alias la='ls -lbhHigUmuSa'     # all list
    alias lx='ls -lbhHigUmuSa@'    # all list and extended
    alias tree='eza --tree'        # tree view
    alias lS='eza -1'              # one column by just names
fi

tmux_switcher() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

tmux_kill_session() {
    local sessions
    sessions="$(tmux ls|fzf --exit-0 --multi)"  || return $?
    local i
    for i in "${(f@)sessions}"
    do
        [[ $i =~ '([^:]*):.*' ]] && {
            echo "Killing $match[1]"
            tmux kill-session -t "$match[1]"
        }
    done
}
