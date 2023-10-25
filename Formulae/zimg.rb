class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-3.0.5.tar.gz"
  sha256 "a9a0226bf85e0d83c41a8ebe4e3e690e1348682f6a2a7838f1b8cbff1b799bcf"
  license "WTFPL"
  head "https://github.com/sekrit-twc/zimg.git", branch: "master"

  depends_on "dafyk/mpv/autoconf" => :build
  depends_on "dafyk/mpv/automake" => :build
  depends_on "dafyk/mpv/libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
  end
end
