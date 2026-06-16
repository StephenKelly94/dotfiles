if status is-interactive
    # mise
    mise activate fish | source

    # Start tmux if not already inside
    if not set -q TMUX
        exec tmux new-session -A -s main
    end

    # Starship prompt
    starship init fish | source

    # PATH
    fish_add_path $HOME/bin
    fish_add_path $HOME/.local/bin
    fish_add_path $HOME/.local/neovim/bin
    fish_add_path $HOME/.bun/bin

    # Editor
    set -gx EDITOR nvim
    set -gx VISUAL nvim

    # Vi mode
    fish_vi_key_bindings
    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_visual underscore

    # Abbreviations
    abbr -a g git
    abbr -a v nvim
    abbr -a la ls -la
    abbr -a .. cd ..
    abbr -a ... cd ../..
end
