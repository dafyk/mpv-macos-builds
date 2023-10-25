class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.40/libpng-1.6.40.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.40/libpng-1.6.40.tar.xz"
  sha256 "535b479b2467ff231a3ec6d92a525906fb8ef27978be4f66dbe05d3f3a01b3a1"
  license "libpng-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "test"
    system "make", "install"

    # Avoid rebuilds of dependants that hardcode this path.
    inreplace lib/"pkgconfig/libpng.pc", prefix, opt_prefix
  end
  test do
  end
end
