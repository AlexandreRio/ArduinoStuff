#!/bin/bash
# requirements: ano, picocom, dmenu...

LIB="$HOME/SINTEF/lib-arduino/"
TMP="/tmp/"

SOURCE=`find $PWD -regextype posix-awk -regex ".*ino|.*pde" | xargs ls -1t | dmenu -l 10`


if [ -z $SOURCE ] ; then
  echo "Canceling build"
else
  cd $TMP
  fold="ano`date +%s`"
  mkdir $fold
  cd $fold
  mkdir src lib
  cp $SOURCE src/
  ln -s $LIB lib

  while getopts "cbus" opt; do
    case "$opt" in
      c)
        ano clean
        ;;
      b)
        ano build
        ;;
      u)
        ano upload
        ;;
      s)
        ano serial
        ;;
      '?')
        echo -e "error\n"
        exit 1
        ;;
    esac
  done

fi
