@echo off

setlocal
set cflags=/EHsc /std:c11 /Od /Zi /utf-8 /validate-charset /W3 /sdl /MD
set linkflags=/link /DEBUG
set srcfiles=..\main.c ..\chunk.c ..\vm.c ..\debug.c ..\value.c ..\memory.c ..\compiler.c ..\scanner.c ..\object.c ..\table.c

call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" amd64

if not exist build mkdir build
pushd build

call cl %cflags% %srcfiles% %linkflags%

popd