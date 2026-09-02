@echo off

:: MultiThreadedDLL: dynamic CRT per conda-forge convention (upstream defaults to static)
cmake -S . -B build -G Ninja ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
    -DCMAKE_INSTALL_BINDIR=bin ^
    -DCMAKE_INSTALL_LIBDIR=lib ^
    -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDLL ^
    -DUPX_CONFIG_DISABLE_WERROR=ON ^
    -DUPX_CONFIG_DISABLE_WSTRICT=ON ^
    -DUPX_CONFIG_DISABLE_SANITIZE=ON ^
    -DUPX_CONFIG_DISABLE_GITREV=ON
if errorlevel 1 exit 1

cmake --build build --parallel %CPU_COUNT%
if errorlevel 1 exit 1

ctest --test-dir build --output-on-failure
if errorlevel 1 exit 1

cmake --install build
if errorlevel 1 exit 1
