#!/bin/bash
# Usage ./gen_benchmarks.sh [PICOTOOL_VERSION] [SDK_VERSION]

# Board, and bin size in MB
board=${PICO_BOARD-pico2}
size=256

# Rough size of binary itself
bin_size=8

pushd "$(dirname "$0")"

if [ ! -z $1 ]; then
    ./clone_picotool.sh $1 $2
    picotool=$(pwd)/$1/install/picotool/picotool
    build_args="-DPICO_SDK_PATH=$(pwd)/$1/pico-sdk -Dpicotool_DIR=$(pwd)/$1/install/picotool"
    version=$1
else
    picotool=picotool
    build_args="-DPICO_SDK_FETCH_FROM_GIT=ON"
    version=$($picotool version -s)
fi

gen_board_size () {
    dd if=/dev/random of=dat.bin bs=1024 count=$(($size - $bin_size))

    rm -rf build
    cmake -S . -B build -DPICO_BOARD=$board $build_args
    cmake --build build --parallel 20

    rm *.uf2
    cp build/*.uf2 ./

    echo "Using size $size"
    du -h build/bench.bin
}

run_benchmarks () {
    ret=$( TIMEFORMAT="%R"; { time $picotool load ./$bin.uf2 >/dev/null; } 2>&1 )
    echo "    load:       $ret"
    echo "$version,$board,$size,$bin,load,$ret" >> out.csv
    ret=$( TIMEFORMAT="%R"; { time $picotool save flash.bin >/dev/null; } 2>&1 )
    echo "    save:       $ret"
    echo "$version,$board,$size,$bin,save,$ret" >> out.csv
    ret=$( TIMEFORMAT="%R"; { time $picotool save --range 0x10000000 $(printf '%x' $(($size*1024 + 0x10000000))) flash.bin >/dev/null; } 2>&1 )
    echo "    save_range: $ret"
    echo "$version,$board,$size,$bin,save_range,$ret" >> out.csv
    ret=$( TIMEFORMAT="%R"; { time $picotool info >/dev/null; } 2>&1 )
    echo "    info:       $ret"
    echo "$version,$board,$size,$bin,info,$ret" >> out.csv
    ret=$( TIMEFORMAT="%R"; { time $picotool info -a >/dev/null; } 2>&1 )
    echo "    info_all:   $ret"
    echo "$version,$board,$size,$bin,info_all,$ret" >> out.csv
}

declare -a sizes=(128 256 512 1024 2048 4096)

for i in ${sizes[@]}
do
    size=$i
    gen_board_size

    bin="bench"
    echo "unhashed"
    run_benchmarks

    if [ -e "./bench_hashed.uf2" ]; then
        bin="bench_hashed"
        echo "hashed"
        run_benchmarks
    fi
done

popd
