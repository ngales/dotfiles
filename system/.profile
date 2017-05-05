# .profile
# shell-agnostic login shell configuration file

# Environment variables that are not specific to bash should be set here. This file will be sourced by .bash_profile.
# Note that any Bash-specific variables should be set in .bash_profile.

export LANG=en_US.UTF-8

# TODO: should this still source bash-specific dotfiles if not a Bash shell (e.g. .exports)?

# In case this is a bash shell that has been called by sh, circumventing .bash_profile, source .bash_profile.
# .bash_profile will set a flag on it's first execution to prevent a loop.
if [ -n "${BASH_VERSION}" ]; then
  if [ -f "${HOME}/.bashrc" ]; then
    source "${HOME}/.bashrc"
  fi
fi
