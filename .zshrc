
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

# Source/Load zinit
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# Load completions
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Keybindings
# bindkey -e
# bindkey '^f' autosuggest-accept
# bindkey '^p' history-search-backward
# bindkey '^n' history-search-forward
# bindkey '^[w' kill-region
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# History
HISTSIZE=1000000
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ZSH options
# setopt correct
setopt auto_cd

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza $realpath'


#kubernetes krew bin directory
if [ -d "$HOME/.krew" ] ; then
  PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi

# Check if mise is already installed
if [[ -x "$(command -v $HOME/.local/bin/mise)" ]]; then
  # Initialize mise 
  eval "$($HOME/.local/bin/mise activate zsh)"
else
  echo "mise (en place) not found. Installing..."
  curl https://mise.run | sh
  eval "$($HOME/.local/bin/mise activate zsh)"
  mise doctor && mise install
fi

# Check if starship is already installed
if [[ -x "$(command -v starship)" ]]; then
  # Initialize starship prompt if it's installed
  eval "$(starship init zsh)"
else
  echo "Starship prompt not found. Please fix mise config."
  # curl -sS https://starship.rs/install.sh | sh
fi

## Check if homebrew is already installed
#if [ ! -d "/home/linuxbrew/.linuxbrew/bin" ] ; then
#  echo "Homebrew not found. Installing..."
#  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
#fi
#eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#
#if [[ ! -x "$(command -v thefuck)" ]]; then
#  echo "thefuck not found. Installing..."
#  brew install thefuck
#fi

# Add in snippets
# zinit snippet OMZL::git.zsh
# # zinit snippet OMZP::aliases
# zinit snippet OMZP::git
# zinit snippet OMZP::sudo
# zinit snippet OMZP::archlinux
# zinit snippet OMZP::aws
# zinit snippet OMZP::kubectl
# zinit snippet OMZP::kubectx
# zinit snippet OMZP::command-not-found

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# # Aliases
alias ls='eza --icons=always'
alias lss='eza'
alias grep='rg --color=auto'
alias cat='bat'
alias vi='nvim'
alias vim='nvim'
alias c='clear'
alias python='python3'


EDITOR='$(mise which nvim)'

function mise_pin() {
  mise use $1@$(mise latest $1)
}

alias mise_update='mise upgrade --bump'
alias update_fonts='sudo fc-cache -fv'

# Shell integrations
if [[ -x "$(command -v fzf)" ]]; then; source <(fzf --zsh); fi
if [[ -x "$(command -v kubectl)" ]]; then; source <(kubectl completion zsh); fi

eval "$(zoxide init --cmd cd zsh)"
#eval $(thefuck --alias)

