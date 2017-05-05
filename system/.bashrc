# .bashrc
# bash-specific interactive shell configuration file

# exports (in .exports)
# aliases (in .aliases)
# functions (in .functions)
# any configuration which is private in nature (in .extras)

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# source the system wide bashrc if it exists
if [ -e /etc/bash.bashrc ] ; then
  source /etc/bash.bashrc
fi

# Load the shell dotfiles, and then some:
for file in ~/.{exports,aliases,functions,extras}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;
