class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/releases/download/v1.0.13/fribidi-1.0.13.tar.xz"
  sha256 "7fa16c80c81bd622f7b198d31356da139cc318a63fc7761217af4130903f54a2"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
  end
  test do
  end
end
