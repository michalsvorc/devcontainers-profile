#!/usr/bin/env bash
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)

#===============================================================================
# Abort the script on errors and unbound variables
#===============================================================================

set -o errexit      # Abort on nonzero exit status.
set -o nounset      # Abort on unbound variable.
set -o pipefail     # Don't hide errors within pipes.
# set -o xtrace       # Set debugging.

#===============================================================================
# Variables
#===============================================================================

version='1.0.0'
argv0=${0##*/}
shell='/bin/zsh'
editor='vim'

#===============================================================================
# Usage
#===============================================================================

usage() {
  cat <<EOF
Usage:  ${argv0}

Initialize \$USER profile configuration files in \$HOME.

Options:
    -h, --help      Show help screen and exit.
    -v, --version   Show program version and exit.

EOF
  exit ${1:-0}
}

#===============================================================================
# Functions
#===============================================================================

die() {
  local message="$1"

  printf 'Error: %s\n\n' "$message" >&2

  usage 1 1>&2
}

version() {
  printf '%s version: %s\n' "$argv0" "$version"
}

export_env_variables() {
  local target="$1"
  printf '
export SHELL=%s
export EDITOR=%s
export PATH=\"%s:\${PATH}\"
' \
    "$shell" \
    "$editor" \
    "${HOME}/.local/bin" \
    >> "$target"
}

create_symlink() {
  local source="$1"
  local target="$2"

  ln -sfn "$source" "$target"
}

init() {
  export_env_variables "${HOME}/.profile"

  create_symlink 'config' "${HOME}/.config"
  file='profile';       create_symlink "${HOME}/.${file}" "${HOME}/.z${file}"
  file='logout';        create_symlink "${file}.sh"       "${HOME}/.z${file}"
  file='zshrc';         create_symlink "${file}.sh"       "${HOME}/.${file}"
  file='editorconfig';  create_symlink "$file"            "${HOME}/.${file}"
  file='gitconfig';     create_symlink "$file"            "${HOME}/.${file}"
  file='vimrc';         create_symlink "$file"            "${HOME}/.${file}"
  file='tigrc';         create_symlink "$file"            "${HOME}/.${file}"
  file='tmux.conf';     create_symlink "$file"            "${HOME}/.${file}"
}

#===============================================================================
# Execution
#===============================================================================

test $# -eq 0 && init && exit 0

case "${1:-}" in
  -h | --help )
    usage 0
    ;;
  -v | --version )
    version
    exit 0
    ;;
  * )
    die "$(printf 'Unrecognized argument "%s".' "${1#-}")"
    ;;
esac

