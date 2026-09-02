#!/bin/bash
set -euxo pipefail

# upx cannot pack Mach-O since 4.2.0, so the self-pack test cannot run on macOS
SELF_PACK=OFF
[ "$(uname)" = "Darwin" ] && SELF_PACK=ON

cmake -S . -B build -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DUPX_CONFIG_DISABLE_WERROR=ON \
    -DUPX_CONFIG_DISABLE_WSTRICT=ON \
    -DUPX_CONFIG_DISABLE_SANITIZE=ON \
    -DUPX_CONFIG_DISABLE_GITREV=ON \
    -DUPX_CONFIG_DISABLE_SELF_PACK_TEST=${SELF_PACK}

cmake --build build --parallel "${CPU_COUNT}"
ctest --test-dir build --output-on-failure
cmake --install build --strip
