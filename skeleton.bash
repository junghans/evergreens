#! /bin/bash

# Copyright (C) 2012-2015 Christoph Junghans
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
#
#version 0.1, XX.XX.XX -- initial version

usage="Usage: ${0##*/} XXX"
quiet="no"
die() {
  echo -e "$*"
  exit 1
}

qecho() {
  [ "$quiet" = "yes" ] || echo -e "$*"
}

show_help () {
  cat << eof
This is a skeleton script
$usage

Options:
 -q, --quiet         Be a little bit quiet
 -h, --help          Show this help
 -v, --version       Show version
     --vcs           Show last log message for use with VCS

Examples:  
 ${0##*/} -q        Run in quiet mode
 ${0##*/}           Run

Report bugs and comments at https://github.com/junghans/cwdiff/issues or junghans@votca.org
eof
}

shopt -s extglob
while [[ ${1} = -?* ]]; do
  if [[ ${1} = --??*=* ]]; then # case --xx=yy
    set -- "${1%%=*}" "${1#*=}" "${@:2}" # --xx=yy to --xx yy
  elif [[ ${1} = -[^-]?* ]]; then # case -xy split
    if [[ ${1} = -[o]* ]]; then #short opts with arguments
       set -- "${1:0:2}" "${1:2}" "${@:2}" # -xy to -x y
    else #short opts without arguments
       set -- "${1:0:2}" "-${1:2}" "${@:2}" # -xy to -x -y
    fi
  fi
  case $1 in
   -q | --quiet)
    quiet="yes"
    shift ;;
   -h | --help)
    show_help
    exit 0;;
   --vcs)
    echo "${0##*/}: $(sed -ne 's/^#version.* -- \(.*$\)/\1/p' $0 | sed -n '$p')"
    exit 0;;
   -v | --version)
    cat << eov
${0##*/} $(sed -ne 's/^#version \(.*\) -- .*$/\1/p' "$0" | sed -n '$p')

$(sed -ne 's/^# \(Copyright.*\)/\1/p' "$0")
This is free software: you are free to change and redistribute it.
License GPLv2+: GNU GPL version 2 or later <http://gnu.org/licenses/gpl2.html>
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Written by C. Junghans <junghans@votca.org>
eov
    exit 0;;
   *)
    die "Unknown option '$1'";;
  esac
done

[[ -z $1 ]] && die "No YYY given !\n$usage\nHelp with -h"

