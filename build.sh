#!/bin/sh
# Change your executable name here
GAME_NAME="main"

# Set your sources here (relative paths!)
# Example with two source folders:
# SOURCES="src/*.c src/submodule/*.c"
SOURCES="*.c"

# About this build script: it does many things, but in essence, it's
# very simple. It has 3 compiler invocations: building raylib (which
# is not done always, see logic by searching "Build raylib"), building
# src/*.c files, and linking together those two. Each invocation is
# wrapped in an if statement to make the -qq flag work, it's pretty
# verbose, sorry.

# Stop the script if a compilation (or something else?) fails
set -e

# Get arguments
while getopts ":hdusrcq" opt; do
    case $opt in
        h)
            echo "Usage: ./build-linux.sh [-hdusrcqq]"
            echo " -h  Show this information"
            echo " -d  Faster builds that have debug symbols, and enable warnings"
            echo " -r  Run the executable after compilation"
            echo " -c  Remove the temp/(debug|release) directory, ie. full recompile"
            echo " -q  Suppress this script's informational prints"
            echo "Examples:"
            echo " Build a release build:                    ./build-linux.sh"
            echo " Build a debug build and run:              ./build-linux.sh -d -r"
            echo " Build in debug, run, quietly:             ./build-linux.sh -drq"
            exit 0
            ;;
        d)
            BUILD_DEBUG="1"
            ;;
        r)
            RUN_AFTER_BUILD="1"
            ;;
        q)
            QUIET="1"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Set CC if it's not set already
if [ -z "$CC" ]; then
    CC=gcc
fi

# Directories
ROOT_DIR=$PWD
SOURCES="$ROOT_DIR/$SOURCES"

# Flags
OUTPUT_DIR="build"
COMPILATION_FLAGS="-std=c99 -Os -flto"
WARNING_FLAGS="-Wall -Wpedantic"
LINK_FLAGS="-flto"
# Debug changes to flags
if [ -n "$BUILD_DEBUG" ]; then
    COMPILATION_FLAGS="-std=c99 -O0 -g"
    LINK_FLAGS=""
fi

# Display what we're doing
if [ -n "$BUILD_DEBUG" ]; then
    [ -z "$QUIET" ] && echo "COMPILE-INFO: Compiling in debug mode. ($COMPILATION_FLAGS $WARNING_FLAGS)"
else
    [ -z "$QUIET" ] && echo "COMPILE-INFO: Compiling in release mode. ($COMPILATION_FLAGS $FINAL_COMPILE_FLAGS)"
fi

# Build the actual game
mkdir -p $OUTPUT_DIR
cd $OUTPUT_DIR
[ -z "$QUIET" ] && echo "COMPILE-INFO: Compiling game code."
$CC -o $GAME_NAME $COMPILATION_FLAGS $WARNING_FLAGS $SOURCES $LINK_FLAGS

[ -z "$QUIET" ] && echo "COMPILE-INFO: Game compiled into an executable in: $OUTPUT_DIR/"

[ -z "$QUIET" ] && echo "COMPILE-INFO: All done."

if [ -n "$RUN_AFTER_BUILD" ]; then
    [ -z "$QUIET" ] && echo "COMPILE-INFO: Running."
    ./$GAME_NAME "$ROOT_DIR/test.lox"
fi
cd $ROOT_DIR
