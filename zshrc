# Set up the prompt

setopt histignorealldups

# Custom path
if [ -d "$home/bin" ] ; then
    export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
fi

### Load and configure antigen
#
source ~/.antigen.zsh

antigen use oh-my-zsh
antigen bundle virtualenv
antigen bundle django
antigen bundle debian
antigen bundle mercurial
antigen bundle zsh-users/zsh-syntax-highlighting
#antigen bundle tonyseek/oh-my-zsh-virtualenv-prompt virtualenv-prompt.plugin.zsh
#antigen bundle git
#antigen bundle gitfast
antigen bundle git-prompt
#antigen theme agnoster
#antigen theme tonyseek/oh-my-zsh-seeker-theme seeker

antigen apply

source "$HOME/.zsh/my.zsh-theme"

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

#export VIRTUAL_ENV_DISABLE_PROMPT=1
#
#ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX="("
#ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX=")"
#
#function virtualenv_prompt_info() {
#    if [ -n "$VIRTUAL_ENV" ]; then
#        if [ -f "$VIRTUAL_ENV/__name__" ]; then
#            local name=`cat $VIRTUAL_ENV/__name__`
#        elif [ `basename $VIRTUAL_ENV` = "__" ]; then
#            local name=$(basename $(dirname $VIRTUAL_ENV))
#        else
#            local name=$(basename $VIRTUAL_ENV)
#        fi
#        echo "$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX$name$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX"
#    fi
#}

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

_backward-delete-to-slash () {
    local WORDCHARS=${_my_extended_wordchars}
    zle .backward-kill-word
    _unquote-backward-delete-word
}

_forward-delete-to-space() {
    local WORDCHARS=${_my_extended_wordchars_slash}
    zle .kill-word
    _unquote-forward-delete-word
}

_forward-delete-to-slash () {
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

_backward-to-slash () {
    local WORDCHARS=${_my_extended_wordchars}
    zle .backward-word
    _unquote-backward-word
}

_forward-to-slash () {
     local WORDCHARS=${_my_extended_wordchars}
     zle .forward-word
     _unquote-forward-word
}

zle -N _backward-delete-to-slash
zle -N _forward-delete-to-slash
zle -N _backward-delete-to-space
zle -N _forward-delete-to-space
zle -N _backward-to-slash
zle -N _forward-to-slash
bindkey '^w'      _backward-delete-to-slash
bindkey '^[^w'    _backward-delete-to-space
bindkey "^[^[[D"  _backward-to-slash
bindkey "^[^[[C"  _forward-to-slash
bindkey "^[^B"    _backward-to-slash
bindkey "^[^F"    _forward-to-slash
bindkey "^[^?"    _backward-delete-to-slash
bindkey "^[^[[3~" _forward-delete-to-slash

bindkey "[1;5D" _backward-to-slash
bindkey "[1;5C" _forward-to-slash

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
alias du='du -hc --max-depth=1'

# Enable intelligent command-not-found handling

if [[ -s '/etc/zsh_command_not_found' ]]; then
	source '/etc/zsh_command_not_found'
fi

setopt AUTO_CD
setopt AUTO_PUSHD
setopt AUTO_NAME_DIRS
setopt PUSHD_SILENT

cd-up() {
	cd ..
	zle reset-prompt
}
pop-dir() {
	popd > /dev/null
	zle reset-prompt
}
unpop-dir() {
	cd -1 > /dev/null
	zle reset-prompt
}

zle -N cd-up
zle -N pop-dir
zle -N unpop-dir

# Meta-u to chdir to the parent directory
bindkey '\eu' cd-up #'^Ucd ..; ls^M'

# If AUTO_PUSHD is set, Meta-p pops the dir stack
bindkey '\ep' pop-dir
bindkey '\en' unpop-dir

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
