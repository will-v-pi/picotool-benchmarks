#!/bin/bash

if [ -z $1 ]; then
    echo "Usage: ./clone_picotool.sh <GIT_TAG> [SDK_TAG]"
    exit 1
fi

mkdir $1
pushd $1

git -c advice.detachedHead=false clone --depth 1 --branch $1 ${PICOTOOL_GIT_URL-"https://github.com/raspberrypi/picotool.git"}
git -c advice.detachedHead=false clone --depth 1 --branch ${2-$1} ${PICO_SDK_GIT_URL-"https://github.com/raspberrypi/pico-sdk.git"}
git -C pico-sdk submodule update --init lib/mbedtls

cmake -S picotool -B build -DPICO_SDK_PATH=$(pwd)/pico-sdk -G Ninja -DPICOTOOL_FLAT_INSTALL=1 -DCMAKE_INSTALL_PREFIX=$(pwd)/install
cmake --build build
cmake --install build

popd
