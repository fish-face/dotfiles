# oh-my-zsh Bureau Theme, modifications by Fish-Face

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

ZSH_THEME_GIT_PROMPT_PREFIX="[%B%F{green}±%b%f%B%F{white}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%f]"
ZSH_THEME_GIT_PROMPT_CLEAN="%B%F{green}✓%b%f"
ZSH_THEME_GIT_PROMPT_AHEAD="%F{cyan}▴%b%f"
ZSH_THEME_GIT_PROMPT_BEHIND="%F{magenta}▾%b%f"
ZSH_THEME_GIT_PROMPT_STAGED="%B%F{green}●%b%f"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%B%F{yellow}●%b%f"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%B%F{red}●%b%f"

truncate_wd () {
	local wd="$1"
	local wd_maxlen=$2
	local wd_startlen=$3
	local wd_endlen=$(( $wd_maxlen - $wd_startlen ))

	if [ ${#wd} -gt $(( $wd_maxlen + 1 )) ]; then
		local wdoffset=$(( ${#wd} - $wd_endlen ))
		wd="${wd:0:$wd_startlen}…${wd:$wdoffset:$wd_endlen}"
	fi
	echo $wd
}

WD='%B%F{yellow}$(truncate_wd "`print -P %~`" 50 10)%b%f'
SHORTWD='%B%F{white}$(truncate_wd "`print -P %1~`" 12 3)%b%f'

if [[ $EUID -eq 0 ]]; then
  USERHOST="%B%F{red}%n"
  LIBERTY="%B%F{red}#%b%f"
else
  USERHOST="%B%F{white}%n"
  LIBERTY="%F{green}$%f"
fi
if [[ -n "$SSH_CLIENT" ]]; then
	USERHOST="$USERHOST%b%f@%B%F{red}%m"
else
	USERHOST="$USERHOST%b%f@%F{green}%m%f"
fi
LIBERTY="$LIBERTY%b%f"


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
	VENV='%F{green}$(virtualenv_prompt_info)${CONDA_DEFAULT_ENV}%b%f'
else
	VENV=''
fi

LEFT="$USERHOST $WD"
RIGHT="%b%f$VENV %* "

SHORTLEFT="$USERHOST $SHORTWD"
SHORTRIGHT="%b%f %* "

setopt prompt_subst
SPACE='$(get_space $LEFT $RIGHT)'
PROMPT="$LEFT$SPACE$RIGHT
 %B%F{white}»%f%b $LIBERTY "
RPROMPT='$(vcs_info && echo $vcs_info_msg_0_)'

del-prompt-accept-line() {
	OLD_PROMPT="$PROMPT"
	OLD_RPROMPT="$RPROMPT"
	PROMPT="$SHORTLEFT »%B%F{white}%b%f "
	RPROMPT="$SHORTRIGHT"
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
