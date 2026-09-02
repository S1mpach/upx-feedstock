# upx-feedstock

Conda recipe for [UPX](https://upx.github.io) 5.2.1, the executable packer.

Package: https://anaconda.org/s1mpach/upx

## Build

```
conda install -n base conda-build
conda build recipe -c conda-forge --override-channels
```

## Install

```
conda install -c s1mpach upx
```

## Notes

- Source is the release tarball `upx-5.2.1-src.tar.xz`, not the GitHub archive. The tarball has `vendor/` (zlib, zstd, UCL, LZMA SDK, bzip2) inside; conda-build doesn't pull submodules, so a git checkout would come out empty.
- Vendored libs are left as is. UPX patches UCL and LZMA SDK and upstream doesn't support system copies, so `host` is empty and the package only depends on the C++ runtime.
- `UPX_CONFIG_DISABLE_WERROR/WSTRICT/SANITIZE/GITREV` are set so the build doesn't die on a newer compiler or on a missing `.git`.
- On Windows `bld.bat` passes `CMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDLL`. Upstream defaults to a static CRT, conda-forge links it dynamically.
- Upstream `ctest` runs during the build (1500 tests incl. self-pack). The package test compiles `hello.c`, packs it with `upx --best`, runs the packed binary, checks `upx -t`, unpacks and compares with the original. Hello is linked statically because a dynamic one is too small to pack.

- UPX doesn't pack Mach-O since 4.2.0, so on macOS the self-pack test is disabled in `ctest` and the package test only does the smoke checks. The macOS build is still useful for packing ELF/PE files.

Built and tested on Linux x86-64. macOS and Windows go through CI only.
