# oh-my-zsh Bureau Theme

autoload -Uz vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:hg:*' get-revision true
zstyle ':vcs_info:*' formats '%c%u %F{5}[%F{2}%b%F{5}]%f'
zstyle ':vcs_info:*' branchformat '%b'
zstyle ':vcs_info:*' actionformats '%c%u %F{5}[%F{2}%b%F{5}%F{red}| %a]%f'
zstyle ':vcs_info:*' unstagedstr '%F{red}⚫'
zstyle ':vcs_info:*' stagedstr '%F{green}⚫'
#zstyle ':vcs_info:*' unstagedstr ' %F{orange}✹'
#zstyle ':vcs_info:*' stagedstr '%F{green}✚'
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git svn hg

### NVM

ZSH_THEME_NVM_PROMPT_PREFIX="%B⬡%b "
ZSH_THEME_NVM_PROMPT_SUFFIX=""

### Git [±master ▾●]

ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg_bold[green]%}±%{$reset_color%}%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%}▴%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%}▾%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[yellow]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"

bureau_git_branch () {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

bureau_git_status () {
  INDEX=$(command git status --porcelain -b 2> /dev/null)
  STATUS=""
  if $(echo "$INDEX" | grep '^[AMRD]. ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
  fi
  if $(echo "$INDEX" | grep '^.[MTD] ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi
  if $(echo "$INDEX" | command grep -E '^\?\? ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi
  if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi
  if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STASHED"
  fi
  if $(echo "$INDEX" | grep '^## .*ahead' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
  if $(echo "$INDEX" | grep '^## .*behind' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_BEHIND"
  fi
  if $(echo "$INDEX" | grep '^## .*diverged' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_DIVERGED"
  fi

  echo $STATUS
}

bureau_git_prompt () {
  local _branch=$(bureau_git_branch)
  local _status=$(bureau_git_status)
  local _result=""
  if [[ "${_branch}x" != "x" ]]; then
    _result="$ZSH_THEME_GIT_PROMPT_PREFIX$_branch"
    if [[ "${_status}x" != "x" ]]; then
      _result="$_result $_status"
    fi
    _result="$_result$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
  echo $_result
}

truncate_wd () {
	local wd=$1
	local wd_maxlen=$2
	local wd_startlen=$3
	local wd_endlen=$(( $wd_maxlen - $wd_startlen ))

	if [ ${#wd} -gt $wd_maxlen ]; then
		local wdoffset=$(( ${#wd} - $wd_endlen ))
		wd="${wd:0:$wd_startlen}…${wd:$wdoffset:$wd_endlen}"
	fi
	echo $wd
}

WD='%{$fg_bold[yellow]%}$(truncate_wd `print -P %~` 50 10)%{$reset_color%}'
SHORTWD='%{$fg_bold[white]%}$(truncate_wd `print -P %1~` 12 3)%{$reset_color%}'

if [[ $EUID -eq 0 ]]; then
  USERHOST="%{$fg_bold[red]%}%n"
  LIBERTY="%{$fg[red]%}#"
else
  USERHOST="%{$fg_bold[white]%}%n"
  LIBERTY="%{$fg[green]%}$"
fi
if [[ -n "$SSH_CLIENT" ]]; then
	USERHOST="$USERHOST%{$reset_color%}@%{$fg_bold[red]%}%m"
else
	USERHOST="$USERHOST%{$reset_color%}@%m"
fi
LIBERTY="$LIBERTY%{$reset_color%}"


get_space () {
  local STR=$1$2
  local zero='%([BSUbfksu]|([FB]|){*})'
  local LENGTH=${#${(S%%)STR//$~zero/}} 
  local SPACES=""
  (( LENGTH = ${COLUMNS} - $LENGTH - 1 ))
  
  SPACES=${(l:$LENGTH:: :)}

  echo $SPACES
}

if type "virtualenv_prompt_info" > /dev/null
then
	VENV='%{$fg[green]%}$(virtualenv_prompt_info)%{$reset_color%}'
else
	VENV=''
fi

LEFT="%{$bg[gray]%}$USERHOST $WD"
RIGHT="$VENV %* "

SHORTLEFT="%{$bg[gray]%}$USERHOST $SHORTWD"
SHORTRIGHT="[%*]"

setopt prompt_subst
SPACE='$(get_space $LEFT $RIGHT)'
PROMPT="$LEFT$SPACE$RIGHT
 » $LIBERTY "
RPROMPT='$(nvm_prompt_info) $(vcs_info && echo $vcs_info_msg_0_)'

del-prompt-accept-line() {
	OLD_PROMPT="$PROMPT"
	OLD_RPROMPT="$RPROMPT"
	PROMPT="$SHORTLEFT » "
	RPROMPT="$RIGHT"
	zle reset-prompt
	PROMPT="$OLD_PROMPT"
	RPROMPT="$OLD_RPROMPT"
	zle accept-line
}
zle -N del-prompt-accept-line
bindkey "^M" del-prompt-accept-line

theme_precmd () {
	#vcs_info
}

autoload -U add-zsh-hook
#add-zsh-hook precmd theme_precmd
