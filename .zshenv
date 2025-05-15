function _slow_load_warning {
    local lock_file="/tmp/.hyde_slow_load_warning.lock"
    local load_time=$SECONDS

    # Check if the lock file exists
    if [[ ! -f $lock_file ]]; then
        # Create the lock file
        touch $lock_file

        # Display the warning if load time exceeds the limit
        time_limit=3
        if ((load_time > time_limit)); then
            cat <<EOF
    ⚠️ Warning: Shell startup took more than ${time_limit} seconds. Consider optimizing your configuration.
        1. This might be due to slow plugins, slow initialization scripts.
        2. Duplicate plugins initialization.
            - navigate to ~/.zshrc and remove any 'source ZSH/oh-my-zsh.sh' or
                'source ~/.oh-my-zsh/oh-my-zsh.sh' lines.
            - HyDE already sources the oh-my-zsh.sh file for you.
            - It is important to remove all HyDE related
                configurations from your .zshrc file as HyDE will handle it for you.
            - Check the '.zshrc' file from the repo for a clean configuration.
                https://github.com/HyDE-Project/HyDE/blob/master/Configs/.zshrc
        3. Check the '~/.hyde.zshrc' file for any slow initialization scripts.

    For more information, on the possible causes of slow shell startup, see:
        🌐 https://github.com/HyDE-Project/HyDE/wiki

EOF
        fi
    fi
}

function _load_persistent_aliases {
    # Persistent aliases are loaded after the plugin is loaded
    # This way omz will not override them
    unset -f _load_persistent_aliases

    if [[ -x "$(command -v eza)" ]]; then
        alias l='eza -l --icons=auto' \
            ll='eza -la --icons=auto --sort=name --group-directories-first' \
            ld='eza -lD --icons=auto' \
            lt='eza --icons=auto --tree' \
            ls='eza'
    fi
    if [[ -x "$(command -v rg)" ]]; then
        alias grep='rg --color=auto'
    fi
    if [[ -x "$(command -v bat)" ]]; then
        alias cat='bat'
    fi
    if [[ -x "$(command -v nvim)" ]]; then
        alias vi='nvim' \
              vim='nvim'
    fi
    if [[ -x "$(command -v python3)" ]]; then
        alias python='python3'
    fi
}


function _load_post_init() {
    #! Never load time consuming functions here
    _load_persistent_aliases

    autoload -U compinit && compinit

    # Load hydectl completion
    if command -v hydectl &>/dev/null; then
        compdef _hydectl hydectl
        eval "$(hydectl completion zsh)"
    fi

    # Initiate fzf
    if command -v fzf &>/dev/null; then
        eval "$(fzf --zsh)"
    fi

    if command -v bat &>/dev/null; then
        eval "$(bat --completion zsh )"
    fi
    if command -v rg &>/dev/null; then
        eval "$(rg --generate complete-zsh)"
    fi
    if command -v kubectl &>/dev/null; then
        eval "$(kubectl completion zsh)"
    fi
    if command -v zoxide &>/dev/null; then
        eval "$(zoxide init --cmd cd zsh)"
    fi

    # User rc file always overrides
    [[ -f $HOME/.zshrc ]] && source $HOME/.zshrc

}

function _load_if_terminal {
    if [ -t 1 ]; then

        unset -f _load_if_terminal

        if uname -a | grep -vqi 'nixos'; then # nixos is not FHS compliant so all tools have to be installed within nixos itself
            # Check if mise is already installed
            if [[ -x "$(command -v $HOME/.local/bin/mise)" ]]; then
                # Initialize mise 
                eval "$($HOME/.local/bin/mise activate zsh)"
            else
                echo "mise (en place) not found. Installing..."
                curl https://mise.run | sh
                eval "$($HOME/.local/bin/mise activate zsh)"
                mise doctor
                mise install
            fi
        fi

        # Currently We are loading Starship and p10k prompts on start so users can see the prompt immediately

        if command -v starship &>/dev/null; then
            # ===== START Initialize Starship prompt =====
            eval "$(starship init zsh)"
            export STARSHIP_CACHE=$XDG_CACHE_HOME/starship
            export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/starship.toml
        # ===== END Initialize Starship prompt =====
        elif [ -r $HOME/.p10k.zsh ]; then
            # ===== START Initialize Powerlevel10k theme =====
            POWERLEVEL10K_TRANSIENT_PROMPT=same-dir
            P10k_THEME=${P10k_THEME:-/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme}
            [[ -r $P10k_THEME ]] && source $P10k_THEME
            # To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh
            [[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh
        # ===== END Initialize Powerlevel10k theme =====
        fi

        # Optionally load user configuration // useful for customizing the shell without modifying the main file
        if [[ -f $HOME/.user.zsh ]]; then
            source $HOME/.user.zsh # renamed to .user.zsh for intuitiveness that it is a user config
        fi

        # Load plugins
        _load_zsh_plugins

        # Load zsh hooks module once

        #? Methods to load oh-my-zsh lazily
        __ZDOTDIR="${ZDOTDIR:-$HOME}"
        ZDOTDIR=/tmp
        zle -N zle-line-init _load_omz_on_init # Loads when the line editor initializes // The best option

        #  Below this line are the commands that are executed after the prompt appears

        autoload -Uz add-zsh-hook
        # add-zsh-hook zshaddhistory load_omz_deferred # loads after the first command is added to history
        # add-zsh-hook precmd load_omz_deferred # Loads when shell is ready to accept commands
        # add-zsh-hook preexec load_omz_deferred # Loads before the first command executes

        # Warn if the shell is slow to load
        add-zsh-hook -Uz precmd _slow_load_warning

        alias c='clear' \
            vc='code' \
            vsc='code' \
            fastfetch='fastfetch --logo-type kitty' \
            ..='cd ..' \
            ...='cd ../..' \
            .3='cd ../../..' \
            .4='cd ../../../..' \
            .5='cd ../../../../..' \
            mkdir='mkdir -p' \
            ffec='_fuzzy_edit_search_file_content' \
            ffcd='_fuzzy_change_directory' \
            ffe='_fuzzy_edit_search_file'

        # Some binds won't work on first prompt when deferred
        bindkey '\e[H' beginning-of-line
        bindkey '\e[F' end-of-line
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        # bindkey -e
        # bindkey '^f' autosuggest-accept
        # bindkey '^p' history-search-backward
        # bindkey '^n' history-search-forward
        # bindkey '^[w' kill-region
    fi

}

# History configuration // explicit to not nuke history
HISTFILE=${HISTFILE:-$HOME/.zsh_history}
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY       # Write the history file in the ':start:elapsed;command' format
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits
setopt SHARE_HISTORY          # Share history between all sessions
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded again
setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate
setopt hist_ignore_space

export HISTFILE

_load_if_terminal

