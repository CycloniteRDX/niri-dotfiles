#
# ~/.bashrc
#

# Only continue in interactive shells.
[[ $- != *i* ]] && return


# ============================================================
# History
# ============================================================

# Append to the history file instead of overwriting it.
shopt -s histappend

# Avoid consecutive duplicate entries.
# Do not use "ignoreboth": Kitty shell integration relies on
# history for some command-tracking features.
HISTCONTROL=ignoredups

# Keep a useful amount of history without letting it grow forever.
HISTSIZE=10000
HISTFILESIZE=20000


# ============================================================
# Shell behaviour
# ============================================================

# Update terminal dimensions after each command when necessary.
shopt -s checkwinsize


# ============================================================
# Readline
# ============================================================

# Search history using the text already typed.
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Make completion a little more convenient.
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'


# ============================================================
# Aliases
# ============================================================

alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lah --color=auto --group-directories-first'
alias la='ls -A --color=auto --group-directories-first'
alias grep='grep --color=auto'


# ============================================================
# Git prompt
# ============================================================

if [[ -r /usr/share/git/completion/git-prompt.sh ]]; then
    source /usr/share/git/completion/git-prompt.sh

    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1
fi


# ============================================================
# Exit status
# ============================================================

# Capture the exit status of the previous command without
# replacing other PROMPT_COMMAND hooks, such as Kitty's.
ROGUEOS_LAST_STATUS=0

__rogueos_capture_status() {
    ROGUEOS_LAST_STATUS=$?
    return "$ROGUEOS_LAST_STATUS"
}

if [[ ${PROMPT_COMMAND[*]-} != *__rogueos_capture_status* ]]; then
    if [[ $(declare -p PROMPT_COMMAND 2>/dev/null) == "declare -a"* ]]; then
        PROMPT_COMMAND=(__rogueos_capture_status "${PROMPT_COMMAND[@]}")
    elif [[ -n ${PROMPT_COMMAND:-} ]]; then
        PROMPT_COMMAND=(__rogueos_capture_status "$PROMPT_COMMAND")
    else
        PROMPT_COMMAND=(__rogueos_capture_status)
    fi
fi

__rogueos_exit_indicator() {
    if (( ROGUEOS_LAST_STATUS != 0 )); then
        printf '✗ %d ' "$ROGUEOS_LAST_STATUS"
    fi
}


# ============================================================
# Prompt
# ============================================================

# RogueOS palette:
# cyan    #5ce1e6
# magenta #f05adf
# white   #dce7f2
# muted   #52647a
# error   #ff6b81

if declare -F __git_ps1 >/dev/null; then
    PS1='\[\e[38;2;92;225;230m\]\u\[\e[38;2;82;100;122m\]@\[\e[38;2;92;225;230m\]\h \[\e[38;2;220;231;242m\]\w\[\e[38;2;240;90;223m\]$(__git_ps1 " (%s)")\[\e[0m\]\n\[\e[38;2;255;107;129m\]$(__rogueos_exit_indicator)\[\e[38;2;92;225;230m\]❯\[\e[0m\] '
else
    PS1='\[\e[38;2;92;225;230m\]\u\[\e[38;2;82;100;122m\]@\[\e[38;2;92;225;230m\]\h \[\e[38;2;220;231;242m\]\w\[\e[0m\]\n\[\e[38;2;255;107;129m\]$(__rogueos_exit_indicator)\[\e[38;2;92;225;230m\]❯\[\e[0m\] '
fi
