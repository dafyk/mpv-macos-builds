class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.17.1/libass-0.17.1.tar.xz"
  sha256 "f0da0bbfba476c16ae3e1cfd862256d30915911f7abaa1b16ce62ee653192784"
  license "ISC"

  depends_on "dafyk/mpv/pkg-config" => :build
  depends_on "dafyk/mpv/nasm" => :build
  depends_on "dafyk/mpv/freetype"
  depends_on "dafyk/mpv/fribidi"
  depends_on "dafyk/mpv/harfbuzz"
  depends_on "dafyk/mpv/libunibreak"
  depends_on "dafyk/mpv/fontconfig" => :optional

  def install
    opts = "-Ofast -flto=thin " + (Hardware::CPU.arm? ? "-mcpu=native " : "-march=native -mtune=native ")
    ENV.append "CFLAGS",      opts
    ENV.append "LDFLAGS",     opts + " -dead_strip"

    system "autoreconf", "-i" if build.head?
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-large-tiles
    ]
    # libass uses coretext on macOS, fontconfig on Linux
    args << "--disable-fontconfig" if OS.mac? && (build.without? "fontconfig")
    system "./configure", *args
    system "make", "install"
  end
  test do
  end
end
