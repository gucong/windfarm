#!/bin/bash

ROOT="$(readlink -e $(dirname $0)/..)"
BIN=$ROOT/bin
. $BIN/rc
cd $ROOT

mkdir -p combineMesh
cd combineMesh

CASE=windFarmCase

cp -rf $ROOT/statorMesh/stator $CASE

for f in $ROOT/statorMesh/*.csv; do
    BASENAME=$(basename $f .csv)
    echo "Preparing to merge $BASENAME ..."
    $BIN/prepareRotor.sh "$f"
done

cd $CASE

for f in $ROOT/statorMesh/*.csv; do
    BASENAME=$(basename $f .csv)
    echo "Merging $BASENAME to $CASE ..."
    logRun "log.mergeMeshes.$BASENAME" mergeMeshes . "../$BASENAME" -overwrite
done

for f in $ROOT/statorMesh/*.csv; do
    BASENAME=$(basename $f .csv)

    echo "Pairing AMI for $BASENAME ..."
    logRun "log.createPatch.$BASENAME" \
        createPatch -dict "system/$BASENAME.createPatchDict" -overwrite

    echo "Adding boundary fields for $BASENAME AMI ..."
    logRun "log.changeDictionary.$BASENAME" \
        changeDictionary -dict "system/$BASENAME.changeDictionaryDict"
done

echo
