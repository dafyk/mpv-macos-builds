class Aribb24 < Formula
  desc "Library for ARIB STD-B24, decoding JIS 8 bit characters and parsing MPEG-TS"
  homepage "https://code.videolan.org/jeeb/aribb24"
  url "https://code.videolan.org/jeeb/aribb24/-/archive/v1.0.4/aribb24-v1.0.4.tar.bz2"
  sha256 "88b58dd760609372701087e25557ada9f7c6d973306c017067c5dcaf9e2c9710"
  license "LGPL-3.0-only"

  depends_on "dafyk/mpv/autoconf" => :build
  depends_on "dafyk/mpv/automake" => :build
  depends_on "dafyk/mpv/libtool" => :build
  depends_on "dafyk/mpv/pkg-config" => :build
  depends_on "dafyk/mpv/libpng"

  def install
    system "./bootstrap"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end
  test do
  end
end
