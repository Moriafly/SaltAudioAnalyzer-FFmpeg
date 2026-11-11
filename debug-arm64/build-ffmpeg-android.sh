#!/usr/bin/env bash
set -euo pipefail
export PATH=/usr/bin:$PATH

# Supply an FFmpeg source checkout and an installed Android NDK. The output is
# static libraries are linked into the Android bridge; no source files are modified.
: "${FFMPEG_SOURCE:?Set FFMPEG_SOURCE to the FFmpeg source directory}"
: "${ANDROID_NDK_HOME:?Set ANDROID_NDK_HOME to the Android NDK directory}"

abi="${1:?Usage: build-ffmpeg-android.sh <abi> <build-directory> <output-directory>}"
build_dir="${2:?Missing build directory}"
output_dir="${3:?Missing output directory}"
case "$abi" in
  arm64-v8a) arch=aarch64; target=aarch64-linux-android ;;
  *) echo "Unsupported ABI: $abi (only arm64-v8a is supported)" >&2; exit 1 ;;
esac

case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*)
    host=windows-x86_64
    executable=.exe
    FFMPEG_SOURCE="$(cygpath -u "$FFMPEG_SOURCE")"
    ANDROID_NDK_HOME="$(cygpath -u "$ANDROID_NDK_HOME")"
    build_dir="$(cygpath -u "$build_dir")"
    output_dir="$(cygpath -u "$output_dir")"
    ;;
  Darwin*) host=darwin-x86_64; executable= ;;
  Linux*) host=linux-x86_64; executable= ;;
  *) echo "Unsupported host" >&2; exit 1 ;;
esac

toolchain="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/$host"
mkdir -p "$build_dir" "$output_dir/$abi"
cd "$build_dir"
"$FFMPEG_SOURCE/configure" \
  --target-os=android --arch="$arch" --enable-cross-compile \
  --cc="$toolchain/bin/clang$executable" \
  --ar="$toolchain/bin/llvm-ar$executable" \
  --ranlib="$toolchain/bin/llvm-ranlib$executable" \
  --strip="$toolchain/bin/llvm-strip$executable" \
  --sysroot="$toolchain/sysroot" \
  --extra-cflags="--target=${target}24" \
  --extra-ldflags="--target=${target}24 -Wl,-z,max-page-size=16384" \
  --disable-everything --disable-avdevice --disable-avfilter --disable-swscale \
  --enable-protocol=file,pipe \
  --enable-demuxer=aac,ac3,ac4,eac3,aiff,ape,asf,dsf,flac,matroska,mov,mp3,ogg,wav,wv \
  --enable-decoder=aac,ac3,eac3,alac,ape,flac,mp2,mp3,mp3float,opus,vorbis,wavpack,wmav1,wmav2,wmapro,wmalossless,wmavoice,dsd_lsbf_planar,dsd_msbf_planar,pcm_alaw,pcm_mulaw,pcm_s8,pcm_u8,pcm_s16le,pcm_s16be,pcm_u16le,pcm_u16be,pcm_s24le,pcm_s24be,pcm_u24le,pcm_u24be,pcm_s32le,pcm_s32be,pcm_u32le,pcm_u32be,pcm_s64le,pcm_s64be,pcm_f32le,pcm_f32be,pcm_f64le,pcm_f64be \
  --enable-parser=aac,ac3,flac,opus,mpegaudio \
  --disable-programs --disable-doc --disable-network --disable-autodetect \
  --disable-x86asm --disable-shared --enable-static --enable-pic
make -j"${JOBS:-4}"
for library in avutil swresample avcodec avformat; do
  cp "lib$library/lib$library.a" "$output_dir/$abi/"
done
