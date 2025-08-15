#!/bin/bash

set -e

if [[ ${RUN_FROM_MAIN} != "1" ]]; then
    echo "Don't run this standalone, this is supposed to tail off docker-ota-build or vm-ota-build"
    exit 1
fi

if [[ ${PRODorOSKR} == "proddev" ]]; then
    export BUILD_TYPE=prod
elif [[ ${PRODorOSKR} == "epdev" ]]; then
    export BUILD_TYPE=prod
elif [[ ${PRODorOSKR} == "prod" ]]; then
    export BUILD_TYPE=prod
elif [[ ${PRODorOSKR} == "ep" ]]; then
    export BUILD_TYPE=prod
elif [[ ${PRODorOSKR} == "oskr" ]]; then
    export BUILD_TYPE=oskr
elif [[ ${PRODorOSKR} == "dev" ]]; then
    export BUILD_TYPE=dev
fi

if [[ ${DO_SIGN} == "1" ]]; then
    if [[ ${PRODorOSKR} == "oskr" ]]; then
        export BUILD_TYPE=oskrs
    fi
fi

cd anki/victor-1.6

echo "Cleaning victor before build"
git clean -ffdx

echo "Building Victor"
./wire/build-d.sh
./project/victor/scripts/stage.sh -c Release

cd ../dvcbs-reloaded
mkdir -p mounted/
mv ../../_build/vicos-1.6.1.$INCREMENT*.ota mounted/ -v

sudo ./dvcbs-reloaded.sh -m

sudo rm -rf mounted/edits/anki -v
sudo mv ../victor-1.6/_build/staging/Release/anki mounted/edits/anki -v
sudo ./dvcbs-reloaded.sh -bt 1.6.1 $INCREMENT $BUILD_TYPE

sudo mv mounted/* ../../_build/vicos-1.6.1.$INCREMENT.$PRODorOSKR.ota

cd ../../