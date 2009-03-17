#! /bin/bash

#(C) 2008-2009 C. Junghans
# junghans@mpip-mainz.mpg.de

#version 0.1  06.10.08 -- initial version
#version 0.2  06.10.08 -- added --testing option
#version 0.3  06.10.08 -- added source_file support
#version 0.4  07.10.08 -- changed help
#version 0.5  08.10.08 -- do not install missing files
#version 0.6  17.10.08 -- wrong help
#version 0.7  17.03.09 -- added -s,-p

usage="Usage: ${0##*/} WHERE"
opts="-v -f"
cmd="ln -s"
echo=""
quiet="no"
source_file="README"

help () {
  cat << eof
This is a simple install script
$usage
OPTIONS:
-c,  --command CMD  Change the operation to do
                    Default: "$cmd"
-t, --testing       Will only echo the commands to do
-i, --interactive   Be interactive
-s, --source FILE   Change the name of the file, which contains 
                    the list of files to install between 
                    FILES_TO_INSTALL and END_FILES_TO_INSTALL markers
                    Default: $source_file
-p, --plain         Same as -s " "
-q, --quiet         Be a little bit quiet
-h, --help          Show this help
-v, --version       Show version
    --hg            Show last log message for hg (or cvs)

This will produce global links. The files to
install will be determined by the FILES_TO_INSTALL
section in $source_file or all files are installed.

Examples:  ${0##*/} -ic cp $HOME/bin
           ${0##*/} \$HOME

Send bugs and comment to junghans@mpip-mainz.mpg.de
eof
}

while [ "${1#-}" != "$1" ]; do
 if [ "${1#--}" = "$1" ] && [ -n "${1:2}" ]; then
    #short opt with arguments here: c
    if [ "${1#-[cs]}" != "${1}" ]; then
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
    quiet="yes"
    shift ;;
   -s | --source)
    source_file="$2"
    shift 2;;
   -p | --plain)
    source_file=""
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

if [ -n "$source_file" ] && [ -f "$thisdir/$source_file" ]; then
   filelist=$(sed -n '/FILES_TO_INSTALL/,/END_FILES_TO_INSTALL/p' "$thisdir/$source_file" | sed "/^#/d;1d;\$d;s#^#$thisdir/#")
else
   filelist=$(find -L $thisdir -type f -perm "-u=xr" \! -name "*~" | grep -v "${0##*/}" )
fi

if [ "$quiet" = "no" ]; then
   echo -n "Files to install: "
   for myfile in $filelist; do
       echo -n "${myfile##*/} "
   done
   echo
   echo Where to install: $thisdir
fi

for myfile in $filelist; do
   if [ -f $myfile ]; then
      $echo $cmd $opts $myfile .
   else
      echo $myfile was not there >&2
   fi
done
