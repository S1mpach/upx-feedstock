#!/bin/bash
set -euxo pipefail

cmake -S . -B build -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DUPX_CONFIG_DISABLE_WERROR=ON \
    -DUPX_CONFIG_DISABLE_WSTRICT=ON \
    -DUPX_CONFIG_DISABLE_SANITIZE=ON \
    -DUPX_CONFIG_DISABLE_GITREV=ON

cmake --build build --parallel "${CPU_COUNT}"
ctest --test-dir build --output-on-failure
cmake --install build
