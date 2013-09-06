#!/bin/bash

ROOT="$(readlink -e $(dirname $0)/..)"
BIN=$ROOT/bin
. $BIN/rc
cd $ROOT

mkdir -p statorMesh
cd statorMesh

echo "Cloning from stator ..."
cp -rf $ROOT/stator $ROOT/statorMesh/stator

echo "Parsing stator/constant/dynamicMeshDict ..."
logRun log.parseDyM $BIN/parseDyM -case stator

cd stator

for f in $ROOT/statorMesh/*.csv; do
    BASENAME=$(basename $f .csv)
    echo "Preparing interface for $BASENAME ..."
    $BIN/prepareStator.sh "$f"
done

# closing featuresList file
echo ");" >> system/featuresList

echo "Generating mesh for stator ..."
logRun log.blockMesh blockMesh
logRun log.surfaceFeatureExtract surfaceFeatureExtract
logRun log.snappyHexMesh snappyHexMesh -overwrite

rm -rf 0
cp -r 0.org 0
