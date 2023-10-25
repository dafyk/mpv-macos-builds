class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/videolan/libbluray/1.3.4/libbluray-1.3.4.tar.bz2"
  sha256 "478ffd68a0f5dde8ef6ca989b7f035b5a0a22c599142e5cd3ff7b03bbebe5f2b"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libbluray/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  depends_on "dafyk/mpv/pkg-config" => :build
  depends_on "dafyk/mpv/fontconfig"
  depends_on "dafyk/mpv/freetype"

  uses_from_macos "libxml2"

  def install
    args = %W[--prefix=#{prefix} --disable-dependency-tracking --disable-silent-rules --disable-bdjava-jar]

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end
  test do
  end
end
