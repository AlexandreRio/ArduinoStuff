#!/bin/bash
# requirements: ano, picocom, dmenu...

LIB="$HOME/SINTEF/lib-arduino/"
TMP="/tmp/"

CURRENT_FOLDER=$PWD
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
        ano build 2> $CURRENT_FOLDER/arduino_error.log
        ;;
      u)
        ano upload
        ;;
      s)
        ano serial -b 115200
        ;;
      '?')
        echo -e "error\n"
        exit 1
        ;;
    esac
  done

fi
