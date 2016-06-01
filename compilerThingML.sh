#!/bin/bash
#
# Description:
#     This script is a wrapper for the ThingML compiler. You can get it
#  and compile it at: https://github.com/SINTEF-9012/ThingML
#
# Author:
# - Alexandre RIO <contact@alexrio.fr>
#
# Dependencies:
# - Java JRE Version 7 or better
#
############################################################################

THINGML_JAR=$HOME/.bin/thingml.jar
THINGML_PLUGINS=$HOME/.bin/thingml-network-plugins.jar

java -cp $CLASSPATH:$THINGML_JAR:$THINGML_PLUGINS org.thingml.compilers.commandline.Main "$@"
