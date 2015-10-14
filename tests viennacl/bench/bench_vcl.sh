#!/bin/bash

# This script calls benchmarks "bench_viennacl" and "bench_viennacl_avx" (and it all its versions).
# The according executables should be in '../build' ! Output is generated in './' .
# Up to two arguments (double and/or float) specify with what data-type the matrices should be filled.
# An optional third argument enables fast-mode, which skips transopsed cases

FLOAT="float"
DOUBLE="double"
FAST="fast"

# enable fast mode which skips transposed cases in matrix-matrix multiplication
if [[ $1 = $FAST || $2 = $FAST || $3 = $FAST ]]; then
    FAST="fast"
else
    FAST=""
fi

# bench with foat entries
if [[ $1 = $FLOAT || $2 = $FLOAT || $3 = $FLOAT ]]; then

    printf "starting benchmark with floats!\n"
    
    # overwrite previous data
    printf "" > float_data_vcl

    for i in {1000..3000..100}
    do
        printf %s "$(echo $i) " >> float_data_vcl
        printf %s "$(../build/bench_viennacl $i float $FAST)" >> float_data_vcl
        printf %s "$(../build/bench_viennacl_avx $i float $FAST)" >> float_data_vcl
        printf %s "$(../build/bench_viennacl_avx2 $i float $FAST)" >> float_data_vcl
        printf "\n" >> float_data_vcl
    done

    printf %s "$(cat float_data_vcl.conf|gnuplot)"
fi

# bench with double entries
if [[ $1 = $DOUBLE || $2 = $DOUBLE ||  $3 = $DOUBLE ]]; then

    printf "starting benchmark with doubles!\n"
    
    # overwrite previous data
    printf "" > double_data_vcl

    for i in {1000..2000..50}
    do
        printf %s "$(echo $i) " >> double_data_vcl
        printf %s "$(../build/bench_viennacl $i double $FAST)" >> double_data_vcl
        printf %s "$(../build/bench_viennacl_avx $i double $FAST)" >> double_data_vcl
        printf %s "$(../build/bench_viennacl_avx2 $i double $FAST)" >> double_data_vcl
        printf "\n" >> double_data_vcl
    done

    printf %s "$(cat double_data_vcl.conf|gnuplot)"
fi