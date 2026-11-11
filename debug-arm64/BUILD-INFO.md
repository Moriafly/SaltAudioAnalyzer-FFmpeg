# Debug build identification

ABI: arm64-v8a
FFmpeg: 7.1.1
Android NDK: 29.0.13113456
Android API: 24

SHA-256 hashes of the local debug build artifacts:

FD90DAD9C0EC1E46C6E4A53024A5EDAF57BA709BBD23802F4008E2C985F4AF94  app-debug.apk
07E2E19CA56CEF8928D26418A74B928FFE97EF6987011911BDC2E16CAC398A65  libsaltffmpeg.so (unstripped)
1807E17C44D8FD7867F4F853B179AF404E6FA1C55F9678CE76F268D34E0FDBCD  libavformat.a
EF84C1CD2046FD62C6CF7F44343CEAFDD58D4EEDE237A8E2EFA37A7582802E9C  libavcodec.a
A9DE9C7C07B24208E4C4328B4F2BDE8E4847DE77B8A5120886D505EF91FF2C8C  libswresample.a
8E2CB44303FAA728E28A21C2BC72D5078E3C9F974E3764EBAEF982AB7C913101  libavutil.a

The source archive was extracted and rebuilt using build-ffmpeg-android.sh. The bridge object was linked with the rebuilt libraries; exported dynamic symbols matched the local original. Runtime behavior on a device has not been verified.
