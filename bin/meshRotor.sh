#!/bin/bash

ROOT="$(readlink -e $(dirname $0)/..)"
BIN=$ROOT/bin
. $BIN/rc
cd $ROOT

mkdir -p rotorMesh

for n in 0 1; do
    cd $ROOT/rotorMesh
    echo "Generating mesh for rotor$n ..."
    cp -rf $ROOT/rotor $ROOT/rotorMesh/rotor$n
    cd rotor$n
    mkdir -p constant/triSurface
    cp {$ROOT,constant}/triSurface/interface.obj

    if [ "$n" == 1 ]; then
        echo "(reflection on turbine)"
        logRun log.surfaceTransformPoints \
            surfaceTransformPoints -rollPitchYaw '(0 0 180)' -scale '(1 -1 1)' \
            {$ROOT,constant}/triSurface/turbine.obj || exit 1
    else
        echo "(no reflection on turbine)"
        cp {$ROOT,constant}/triSurface/turbine.obj
    fi

    logRun log.blockMesh blockMesh || exit 1
    logRun log.surfaceFeatureExtract surfaceFeatureExtract || exit 1
    logRun log.snappyHexMesh snappyHexMesh -overwrite || exit 1
done
