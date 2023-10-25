class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "https://libtiff.gitlab.io/libtiff/"
  url "https://download.osgeo.org/libtiff/tiff-4.6.0.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.6.0.tar.gz"
  sha256 "88b3979e6d5c7e32b50d7ec72fb15af724f6ab2cbf7e10880c360a77e4b5d99a"
  license "libtiff"

  livecheck do
    url "https://download.osgeo.org/libtiff/"
    regex(/href=.*?tiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "dafyk/mpv/jpeg-turbo"
  depends_on "dafyk/mpv/xz"
  depends_on "dafyk/mpv/zstd"
  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-webp
      --enable-zstd
      --enable-lzma
      --with-jpeg-include-dir=#{Formula["dafyk/mpv/jpeg-turbo"].opt_include}
      --with-jpeg-lib-dir=#{Formula["dafyk/mpv/jpeg-turbo"].opt_lib}
      --without-x
    ]
    system "./configure", *args
    system "make", "install"
  end
  test do
  end
end
