class Ffmpeg < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"
  head "https://github.com/FFmpeg/FFmpeg.git", branch: "master"

  stable do
    url "https://ffmpeg.org/releases/ffmpeg-6.0.tar.xz"
    sha256 "57be87c22d9b49c112b6d24bc67d42508660e6b718b3db89c44e47e289137082"

    # Fix for binutils, remove with `stable` block on next release
    # https://www.linuxquestions.org/questions/slackware-14/regression-on-current-with-ffmpeg-4175727691/
    patch do
      url "https://github.com/FFmpeg/FFmpeg/commit/effadce6c756247ea8bae32dc13bb3e6f464f0eb.patch?full_index=1"
      sha256 "9800c708313da78d537b61cfb750762bb8ad006ca9335b1724dbbca5669f5b24"
    end
  end

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  option "with-librsvg", "Enable SVG files as inputs via librsvg"
  option "with-libssh", "Enable SFTP protocol via libssh"
  option "with-libvmaf", "Enable libvmaf scoring library"
  option "with-openh264", "Enable OpenH264 library"
  option "with-rav1e", "Enable Rav1e AV1 encoder library"
  option "with-snappy", "Enable HAP/Snappy library"
  option "with-tesseract", "Enable the tesseract OCR engine"
  option "with-zeromq", "Enable using libzeromq to receive commands sent through a libzeromq client"

  depends_on "dafyk/mpv/pkg-config" => :build

  depends_on "dafyk/mpv/aribb24"
  depends_on "dafyk/mpv/dav1d"
  depends_on "dafyk/mpv/aom"
  #depends_on "dafyk/mpv/jpeg-xl"
  depends_on "dafyk/mpv/libass"
  depends_on "dafyk/mpv/libmysofa"
  depends_on "dafyk/mpv/libplacebo"
  depends_on "dafyk/mpv/fdk-aac"
  depends_on "dafyk/mpv/fontconfig"
  depends_on "dafyk/mpv/freetype"
  depends_on "dafyk/mpv/frei0r"
  depends_on "dafyk/mpv/lame"
  depends_on "dafyk/mpv/libbluray"
  depends_on "dafyk/mpv/libbs2b"
  depends_on "dafyk/mpv/librist"
  depends_on "dafyk/mpv/libsoxr"
  depends_on "dafyk/mpv/libvidstab"
  depends_on "dafyk/mpv/libvorbis"
  depends_on "dafyk/mpv/libvpx"
  depends_on "dafyk/mpv/opencore-amr"
  depends_on "dafyk/mpv/openjpeg"
  depends_on "dafyk/mpv/openssl@3"
  depends_on "dafyk/mpv/opus"
  depends_on "dafyk/mpv/rubberband"
  depends_on "dafyk/mpv/sdl2"
  depends_on "dafyk/mpv/speex"
  depends_on "dafyk/mpv/srt"
  depends_on "dafyk/mpv/svt-av1"
  depends_on "dafyk/mpv/theora"
  depends_on "dafyk/mpv/webp"
  depends_on "dafyk/mpv/x264"
  depends_on "dafyk/mpv/x265"
  depends_on "dafyk/mpv/xvid"
  depends_on "dafyk/mpv/xz"
  depends_on "dafyk/mpv/zimg"

  depends_on "dafyk/mpv/game-music-emu" => :optional
  depends_on "dafyk/mpv/libcaca" => :optional
  depends_on "dafyk/mpv/libgsm" => :optional
  depends_on "dafyk/mpv/libmodplug" => :optional
  depends_on "dafyk/mpv/librsvg" => :optional
  depends_on "dafyk/mpv/libssh" => :optional
  depends_on "dafyk/mpv/libvmaf" => :optional      # Avoiding building Rust
  depends_on "dafyk/mpv/openh264" => :optional
  depends_on "dafyk/mpv/rav1e" => :optional        # Avoiding building Rust
  depends_on "dafyk/mpv/snappy" => :optional       # Build issue on macOS 10.13
  depends_on "dafyk/mpv/tesseract" => :optional    # Build issue on macOS <10.15
  depends_on "dafyk/mpv/two-lame" => :optional
  depends_on "dafyk/mpv/zeromq" => :optional       # Avoiding building Boost

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_intel do
    depends_on "dafyk/mpv/nasm" => :build
  end

  fails_with gcc: "5"

  # Fix for QtWebEngine, do not remove
  # https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=270209
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/ffmpeg/-/raw/5670ccd86d3b816f49ebc18cab878125eca2f81f/add-av_stream_get_first_dts-for-chromium.patch"
    sha256 "57e26caced5a1382cb639235f9555fc50e45e7bf8333f7c9ae3d49b3241d3f77"
  end

  patch do
    url "https://raw.githubusercontent.com/dafyk/mpv-macos-builds/main/ffmpeg.git-1231003c3c6d.patch.txt"
    sha256 "cfb25204162b59dc03c0c506df33da2fa75945bc40159232388e8f11db98764f"
  end

  def install
    # The new linker leads to duplicate symbol issue https://github.com/homebrew-ffmpeg/homebrew-ffmpeg/issues/140
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    args = %W[
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --prefix=#{prefix}

      --enable-gpl
      --enable-nonfree
      --enable-version3

      --enable-opencl
      --enable-pthreads
      --enable-shared
      --enable-static

      --enable-frei0r
      --enable-libaom
      --enable-libaribb24
      --enable-libass
      --enable-libbluray
      --enable-libbs2b
      --enable-libdav1d
      --enable-libfdk-aac
      --enable-libfontconfig
      --enable-libfreetype
      --enable-libmp3lame
      --enable-libmysofa
      --enable-libopencore-amrnb
      --enable-libopencore-amrwb
      --enable-libopenjpeg
      --enable-libopus
      --enable-libplacebo
      --enable-librist
      --enable-librubberband
      --enable-libsoxr
      --enable-libspeex
      --enable-libsrt
      --enable-libsvtav1
      --enable-libtheora
      --enable-libvidstab
      --enable-libvorbis
      --enable-libvpx
      --enable-libwebp
      --enable-libx264
      --enable-libx265
      --enable-libxml2
      --enable-libxvid
      --enable-libzimg
      --enable-lzma
      --enable-openssl
      --enable-lcms2

      --disable-logging
      --disable-htmlpages
      --disable-podpages
      --disable-txtpages
      --disable-manpages
      --disable-ffplay
      --disable-ffprobe
      --disable-doc
      --disable-libxcb
      --disable-libxcb-shm
      --disable-libxcb-xfixes
      --disable-libxcb-shape
      --disable-mbedtls

      --disable-libjack
      --disable-indev=jack
    ]

    # Needs corefoundation, coremedia, corevideo
    args += %w[--enable-videotoolbox --enable-audiotoolbox] if OS.mac?
    args << "--enable-neon" if Hardware::CPU.arm?

    args << "--enable-libcaca" if build.with? "libcaca"
    args << "--enable-libgme" if build.with? "game-music-emu"
    args << "--enable-libgsm" if build.with? "libgsm"
    args << "--enable-libmodplug" if build.with? "libmodplug"
    args << "--enable-libopenh264" if build.with? "openh264"
    args << "--enable-librav1e" if build.with? "rav1e"
    args << "--enable-librsvg" if build.with? "librsvg"
    args << "--enable-libsnappy" if build.with? "snappy"
    args << "--enable-libssh" if build.with? "libssh"
    args << "--enable-libtesseract" if build.with? "tesseract"
    args << "--enable-libtwolame" if build.with? "two-lame"
    args << "--enable-libvmaf" if build.with? "libvmaf"
    args << "--enable-libzmq" if build.with? "zeromq"

    # args << "--enable-hardcoded-tables"
    args << "--enable-lto"
    args << "--optflags=-Ofast"

    opts  = Hardware::CPU.arm? ? "-mcpu=native " : "-march=native -mtune=native "
    args << ("--extra-cflags="    + opts)
    args << ("--extra-cxxflags="  + opts)
    args << ("--extra-objcflags=" + opts)
    args << ("--extra-ldflags="   + opts)

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install Dir["tools/*"].select { |f| File.executable? f }

    # Fix for Non-executables that were installed to bin/
    mv bin/"python", pkgshare/"python", force: true
  end
  test do
  end
end
