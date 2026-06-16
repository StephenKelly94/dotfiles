#!/bin/bash
alias lg="lazygit"
alias lzd="lazydocker"
alias zshconfig="$EDITOR ~/.zshrc"
alias weather="curl 'wttr.in/copenhagen?m'"
alias fta="tmux_switcher"
alias ftk="tmux_kill_session"
alias kp="kill_process"

if command -v eza >/dev/null 2>&1; then
    alias ls='eza --git'                 # just replace ls by eza and allow all other eza arguments
    alias tree='eza --tree'              # tree view
    alias lS='eza -1'                    # one column by just names
fi

alias l='ls -lbF'              #   list, size, type
alias ll='ls -lah'             # long, all
alias llm='ll --sort=modified' # list, long, sort by modification date
alias la='ls -lbhHigUmuSa'     # all list
alias lx='ls -lbhHigUmuSa@'    # all list and extended

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
    for i in "${(f@)sessions}"; do
        if [[ $i =~ '([^:]*):.*' ]]; then
            echo "Killing $match[1]"
            tmux kill-session -t "$match[1]"
        fi
    done
}

kill_process() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}

jwt_decode() {
    jq -R 'split(".") |.[0:2] | map(@base64d) | map(fromjson)' <<< $1
}

kctx() {
    local ctx
    ctx=$(kubectl config get-contexts -o name | fzf \
        --preview 'kubectl get namespaces --context {} 2>/dev/null' \
        --preview-window right:60%)
    [ -n "$ctx" ] && kubectl config use-context "$ctx"
}

# fzf-pick a worktree from any repo under ~/dev/papi and cd into it
# Shows entries as: repo/worktree (branch)
wt() {
    local base=~/dev/papi
    local selected
    selected=$(
        for repo in "$base"/*/; do
            [ -e "$repo.git" ] || continue
            git -C "$repo" worktree list --porcelain | awk -v repo="$(basename "$repo")" '
                /^worktree /  { path=$2; name=path; sub(".*/", "", name) }
                /^bare$/      { path="" }
                /^branch /    { br=$2; sub("refs/heads/", "", br)
                                if (path != "") printf "%s/%s (%s)\t%s\n", repo, name, br, path }'
        done | fzf --exit-0 --delimiter='\t' --with-nth=1 \
            --preview 'git -C {2} log --oneline --decorate --graph --color=always -15' \
            --preview-window right:60%
    ) || { echo "No worktrees found."; return 1; }
    cd "$(cut -f2 <<< "$selected")"
}
