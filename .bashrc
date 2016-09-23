#!/bin/bash

umask 022

###############################################################################
### set a reasonable default path
PATH='/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin'
[[ -d $HOME'/bin' ]] && PATH=$HOME'/bin:'$PATH

###############################################################################
### If this is not an interactive shell, exit here
[[ $- = *i* ]] || return
# fix SHELL variable
export SHELL=$0

###############################################################################
### Ancillary file directory set and create if necessary
export SHELLD=$HOME/.bashrc.d
[[ ! -d "$SHELLD" ]] && mkdir "$SHELLD" && chmod 700 "$SHELLD"

###############################################################################
### bash specific variables (common are set in .profile)
export HISTFILE=$SHELLD/.bash_history

###############################################################################
### Load in system profiles if they exist
for i in /etc/profile.d/*.sh; do
    [ -r "$i" ] && source "$i"
done
unset i

###############################################################################
### Load in ancillary if they exist
for i in $SHELLD/*.sh; do
    [ -r "$i" ] && source "$i"
done
unset i

###############################################################################
### This gives us darcs completion in bash if it exists
[[ -f /usr/local/share/darcs_completion ]] && source /usr/local/share/darcs_completion

# User configuration -- NOTE: a lot of fuctions depend on my .profile!
if [[ -r "$HOME/.profile" ]]; then
    . "$HOME/.profile"
    # Because zsh needed special variables, we set them here as well
    export c_pEMERG="${c_EMERG}"
    export c_pALERT="${c_ALERT}"
    export c_pCRIT="${c_CRIT}"
    export c_pERR="${c_ERR}"
    export c_pWARNING="${c_WARNING}"
    export c_pNOTICE="${c_NOTICE}"
    export c_pINFO="${c_INFO}"
    export c_pDEBUG="${c_DEBUG}"
    
    if [[ ! -z ${SSH_TTY} ]]; then
        TTY=${SSH_TTY}
    elif [[ -z ${TTY} ]]; then
        TTY=$(tty)
    fi
    TTY=${TTY#/dev/}
    # \j = # of jobs ; \l basname of terminal device
    PS1="${c_ALERT}\$(_return_code)${c_norm}${c_green}($UNAMES) ${c_blue}\u${c_green}@${c_blue}\h:${c_yellow}\w${c_norm} \n${c_pDEBUG}\041\! [${TTY}] \$(_vcs_prompt_char) \$${c_norm} "
else
    echo "WARNING: missing $HOME/.profile!!"
    export MANPATH="/usr/local/man:$MANPATH"

    PS1="$(uname -s) \u@\h:\w \n\041\! \$ "
fi
export PS1

###############################################################################
### Let's set some shoptions...
# autocd       - type 'directoryname' instead of 'cd directoryname'
# cdspell      - autocorrect typos in path names when using cd
# checkwinsize - keeps bash updated on window size
# cmdhist      - save multi-line commands to history as one command
# dirspell     - correct spelling of directories
# histappend   - Turn on parallel history
# Some shoptions are not available in every version of Bash, so check first
for i in autocd cdspell checkwinsize cmdhist dirspell histappend; do
    shopt -s "${i}"
done
unset i

# Append to history file
history -a
export HISTCONTROL=ignoreboth:erasedups
# Record each line of history right away instead of at the end of the session
PROMPT_COMMAND="${PROMPT_COMMAND};history -a"

# bind hh to Ctrl-r (for Vi mode check doc)
bind '"\C-r": "\C-a hh \C-j"'

# Clean up
