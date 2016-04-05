#!/bin/bash

FILES=(testDeepCompositeStatesWithStream.thingml testHistoryStatesWithStream.thingml testJoinFilter.thingml testLengthSimpleSource.thingml testMergeFilter.thingml testMergeStreams.thingml testSimpleFilter.thingml testStreams.thingml)

for file in "${FILES[@]}"
do
  compilerThingML.sh -t testconfigurationgen -s $file --options arduino > /dev/null
done
