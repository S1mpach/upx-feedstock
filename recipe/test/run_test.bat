@echo off
setlocal EnableDelayedExpansion
set "EXPECTED=hello from the upx test"

echo == upx --version ==
upx --version
if errorlevel 1 exit 1

echo == compile hello.c ==
cl /nologo /O2 /Fe:hello.exe test\hello.c
if errorlevel 1 exit 1
for /f "delims=" %%o in ('hello.exe') do set "OUT=%%o"
if not "!OUT!"=="%EXPECTED%" ( echo FAIL: original output differs & exit 1 )
for %%f in (hello.exe) do set ORIG_SIZE=%%~zf

echo == upx --best hello.exe ==
copy /y hello.exe hello.orig.exe >nul
upx --best hello.exe
if errorlevel 1 exit 1
for %%f in (hello.exe) do set PACKED_SIZE=%%~zf
echo original: !ORIG_SIZE! bytes, packed: !PACKED_SIZE! bytes
if not !PACKED_SIZE! LSS !ORIG_SIZE! ( echo FAIL: packed file is not smaller & exit 1 )

echo == run packed binary ==
for /f "delims=" %%o in ('hello.exe') do set "OUT=%%o"
if not "!OUT!"=="%EXPECTED%" ( echo FAIL: packed binary output differs & exit 1 )

echo == upx -t ==
upx -t hello.exe
if errorlevel 1 exit 1

echo == upx -l ==
upx -l hello.exe
if errorlevel 1 exit 1

echo == upx -d ==
upx -d hello.exe
if errorlevel 1 exit 1
for /f "delims=" %%o in ('hello.exe') do set "OUT=%%o"
if not "!OUT!"=="%EXPECTED%" ( echo FAIL: unpacked binary output differs & exit 1 )
fc /b hello.exe hello.orig.exe >nul
if errorlevel 1 ( echo FAIL: unpacked binary differs from original & exit 1 )
echo unpacked binary is byte-identical to the original

echo All tests passed.
