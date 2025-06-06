#!/bin/zsh

cd src/lib
clang main.c vector.c vec_simd_linux.s -o ../../target/main
cd ../..
target/main
