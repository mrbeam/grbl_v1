#!/bin/bash

echo "Compiling grbl.senior.hex"
make clean
make && cp grbl.hex grbl.senior.hex

echo "Compiling grbl.junior.hex"
make clean
make CFLAGS=-DMRBEAM_JUNIOR && cp grbl.hex grbl.junior.hex

echo "done"

