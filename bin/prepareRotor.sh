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

echo "Cloning $NAME from rotor$REFLECT ..."
cp -rf $ROOT/rotorMesh/rotor$REFLECT "$NAME"
sed "s/__NAME__/$NAME/g" < $ROOT/templates/rotor.createPatchDict.temp > "$NAME/system/createPatchDict"
sed "s/__NAME__/$NAME/g" < $ROOT/templates/rotor.topoSetDict.temp > "$NAME/system/topoSetDict"
cd "$NAME"

echo "Changing cellZone name to $NAME ..."
logRun log.topoSet topoSet -constant

echo "Changing interface name to ${NAME}Rot ..."
logRun log.createPatchDict createPatch -overwrite

echo "Translating mesh to $CENTER ..."
logRun log.translate.transformPoints transformPoints -translate "$CENTER"

cd ..

echo
