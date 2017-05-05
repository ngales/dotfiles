# .bash_profile
# bash-specific login shell configuration file

# All bash-specific commands which don't belong in .bashrc should be executed from here.
# These include:
# PATH specifications (in .path)
# bash prompt changes (in .bash_prompt)
# Readline configuration
# tab completion configuration
# history configuration
# OS specific configuration

# Non-bash-specific environment variables should be set in .profile, which should be sourced from here.


# You'll need to load this from .profile if using bash that has been invoked using sh, as it will not load this. This means you'll still need a $BASH conditional in .profile but just a minimal one.
# Set var indicating that this file has been sourced, to alert .profile for case of running bash by invoking sh.
# Don't call .profile if this file has been sourced by it above.

# Check that we haven't already been sourced.
[[ -z ${SEEN_USER_BASH_PROFILE} ]] && SEEN_USER_BASH_PROFILE="1" || return


# Load the shell dotfiles, and then some:
for file in ~/.{path,bash_prompt,profile}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

####################################################################################################
# Misc
####################################################################################################

# Set MANPATH so it includes users' private man if it exists
if [ -d "${HOME}/man" ]; then
  MANPATH=${HOME}/man:${MANPATH} 
fi

# Set INFOPATH so it includes users' private info if it exists
if [ -d "${HOME}/info" ]; then
  INFOPATH=${HOME}/info:${INFOPATH}
fi

####################################################################################################
# Readline Configuration
####################################################################################################

# NOTE: shopt options which are 'on' are stored in the BASHOPTS environment variable, which is readonly, and can be seen by running "shopt".

# Use case-insensitive filename globbing
shopt -s nocaseglob

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell

# If set, minor errors in the spelling of a directory component in a cd command will be corrected. The errors checked for are transposed characters, a missing character, and a character too many. If a correction is found, the corrected path is printed, and the command proceeds. This option is only used by interactive shells. 
shopt -s cdspell

# If this is set, Bash checks that a command found in the hash table exists before trying to execute it. If a hashed command no longer exists, a normal path search is performed. 
shopt -s checkhash

# If set, Bash checks the window size after each command and, if necessary, updates the values of LINES and COLUMNS. 
shopt -s checkwinsize

# If set, Bash attempts to save all lines of a multiple-line command in the same history entry. This allows easy re-editing of multi-line commands. 
shopt -s cmdhist

# If set, Bash attempts spelling correction on directory names during word completion if the directory name initially supplied does not exist. 
shopt -s dirspell

# If set, Bash includes filenames beginning with a ‘.’ in the results of filename expansion. 
shopt -s dotglob

# Make bash append rather than overwrite the history on disk
shopt -s histappend

# Use case-insensitive filename globbing
shopt -s nocaseglob

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# If set, a command name that is the name of a directory is executed as if it were the argument to the cd command. This option is only used by interactive shells. 
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null;
done;

####################################################################################################
# Completion Configuration
####################################################################################################

# add bash_completion script directory, primarily to enable git autocompletion on OS X
# 7/19/2015: changed from /opt/local/etc/bash_completion to /opt/local/etc/profile.d/bash_completion.sh
if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
    . /opt/local/etc/profile.d/bash_completion.sh
fi

# Add tab completion for many Bash commands
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

####################################################################################################
# OS Specific
####################################################################################################

# NGALES, sometime in July 2015:
# Try to detect which OS we are running, and source appropriate system-specific scripts appropriately
# from https://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux
# currently, just OS X
if [ "$(uname)" == "Darwin" ]; then
  #echo "sourcing OS X env.sh"
  source ${HOME}/Dropbox/SyncSpace/dotfiles/system/.osx
# could instead use 'elif [ -n "$COMSPEC" -a -x "$COMSPEC" ]', checking for cmd exe
elif [ "$(expr substr $(uname -s) 1 6)" == "CYGWIN" ]; then
  #echo "sourcing Windows env.sh"
  source /cygdrive/c/Users/ngales/Dropbox/SyncSpace/dotfiles/system/.windows
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  echo "TODO: sourcing .linux"
  # do something under linux
fi

# and yet another way to detect OS
#case "$(uname -s)" in
#  Darwin)
#    echo 'OS X'
#    ;;
#  CYGWIN*|MINGW32*|MSYS*)
#    echo 'Windows'
#    ;;
#  Linux)
#    echo 'Linux'
#    ;;
#  *)
#   echo 'unknown OS'
#   ;;
#esac

####################################################################################################
# Chain .bashrc
####################################################################################################

if [ -e "${HOME}/.bashrc" ] ; then
  source "${HOME}/.bashrc"
fi
