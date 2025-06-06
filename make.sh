#!/bin/zsh

cd src/vector
clang main.c vector.c vec_simd_linux.s -o ../../target/main
cd ../..
target/main
