#!/bin/bash

CUR_FOLDER=$PWD
LIB="$HOME/SINTEF/lib-arduino/"
TMP="/tmp/"

for testFile in `find . -name 'test_*.thingml'`; do
  compilerThingML.sh -t testconfigurationgen -s $testFile --options arduino > /dev/null 2>> $CUR_FOLDER/thingml_error.log
done

cd _arduino

for thingTest in `find $PWD -name '*.thingml'`; do
  compilerThingML.sh -c arduino -s $thingTest > /dev/null 2>> $CUR_FOLDER/thingml_error.log
done

echo "logfile $CUR_FOLDER/arduino.log" > $TMP/screenrc

for inoFile in `find $PWD -name '*.ino'`; do
  cd $TMP
  fold="ano`date +%s`"
  mkdir $fold
  cd $fold
  mkdir src lib
  cp $inoFile src/
  ln -s $LIB lib
  ano build > /dev/null 2>> $CUR_FOLDER/arduino_error.log
  ano upload > /dev/null
  screen -c $TMP/screenrc -d -m -L -S arduino /dev/ttyACM0 9600 &
  sleep 5
  screen -X -S arduino quit
done

cd $CUR_FOLDER
