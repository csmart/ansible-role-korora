# only run this for interactive bash
if [ "$BASH" != "$(which bash)" -a "$BASH" != "/bin/bash" -a "$BASH" != "/usr/bin/bash" ]; then
  return
fi
tty -s || return

# Source for git information in prompt
if [ "${HIDE_GIT_PS1}" != "1" -a -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
  source /usr/share/git-core/contrib/completion/git-prompt.sh
  GIT_PS1_SHOWDIRTYSTATE=1
  GIT_PS1_SHOWSTASHSTATE=1
  GIT_PS1_SHOWUNTRACKEDFILES=1
#  GIT_PS1_SHOWUPSTREAM="verbose legacy git"
  GIT_PS1_DESCRIBE_STYLE=default
#  GIT_PS1_SHOWCOLORHINTS=1
else
  __git_ps1()
  {
    : # Git is not installed so stub out function
  }
fi

#Turn off annoying blinking if interactive
[ $TERM != "xterm" ] && setterm --blength 0 2>/dev/null

#Set aliases
alias cp='cp -i'
alias grep='grep --color=auto'
alias grpe='grep --color=auto'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias la='ls -a --color=auto'
alias lla='ls -la --color=auto'
alias mv='mv -i'
alias rm='rm -i'
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'

# Set terminal colours
BASE03=$(tput setaf 234)
BASE02=$(tput setaf 235)
BASE01=$(tput setaf 240)
BASE00=$(tput setaf 241)
BASE0=$(tput setaf 244)
BASE1=$(tput setaf 245)
BASE2=$(tput setaf 254)
BASE3=$(tput setaf 230)
YELLOW=$(tput setaf 136)
ORANGE=$(tput setaf 166)
RED=$(tput setaf 160)
MAGENTA=$(tput setaf 125)
VIOLET=$(tput setaf 61)
BLUE=$(tput setaf 33)
CYAN=$(tput setaf 37)
GREEN=$(tput setaf 64)
BOLD=$(tput bold)
RESET=$(tput sgr0)

# If we're root, then let's see red
if [ ${EUID} -eq 0 ] ; then
  USER_COLOUR="${RED}"
else
  USER_COLOUR="${GREEN}"
fi

# Check if we're local or remote or root
if [[ -n "${SSH_CLIENT}" || -n "${SSH_TTY}" || ${EUID} -eq 0 ]] ; then
  # Prompt with hostname
  export PS1="\[${RESET}\][\[${BASE0}\]\A\[${RESET}\] \[${USER_COLOUR}\]\u@\h \[${CYAN}\]\w\[${YELLOW}\]\$(__git_ps1 \" (%s)\")\[${RESET}\]]\\$\[${RESET}\] "
else
  # Just prompt
  export PS1="\[${RESET}\][\[${BASE0}\]\A\[${RESET}\] \[${USER_COLOUR}\]\u \[${CYAN}\]\w\[${YELLOW}\]\$(__git_ps1 \" (%s)\")\[${RESET}\]]\\$\[${RESET}\] "
fi

# Set terminal working directory length for use in PS1
PROMPT_DIRTRIM=2

# Add colours to man pages
HAVE_LESS=$(command -v less)
if [ -n "$HAVE_LESS" -a -z "${MANPAGER}" ] ; then
  man() {
    env LESS_TERMCAP_mb=$(printf "\e[1;31m") \
      LESS_TERMCAP_md=$(printf "\e[38;5;33m") \
      LESS_TERMCAP_me=$(printf "\e[0m") \
      LESS_TERMCAP_se=$(printf "\e[0m") \
      LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
      LESS_TERMCAP_ue=$(printf "\e[0m") \
      LESS_TERMCAP_us=$(printf "\e[38;5;136;4m") \
      GROFF_NO_SGR=yes \
      man "$@"
  }
fi

# LS colours
eval "$(dircolors --sh /usr/share/korora/dircolors.ansi-universal 2>/dev/null)"

