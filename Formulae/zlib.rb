class Zlib < Formula
  desc "General-purpose lossless data-compression library"
  homepage "https://zlib.net/"
  url "https://zlib.net/zlib-1.3.tar.gz"
  mirror "https://downloads.sourceforge.net/project/libpng/zlib/1.3/zlib-1.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zlib-1.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zlib-1.3.tar.gz"
  sha256 "ff0ba4c292013dbc27530b3a81e1f9a813cd39de01ca5e0f8bf355702efa593e"
  license "Zlib"
  head "https://github.com/madler/zlib.git", branch: "develop"

  livecheck do
    url :homepage
    regex(/href=.*?zlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  keg_only :provided_by_macos

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Avoid rebuilds of dependents that hardcode this path.
    inreplace lib/"pkgconfig/zlib.pc", prefix, opt_prefix
  end
  test do
  end
end
