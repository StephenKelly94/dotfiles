export EDITOR='nvim'
export PAGER='less'
export PATH=$PATH:\
$HOME/bin:\
$HOME/.local/bin:\
$HOME/.config/emacs/bin

# Check if mise is installed with mix escripts directory
if [ $(command -v mise) ] && [ -d $elixir_loc/.mix/escripts ]; then
    elixir_loc=$(mise where elixir)
    export PATH=$PATH:$elixir_loc/.mix/escripts
fi
