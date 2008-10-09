#! /bin/bash

#(C) 2008 C. Junghans
# junghans@mpip-mainz.mpg.de

#version 0.1  XX.XX.XX -- initial version

usage="Usage: ${0##*/} XXX"
quiet="no"

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

Send bugs and comment to junghans@mpip-mainz.mpg.de
eof
}

while [ "${1#-}" != "$1" ]; do
 if [ "${1#--}" = "$1" ] && [ -n "${1:2}" ]; then
    #short opt with arguments here: fc
    if [ "${1#-[fc]}" != "${1}" ]; then
       set -- "${1:0:2}" "${1:2}" "${@:2}"
    else
       set -- "${1:0:2}" "-${1:2}" "${@:2}"
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
   echo Unknown option \'$1\' 
   exit 1;;
 esac
done

if [ -z "$1" ]; then
  echo No YYY given ! >&2
  echo $usage >&2
  echo Help with -h >&2
  exit 1 >&2
fi

