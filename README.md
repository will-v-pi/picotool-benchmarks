To benchmark the currently installed picotool,
run `./gen_benchmarks.sh`

To benchmark a specific version of picotool (eg 2.1.1),
run `./gen_benchmarks.sh 2.1.1`

To benchmark a specific branch of picotool (eg speedups) you can specify the compatible SDK branch/version (eg 2.1.1),
run `./gen_benchmarks.sh speedups 2.1.1`

There is also a `./bench_all.sh` script to benchmark versions since 2.0.0

To use different git repos, set the `PICOTOOL_GIT_URL` and `PICO_SDL_GIT_URL` environment variables

To use a different board (eg `pico` instead of `pico2`), set the `PICO_BOARD` environment variable
