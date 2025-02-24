#!/bin/bash

pushd "$(dirname "$0")"

read -p "Start with Pico 2 in bootsel mode"

./gen_benchmarks.sh speedups 2.1.1
./gen_benchmarks.sh 2.1.1
./gen_benchmarks.sh 2.1.0
./gen_benchmarks.sh 2.0.0

read -p "Switch to Pico in bootsel mode"

export PICO_BOARD="pico"

./gen_benchmarks.sh speedups 2.1.1
./gen_benchmarks.sh 2.1.1
./gen_benchmarks.sh 2.1.0
./gen_benchmarks.sh 2.0.0
