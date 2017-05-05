#!/usr/bin/env bash

# symlink, hardlink, or copy dotfiles to user dir- start with copy
# should include only cross-platform files, files specific to that OS, and update script
# update script should add itself to ~/bin (maybe standalone from dotfiles repo, can pull new copy and copy over files)
# should check for diffs from existing files and query user as to how to proceed (maybe with force flag to circumvent)
#
# note, should probably not link to Dropbox location, as e.g. changing branch on other computer will change contents of other computer user dir linked files

# note: changing branches on repo will probably break hardlinks, I *think* softlinks should stick unless names are changed.  softlinks or copying just generally better





# Abort script at first error, when a command exits with non-zero status (except in until or while loops, if-tests, list constructs)
set -e;



#USER_DIR="~"
#echo USER_DIR = "${USER_DIR}";

# Get path to root of dotfiles repo
# TODO: this is to script dir, since that's where this script is normally, change to parent (actual root)
# TODO: what if the script is copied somewhere else?  should I check for that?

#realpath() {
#    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
#}

#SCRIPT_PATH=`realpath $0`;
#DOTFILES=`dirname $SCRIPT_PATH`;

#echo SCRIPT PATH = "${SCRIPT_PATH}";
#echo DOTFILES = "${DOTFILES}";

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

install() {
  echo 'installing dotfiles'
  local overwrite_all=false backup_all=false skip_all=false
  for src in $(find -H "$DOTFILES_ROOT" -name '.*' -not -name '.DS_Store' -not -path '*.git*')
    do
      dst="$HOME/$(basename "${src}")"
      echo src = "${src}"
      echo dst = "${dst}"
      link_file "$src" "$dst"
    done

}

# from
# http://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
# and
# https://github.com/holman/dotfiles/blob/master/script/bootstrap
cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

echo DOTFILES_ROOT = "${DOTFILES_ROOT}";

install

exit;

# create symbolic links, create hard links, or copy
#LINK_MODE = ""

# Use > 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use > 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to > 0 the /etc/hosts part is not recognized ( may be a bug )
while [[ $# > 1 ]]
do
key="$1"

case $key in
  -m|--mode)
  LINK_MODE="$2"
  shift # past argument
  ;;
  #-s|--searchpath)
  #SEARCHPATH="$2"
  #shift # past argument
  #;;
  #-l|--lib)
  #LIBPATH="$2"
  #shift # past argument
  #;;
  #--default)
  #DEFAULT=YES
  #;;
  *)
    # unknown option
  ;;
esac
shift # past argument or value
done

echo LINK MODE  = "${LINK_MODE}"
#echo SEARCH PATH     = "${SEARCHPATH}"
#echo LIBRARY PATH    = "${LIBPATH}"
#echo "Number files in SEARCH PATH with EXTENSION:" $(ls -1 "${SEARCHPATH}"/*."${EXTENSION}" | wc -l)

if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 $1
fi