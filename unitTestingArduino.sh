#!/bin/bash
#
# Description:
#     This script is meant to compile ThingML test file specifying expected
#  input and output with @test annotations. The generated ThingML files with
#  configuration are then compiled to arduino one by one and uploaded to an
#  Arduino board connected as the `ttyACM0` device.
#
# Author:
# - Alexandre RIO <contact@alexrio.fr>
#
# Dependencies:
# - ano: https://github.com/scottdarch/Arturo
# - screen: classic one, from GNU
# - compilerThingML.sh: wrapping the ThingML compiler
#
############################################################################

CUR_FOLDER=$PWD
TIMEOUT=5
LIB="$HOME/SINTEF/lib-arduino/"
TMP="/tmp/"

echo "Starting testing at: `date`" >> $CUR_FOLDER/thingml.log
for testFile in `ls test*.thingml`; do
  compilerThingML.sh -t testconfigurationgen -s $testFile --options arduino > /dev/null 2>> $CUR_FOLDER/thingml_error.log
done

echo "End generating test files at: `date`" >> $CUR_FOLDER/thingml.log

cd _arduino

for thingTest in `find $PWD -name '*.thingml'`; do
  compilerThingML.sh -c arduino -s $thingTest > /dev/null 2>> $CUR_FOLDER/thingml_error.log
done

echo "End compiling thingml test to arduino at: `date`" >> $CUR_FOLDER/thingml.log

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
  sleep $TIMEOUT
  screen -X -S arduino quit
done

echo "End testing at: `date`" >> $CUR_FOLDER/thingml.log

cd $CUR_FOLDER
