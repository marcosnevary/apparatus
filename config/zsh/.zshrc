eval "$(/opt/homebrew/bin/brew shellenv)"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="minimal"
plugins=(
    git
    brew
    python
    zsh-autosuggestions
    zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

export PATH="$HOME/.local/bin:$PATH"
export PATH="/Library/TeX/texbin:$PATH"

export HOMEBREW_AUTO_UPDATE_SECS=86400
export HOMEBREW_NO_ENV_HINTS=1
