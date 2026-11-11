#!/usr/bin/env bash
set -euo pipefail
: "${ANDROID_NDK_HOME:?Set ANDROID_NDK_HOME to Android NDK 29.0.13113456}"
: "${HOST_TAG:?Set HOST_TAG to the NDK host directory name}"
: "${FFMPEG_LIB_DIR:?Set FFMPEG_LIB_DIR to the rebuilt arm64-v8a static library directory}"
script_dir="$(cd "$(dirname "$0")" && pwd)"
ndk_toolchain="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/$HOST_TAG"
compiler="$ndk_toolchain/bin/clang++"
if [[ "$HOST_TAG" == windows-* ]]; then compiler="$compiler.exe"; fi
"$compiler" --target=aarch64-none-linux-android24 --sysroot="$ndk_toolchain/sysroot" \
  -fPIC -g -static-libstdc++ -Wl,--build-id=sha1 -Wl,--no-rosegment \
  -Wl,--no-undefined-version -Wl,--fatal-warnings -Wl,--no-undefined \
  -Wl,-z,max-page-size=16384 -Wl,--exclude-libs,ALL \
  -shared -Wl,-soname,libsaltffmpeg.so -o "${1:-libsaltffmpeg.so}" \
  "$script_dir/ffmpeg_bridge.cpp.o" -Wl,--start-group \
  "$FFMPEG_LIB_DIR/libavformat.a" "$FFMPEG_LIB_DIR/libavcodec.a" \
  "$FFMPEG_LIB_DIR/libswresample.a" "$FFMPEG_LIB_DIR/libavutil.a" \
  -Wl,--end-group -lm -lz -ldl -latomic
