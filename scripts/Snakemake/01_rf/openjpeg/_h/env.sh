#!/bin/bash

module load gcc

VERSION=2.4.0
APP_NAME=openjpeg
PREFIX=${HOME}'/softwares_compiled/'${APP_NAME}'/'$VERSION

export OPENJPEG2_CFLAGS=-I$PREFIX/usr/local/binclude
export OPENJPEG2_LIBS=-L$PREFIX/usr/local/lib
export PATH=$PREFIX/usr/local/bin:$PATH

