#!/bin/bash

pushd "$(dirname "$0")"

./gen_benchmarks.sh speedups 2.1.1
./gen_benchmarks.sh 2.1.1
./gen_benchmarks.sh 2.1.0
./gen_benchmarks.sh 2.0.0
