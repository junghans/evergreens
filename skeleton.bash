#! /bin/bash

#(C) 2012 C. Junghans
# junghans@votca.org

#version 0.1  XX.XX.XX -- initial version

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
OPTIONS:
-q, --quiet         Be a little bit quiet
-h, --help          Show this help
-v, --version       Show version
    --hg            Show last log message for hg (or cvs)

Examples:  ${0##*/} -q
           ${0##*/}

Report bugs and comments at https://github.com/junghans/cwdiff/issues
                         or junghans@votca.org
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
   --hg)
    echo "${0##*/}: $(sed -ne 's/^#version.* -- \(.*$\)/\1/p' $0 | sed -n '$p')"
    exit 0;;
   -v | --version)
    echo "${0##*/}, $(sed -ne 's/^#\(version.*\) -- .*$/\1/p' $0 | sed -n '$p') by C. Junghans"
    exit 0;;
   *)
    die "Unknown option '$1'";;
  esac
done

[[ -z $1 ]] && die "No YYY given !\n$usage\nHelp with -h"

