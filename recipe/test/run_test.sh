#!/bin/bash
set -euo pipefail

EXPECTED="hello from the upx test"

echo "== upx --version =="
upx --version | head -n 1
upx --help >/dev/null
upx --sysinfo

# upx cannot pack Mach-O since 4.2.0; only smoke tests on macOS
if [ "$(uname)" = "Darwin" ]; then
    echo "macOS: skipping pack/unpack test (Mach-O not supported by upx)"
    exit 0
fi

echo "== compile hello.c =="
# static link where possible: a dynamic hello world is too small to pack
if ${CC} -O2 -static -o hello test/hello.c 2>/dev/null; then
    echo "(static link)"
else
    ${CC} -O2 -o hello test/hello.c
    echo "(dynamic link)"
fi
[ "$(./hello)" = "${EXPECTED}" ]
orig_size=$(wc -c < hello)

echo "== upx --best hello =="
cp hello hello.orig
upx --best hello
packed_size=$(wc -c < hello)
echo "original: ${orig_size} bytes, packed: ${packed_size} bytes"
[ "${packed_size}" -lt "${orig_size}" ] || { echo "FAIL: packed file is not smaller"; exit 1; }

echo "== run packed binary =="
[ "$(./hello)" = "${EXPECTED}" ] || { echo "FAIL: packed binary output differs"; exit 1; }

echo "== upx -t =="
upx -t hello

echo "== upx -l =="
upx -l hello

echo "== upx -d =="
upx -d hello
[ "$(./hello)" = "${EXPECTED}" ] || { echo "FAIL: unpacked binary output differs"; exit 1; }
cmp hello hello.orig && echo "unpacked binary is byte-identical to the original"

echo "All tests passed."
