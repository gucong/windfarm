#!/bin/bash

ROOT="$(readlink -e $(dirname $0)/..)"
BIN=$ROOT/bin
. $BIN/rc

echo "csv file : " "$1"

NAME=$(cat $1 | cut -d, -f1)
echo "|name     : " "$NAME"
REFLECT=$(cat $1 | cut -d, -f2)
echo "|reflect  : " "$REFLECT"
CENTER=$(cat $1 | cut -d, -f3)
echo "|center   : " "$CENTER"
VELOCITY=$(cat $1 | cut -d, -f4)
echo "|velocity : " "$VELOCITY"
echo

mkdir -p constant/triSurface
echo "Transforming ${NAME}Interface surface to $CENTER ..."
logRun "log.surfaceTransformPoints.$NAME" \
    surfaceTransformPoints -translate "$CENTER" \
    $ROOT/triSurface/interface.obj constant/triSurface/${NAME}Interface.obj \

echo "Adding ${NAME}Interface to $CASE ..."
sed "s/__NAME__/$NAME/g" < $ROOT/templates/surfaceFeatureExtractDict.temp >> system/surfaceFeatureExtractDict
sed "s/__NAME__/$NAME/g" < $ROOT/templates/snappyHexMeshDict.temp >> system/snappyHexMeshDict
sed "s/__NAME__/$NAME/g" < $ROOT/templates/features.snappyHexMeshDict.temp >> system/featuresList
sed "s/__NAME__/$NAME/g" < $ROOT/templates/pairAMI.createPatchDict.temp > "system/${NAME}.createPatchDict"
sed "s/__NAME__/$NAME/g" < $ROOT/templates/changeDictionaryDict.temp > "system/${NAME}.changeDictionaryDict"

echo
