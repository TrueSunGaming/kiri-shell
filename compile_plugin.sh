#!/usr/bin/env sh

cd $(dirname "$0")/plugin
cmake -B build -G Ninja
cmake --build build
cd ..

./reload.sh