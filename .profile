#!/bin/bash
# My personalized .profile, based on tons of things I've found/learned
#
# 20160908 NOTE: May have broken compatibility w/non-bash/zsh shells
#

###############################################################################
### If this is not an interactive shell, exit here
[[ $- = *i* ]] || return
###############################################################################
### Set some configurations
export PD="$HOME/.profile.d"
# Prefered datstamp format. A good ISO date stamp is +%Y%m%d-%H%M
export DEFAULT_TIMESTAMP='+%Y%m%d-%H%M%S'
# Set this to perfered version control system current possible values: git svn 
export DEFAULT_VCS="git"
# Set this to false to ignore untracked files, which can speed up repo checks
export VCS_IGNORE_UNTRACKED_FILES="false"
# Set this to false to ignore submodule files, which can speed up repo checks
export VCS_IGNORE_SUBMODULES="true"
# File extensions to ignore when doing name completion
export FIGNORE='~':'.o':'.bak':'.tmp'
# Some history-related settings
export HISTSIZE=500
export HISTFILESIZE=5000
export SAVEHIST=${HISTFILESIZE}
export HISTCONTROL=ignoreboth
# This is specifically for 'hh' (installed via package 'hrst')
export HH_CONFIG=hicolor
# Set autojump completion for commands
export AUTOJUMP_AUTOCOMPLETE_CMDS='cp vim'
# Set .config directory for XDG
export XDG_CONFIG_HOME="$HOME/.config"
# Set this to perfered version control system
# current possible values: git svn 
export VCS="git"

###############################################################################
### Set up PATH

if [[ -r "${PD}/profile.paths" ]]; then
    while read line 
    do
        if [[ -d $line ]]; then
            PATH=$PATH':'$line
        fi
    done <"$PD/profile.paths"
fi
unset line

export PATH

###############################################################################
### Set up helper variables
UNAMES=$(uname -s)
UNAMER=$(uname -r)
PLATFORM=$(uname -p)
HOSTNAME=$(uname -n)
export UNAMES UNAMER PLATFORM HOSTNAME

# Set up the shell variables:
RSYNC_RSH=ssh
SYSTEM=$(hostname)

NVIM=$(which nvim 2>/dev/null)
VIM=$(which vim 2>/dev/null)
SUBL=$(which sublime_text 2>/dev/null || which subl 2>/dev/null)
if [[ -x $SUBL ]]; then
    EDITOR="$SUBL -w "
    VISUAL=$SUBL
    alias st="$SUBL"
    alias vi="$VIM"
elif [[ -x $NVIM ]]; then
    EDITOR=$NVIM
    VISUAL=$NVIM
    alias vi="$NVIM"
elif [[ -x $VIM ]]; then
	EDITOR=$VIM
	VISUAL=$VIM
	alias vi="$VIM"
else
	EDITOR=vi
	VISUAL=vi
fi

if [ -x /usr/bin/less ]; then
    PAGER="/usr/bin/less -ins"
elif [ -x /usr/bin/more ]; then
    PAGER="/usr/bin/more -s"
fi

export EDITOR VISUAL PAGER RSYNC_RSH SYSTEM
###############################################################################
### MANPATH ###
if [[ -e "${PD}/profile.manpaths" ]]; then
    MANPATH=''
    while read line 
    do
        if [[ -d $line ]]; then
            PATH=$PATH':'$line
        fi
    done <"$PD/profile.manpaths"
fi

[[ -d $HOME'/man' ]] && MANPATH=$MANPATH':'$HOME'/man'

export MANPATH

###############################################################################
### color TERM settings
if [[ "$COLORTERM" == gnome-* && "$TERM" == xterm* ]] && /usr/bin/infocmp gnome-256color >/dev/null 2>&1; then
    TERM=gnome-256color
    if [[ -x /usr/bin/dircolors ]]; then
        if [[ -r "$HOME/.dirColors/dircolors.256dark" ]]; then
            eval $(dircolors -b "$HOME/.dirColors/dircolors.256dark")
        elif [[ -r "$HOME/.dirColors" ]]; then
            eval $(dircolors -b "$HOME/.dirColors")
        else
            eval $(dircolors -b)
        fi

        LS_OPTS="--color=auto" && export LS_OPTS
    fi
    tput sgr0
    c_bold=$(tput bold)
    c_norm=$(tput sgr0)
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
        BASE03=$(tput setaf 234)
        BASE02=$(tput setaf 235)
        BASE01=$(tput setaf 240)
        BASE00=$(tput setaf 241)
        BASE0=$(tput setaf 244)
        BASE1=$(tput setaf 245)
        BASE2=$(tput setaf 254)
        BASE3=$(tput setaf 230)
        c_orange=$(tput setaf 166)
        c_magenta=$(tput setaf 125)
        c_yellow=$(tput setaf 136)
        c_red=$(tput setaf 160)
        c_purple=$(tput setaf 61)
        c_blue=$(tput setaf 33)
        c_cyan=$(tput setaf 37)
        c_green=$(tput setaf 64)
        c_white=$BASE2
        c_black=$BASE03
    else
        BASE03=$(tput setaf 8)
        BASE02=$(tput setaf 0)
        BASE01=$(tput setaf 10)
        BASE00=$(tput setaf 11)
        BASE0=$(tput setaf 12)
        BASE1=$(tput setaf 14)
        BASE2=$(tput setaf 7)
        BASE3=$(tput setaf 15)
        c_orange=$(tput setaf 9)
        c_magenta=$(tput setaf 5)
        c_yellow=$(tput setaf 3)
        c_red=$(tput setaf 1)
        c_purple=$(tput setaf 13)
        c_blue=$(tput setaf 4)
        c_cyan=$(tput setaf 6)
        c_green=$(tput setaf 2)
        c_white=$BASE2
        c_black=$BASE03
    fi
elif [[ "$TERM" == linux ]]; then
    tput sgr0
    c_bold=$(tput bold)
    c_norm=$(tput sgr0)
    BASE03=$(tput setaf 8)
    BASE02=$(tput setaf 0)
    BASE01=$(tput setaf 10)
    BASE00=$(tput setaf 11)
    BASE0=$(tput setaf 12)
    BASE1=$(tput setaf 14)
    BASE2=$(tput setaf 7)
    BASE3=$(tput setaf 15)
    c_orange=$(tput setaf 9)
    c_magenta=$(tput setaf 5)
    c_yellow=$(tput setaf 3)
    c_red=$(tput setaf 1)
    c_purple=$(tput setaf 13)
    c_blue=$(tput setaf 4)
    c_cyan=$(tput setaf 6)
    c_green=$(tput setaf 2)
    c_white=$BASE2
    c_black=$BASE03
else
    tset -Q -e ${ERASE:-\^h} $TERM
    [[ $UNAMES = "SCO_SV" ]] && TERM=xterm
    [[ -x $(which tset) ]] && eval `tset -s -Q`
    # std Linux console colors. These are NOT Solarized values
    c_norm="\e[0m"
    c_bold="\e[1m"
    c_black="\e[0;30m"
    c_blue="\e[0;34m"
    c_brown="\e[0;33m"
    c_cyan="\e[0;36m"
    c_dark_gray="\e[1;30m"
    c_green="\e[0;32m"
    c_magenta="\e[0;31m"
    c_purple="\e[0;35m"
    c_orange="\e[0;33m"
    c_red="\e[0;31m"
    c_white="\e[1;37m"
    c_yellow="\e[1;33m"
fi

# Combos for various alert based on kernel alert levels
c_EMERG="${c_bold}${c_magenta}"
c_ALERT="${c_bold}${c_red}"
c_CRIT="${c_red}"
c_ERR="${c_bold}${c_yellow}"
c_WARNING="${c_yellow}"
c_NOTICE="${c_white}"
c_INFO="${c_green}"
c_DEBUG="${c_blue}"

###############################################################################
### load general aliases
[[ -r "${PD}/alias.general" ]] && source "${PD}/alias.general"
#   load default VCS aliases
[[ -r "${PD}/alias.${DEFAULT_VCS}" && -x $(which $DEFAULT_VCS 2>/dev/null) ]] && source "${PD}/alias.${DEFAULT_VCS}"
#   load platform aliases
[[ -r "${PD}/alias.${UNAMES}" ]] && source "${PD}/alias.${UNAMES}"

###############################################################################
### platform-specific stuff goes in these files.
[[ -r "${PD}/profile.${UNAMES}" ]] && source "${PD}/profile.${UNAMES}"

#This will most likely only execute on Mac OS X systems w/Fink
#  but it's here like this in case I emulate the system elsewhere
[[ -x /sw/bin/init.sh ]] && source /sw/bin/init.sh

###############################################################################
### Load functions
[[ -r "${PD}/functions" ]] && source "${PD}/functions"

###############################################################################
### Set up the shell environment
umask 022
trap "echo 'logout'" 0
# removed '-o nounset' as it caused problems w/bash autocomplete
set -o noclobber -o vi -o notify

###############################################################################
### Shell dependent settings
case "$SHELL" in
zsh      | -zsh      | */zsh  | \
zsh.exe  | -zsh.exe  | */zsh.exe )
    SHELLSTRING="$SHELL ($ZSH_VERSION)"
    ;;

bash     | -bash     | */bash | \
bash.exe | -bash.exe | */bash.exe )
    SHELLSTRING="$SHELL ($BASH_VERSION)"
    ;;

ksh*     | -ksh*     | */ksh* | \
ksh*.exe | -ksh*.exe | */ksh*.exe )
    SHELLSTRING="$SHELL ($KSH_VERSION)"
    export PS1='$c_bold$USER@$HOSTNAME ($UNAMES): $c_norm $PWD
! $ '
    ;;
sh     | -sh     | */sh | \
sh.exe | -sh.exe | */sh.exe )
    # Set a simple prompt
    SHELLSTRING="$SHELL"
    export PS1='$USER@$HOSTNAME $ '
    ;;
* )
    # Sorry, unknown shell??
    SHELLSTRING="UNKNOWN"

    export PS1='$ '
    ;;
esac

###############################################################################
# FWIW:
# tcsh   - $version  - set to tcsh version number (also: set prompt='%n@%m %~ ')
# bash   - $BASH     - set to bash path
# [t]csh - $shell    - set to 'csh' or 'tcsh'
# zsh    - $ZSH_NAME - set to 'zsh'
# ksh has $PS3 & $PS4 set (normal Bourne shell (sh) only has $PS1 & $PS2 set).
#   This generally seems like the hardest to distinguish - the ONLY difference
#   in entire set of envionmental variables between sh and ksh installed on
#   Solaris: $ERRNO, $FCEDIT, $LINENO, $PPID, $PS3, $PS4, $RANDOM, $SECONDS, $TMOUT
###############################################################################

type whereis >/dev/null 2>&1 || {
	alias whereis='type -all'
}

###############################################################################
### Display some useful information
echo -e "${c_white}You're logged into ${c_bold}$SYSTEM${c_norm}${c_white} in a(n) ${c_bold}$TERM${c_norm}${c_white} terminal with:
    ${c_white}${c_bold}System:${c_norm} ${c_purple}$UNAMES ($UNAMER)
    ${c_white}${c_bold}Shell:${c_norm}  ${c_purple}$SHELLSTRING
    ${c_white}${c_bold}Pager:${c_norm}  ${c_purple}$PAGER
    ${c_white}${c_bold}Editor:${c_norm} ${c_purple}$EDITOR
    ${c_white}${c_bold}VCS:${c_norm}    ${c_purple}$DEFAULT_VCS"

DDATE=$(which ddate 2>/dev/null)
if [[ -x $DDATE ]]; then
    DDAY=$($DDATE +'Today is %{%A, the %e of %B%}, %Y YOLD. %N%nCelebrate %H')
    echo -e "${c_cyan}$DDAY"
fi

