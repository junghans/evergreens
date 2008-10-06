#! /bin/bash

#(C) 2008 C. Junghans
# junghans@mpip-mainz.mpg.de

#version 0.1  06.10.08 -- initial version
#version 0.2  06.10.08 -- added --testing option

usage="Usage: ${0##*/} WHERE"
opts="-v -f"
cmd="ln -s"
echo=""

help () {
  cat << eof
This is a simple install script
$usage
OPTIONS:
-c,  --command CMD  Change the operation to do
                    Default: "$command"
-t, --testing       Will only echo the commands to do
-i, --interactive   Be interactive
-q, --quiet         Be a little bit quiet
-h, --help          Show this help
-v, --version       Show version
    --hg            Show last log message for hg (or cvs)

This will produce global links, to produce local links use
install_scripts (from the evergreen repo).

Examples:  ${0##*/} -ic cp $HOME/bin
           ${0##*/} \$HOME

Send bugs and comment to junghans@mpip-mainz.mpg.de
eof
}

while [ "${1#-}" != "$1" ]; do
 if [ "${1#--}" = "$1" ] && [ -n "${1:2}" ]; then
    #short opt with arguments here: c
    if [ "${1#-[c]}" != "${1}" ]; then
       set -- "${1:0:2}" "${1:2}" "${@:2}"
    else
       set -- "${1:0:2}" "-${1:2}" "${@:2}"
    fi
 fi
 case $1 in 
   -i | --interactive)
    opts=${opts/-f/-i}
    shift ;;
   -t | --testing)
    echo="echo"
    shift ;;
   -q | --quiet)
    opts=${opts/-v/}
    shift ;;
   -c | --command)
    [[ -n "$(type -p "$2")" ]] || { echo Command \"$2\" not found; exit 1; }
    cmd="$2"
    shift 2;;
   -h | --help)
    help
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
  echo No dir given ! >&2
  echo $usage >&2
  echo Help with -h >&2
  exit 1 >&2
fi

[[ -d "$1" ]] || { echo Dir \"$1\" not found; exit 1; }
aim=$1

thisdir=$PWD
cd $aim
find -L $thisdir -type f -perm "-u=xr" \! -name ${0##*/} \! -name "*~" -exec $echo $cmd $opts {} . \;
