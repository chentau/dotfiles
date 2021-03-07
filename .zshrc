setopt histignorealldups sharehistory inc_append_history
setopt prompt_subst
setopt hist_ignore_space
setopt auto_pushd
setopt ignore_eof

source ~/.zsh_plugins.sh

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 10000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

export PATH=$PATH:~/.local/bin
export TERMINFO=/usr/share/terminfo

# history substring search
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

function prompt-pwd {
    setopt localoptions extendedglob
    
    # replaces $HOME with ~
    local current_pwd="${PWD/#$HOME/~}"

    if [[ "$current_pwd" == (#m)[/~] ]]; then
	ret_directory="$MATCH"
	unset MATCH
    # liberally commenting the following line
    # ${name##pattern} deletes the largest matching portion of name, starting from beginning
    # ${name%pattern} deletes the shortest mtching portion of name, starting from end
    # ${name//pattern/repl} replaces longest match of pattern with repl in name
    # inside the parentheses,
    # 	@ - split array elements into separate words
    # 	j:string: - joins together an array by string
    # 	s:string: - splits on string
    # 	M - include matched part in result
    else
        ret_directory="${${${${(@j:/:M)${(@s:/:)current_pwd}##.#?}:h}%/}//\%/%%}/${${current_pwd:t}//\%/%%}"
        unset current_pwd
    fi 
    
    print "$ret_directory"
}

export PROMPT='%F{3}[%f%F{4}%n%F{5}@%f%F{1}%m%f%F{3}]%f%F{1}[%f%F{4}$(prompt-pwd)%f%F{1}]%f%(!. %B%F{1}#%f%b.) %B%F{1}❯%F{3}❯%F{2}❯%f%b '
export RPROMPT='%(?. .%F{1}%?%f)'
export SPROMPT='zsh: correct %F{1}%R%f to %F{2}%r%f [nyae]? '

# Setup fzf
# ---------
# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/tony/Downloads/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/tony/Downloads/.fzf/shell/key-bindings.zsh"

export FZF_DEFAULT_OPTS="--layout=reverse --height 40% --multi"

CONDA_AUTO_ACTIVATE_BASE=false

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/tony/.local/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/tony/.local/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/tony/.local/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/tony/.local/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# user functions
function light_or_dark {
    # convert hex to rgb
    hexinput="$(echo $1 | tr "[:lower:]" "[:upper:]")"
    r="$(echo $hexinput | cut -c 2-3)"
    g="$(echo $hexinput | cut -c 4-5)"
    b="$(echo $hexinput | cut -c 6-7)"

    r=$(echo "ibase=16; $r" | bc)
    g=$(echo "ibase=16; $g" | bc)
    b=$(echo "ibase=16; $b" | bc)

    # 0 for light, 1 for dark
    return $(($r * $r + $g * $g + $b * $b > 16256.25))
}

HOSTNAME="$(hostname)"  # Conda clobbers HOST, so we save the real hostname into another variable.

precmd() {
    OLDHOST="${HOST}"
    HOST="${HOSTNAME}"
}

preexec() {
    HOST="${OLDHOST}"
}

# aliases
alias vim=nvim
alias ls=exa
alias fd=fdfind
alias nv="nvim-nightly -u ${HOME}/.config/nvim/nightly.vim"

alias py="python3 -i -c 'import numpy as np; import matplotlib.pyplot as plt'"

alias bat=bat --theme="$(light_or_dark "$(head -2 ~/.cache/wal/colors | tail -1)" && echo github || echo OneHalfLight)"
