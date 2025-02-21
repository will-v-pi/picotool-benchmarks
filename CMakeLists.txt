set(PICO_FLASH_SIZE_BYTES 16*1024*1024)

cmake_minimum_required(VERSION 3.13)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Pull in Raspberry Pi Pico SDK (must be before project)
include(pico_sdk_import.cmake)

project(benchmarks C CXX ASM)

# Initialise the Raspberry Pi Pico SDK
pico_sdk_init()

# regular benchmark
add_executable(bench
        bench.c
        inc.S
)
target_include_directories(bench PRIVATE ${CMAKE_CURRENT_LIST_DIR})
# pull in common dependencies
target_link_libraries(bench pico_stdlib)
# create map/bin/hex/uf2 file etc.
pico_add_extra_outputs(bench)

if (NOT PICO_PLATFORM STREQUAL rp2040)
    # hashed benchmark
    add_executable(bench_hashed
            bench.c
            inc.S
    )
    target_include_directories(bench_hashed PRIVATE ${CMAKE_CURRENT_LIST_DIR})
    # pull in common dependencies
    target_link_libraries(bench_hashed pico_stdlib)
    # create map/bin/hex/uf2 file etc.
    pico_hash_binary(bench_hashed)
    pico_add_extra_outputs(bench_hashed)
endif()
