alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias lg="lazygit"
alias lzd="lazydocker"
alias fd="fdfind"
alias zshconfig="$EDITOR ~/.zshrc"
alias weather="curl 'wttr.in/copenhagen?m'"
alias ftldr="tldr --list | fzf --preview 'tldr {} --color always' | xargs tldr"
alias fta="tmux_switcher"
alias ftk="tmux_kill_session"
alias kp="kill_process"
# Mnemonic [V]ersion [M]anager [I]nstall
alias vmi="asdf_install"
# Mnemonic [V]ersion [M]anager [C]lean
alias vmc="asdf_remove"

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

# Install one or more versions of specified language
# e.g. `vmi rust` # => fzf multimode, tab to mark, enter to install
# if no plugin is supplied (e.g. `vmi<CR>`), fzf will list them for you
asdf_install() {
    local lang=${1}

    if [[ ! $lang ]]; then
        lang=$(asdf plugin-list | fzf)
    fi

    if [[ $lang ]]; then
        local versions=$(asdf list-all $lang | fzf --tac --no-sort --multi)
        if [[ $versions ]]; then
            for version in $(echo $versions);
            do; asdf install $lang $version; done;
        fi
    fi
}

# Remove one or more versions of specified language
# e.g. `vmi rust` # => fzf multimode, tab to mark, enter to remove
# if no plugin is supplied (e.g. `vmi<CR>`), fzf will list them for you
asdf_remove() {
    local lang=${1}

    if [[ ! $lang ]]; then
        lang=$(asdf plugin-list | fzf)
    fi

    if [[ $lang ]]; then
        local versions=$(asdf list $lang | fzf -m)
        if [[ $versions ]]; then
            for version in $(echo $versions);
            do; asdf uninstall $lang $version; done;
        fi
    fi
}

jwt_decode() {
    jq -R 'split(".") |.[0:2] | map(@base64d) | map(fromjson)' <<< $1
}

open_pod(){
    POD_NAME=$(kubectl get pods --no-headers | fzf | awk '{print $1}')
    echo "Opening pod $POD_NAME..."
    kubectl exec -ti $POD_NAME -- /bin/sh
}
