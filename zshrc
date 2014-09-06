# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Custom path
if [ -d "$home/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

### Custom functions to allow deleting path elements

_my_extended_wordchars='*?_-.[]~=&;!#$%^(){}<>:@,\\';
_my_extended_wordchars_space="${my_extended_wordchars} "
_my_extended_wordchars_slash="${my_extended_wordchars}/"

# is the current position \-quoted ?
function _is_quoted(){
 test "${BUFFER[$CURSOR-1,CURSOR-1]}" = "\\"
}

_unquote-backward-delete-word(){
    while  _is_quoted
      do zle .backward-kill-word
    done
}

_unquote-forward-delete-word(){
    while  _is_quoted
      do zle .kill-word
    done
}

_unquote-backward-word(){
    while  _is_quoted
      do zle .backward-word
    done
}

_unquote-forward-word(){
    while _is_quoted
      do zle .forward-word
    done
}

_backward-delete-to-space() {
    local WORDCHARS=${_my_extended_wordchars_slash}
    zle .backward-kill-word
    _unquote-backward-delete-word
}

_backward-delete-to-/ () {
    local WORDCHARS=${_my_extended_wordchars}
    zle .backward-kill-word
    _unquote-backward-delete-word
}

_forward-delete-to-space() {
    local WORDCHARS=${_my_extended_wordchars_slash}
    zle .kill-word
    _unquote-forward-delete-word
}

_forward-delete-to-/ () {
    local WORDCHARS=${_my_extended_wordchars}
    zle .kill-word
    _unquote-forward-delete-word
}

_backward-to-space() {
    local WORDCHARS=${_my_extended_wordchars_slash}
    zle .backward-word
    _unquote-backward-word
}

_forward-to-space() {
     local WORDCHARS=${_my_extended_wordchars_slash}
     zle .forward-word
     _unquote-forward-word
}

_backward-to-/ () {
    local WORDCHARS=${_my_extended_wordchars}
    zle .backward-word
    _unquote-backward-word
}

_forward-to-/ () {
     local WORDCHARS=${_my_extended_wordchars}
     zle .forward-word
     _unquote-forward-word
}

zle -N _backward-delete-to-/
zle -N _forward-delete-to-/
zle -N _backward-delete-to-space
zle -N _forward-delete-to-space
zle -N _backward-to-/
zle -N _forward-to-/
bindkey '^w'      _backward-delete-to-/
bindkey '^[^w'    _backward-delete-to-space
bindkey "^[^[[D"  _backward-to-/
bindkey "^[^[[C"  _forward-to-/
bindkey "^[^B"    _backward-to-/
bindkey "^[^F"    _forward-to-/
bindkey "^[^?"    _backward-delete-to-/
bindkey "^[^[[3~" _forward-delete-to-/

bindkey "[1;5D" _backward-to-/
bindkey "[1;5C" _forward-to-/

bindkey "^U" undo

autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey "^[m" copy-earlier-word

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Enable colours in ls and grep

alias ls='ls --color=auto'
alias grep='grep --colour=auto'

# Enable intelligent command-not-found handling

if [[ -s '/etc/zsh_command_not_found' ]]; then
	source '/etc/zsh_command_not_found'
fi

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
