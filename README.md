# Salt Audio Analyzer — FFmpeg materials

This private repository contains a development snapshot for the arm64-v8a debug build. It is not a final release or a substitute for providing corresponding materials to recipients.

`ffmpeg-7.1.1-source.tar.gz` is the actual FFmpeg source directory used by the local build. `debug-arm64/build-ffmpeg-android.sh` records the configure and build options. `debug-arm64/ffmpeg_bridge.cpp.o` is the corresponding compiled bridge object; it does not include the application's source code.

To rebuild the FFmpeg libraries, extract the source archive and run the build script with Android NDK 29.0.13113456, an Android SDK, bash and make. Set `FFMPEG_SOURCE` and `ANDROID_NDK_HOME`; pass `arm64-v8a`, a build directory and an output directory as arguments. The libraries will be under `<output directory>/arm64-v8a`.

To relink the bridge, set `ANDROID_NDK_HOME`, `HOST_TAG` (for example `windows-x86_64`) and `FFMPEG_LIB_DIR` to that library directory, then run `bash debug-arm64/relink.sh`. The output path can be passed as the first argument. This snapshot is associated with the current debug build only. Repeat the process and validate relinking for every release; publish the exact corresponding materials to recipients at release time.

FFmpeg is licensed under LGPL 2.1 or later. Its license and attribution are in the source archive. This repository also contains a compiled proprietary application object; review its contents and the release process before making the repository public.
