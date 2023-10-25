class Mpdecimal < Formula
  desc "Library for decimal floating point arithmetic"
  homepage "https://www.bytereef.org/mpdecimal/"
  url "https://www.bytereef.org/software/mpdecimal/releases/mpdecimal-2.5.1.tar.gz"
  sha256 "9f9cd4c041f99b5c49ffb7b59d9f12d95b683d88585608aa56a6307667b2b21f"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.bytereef.org/mpdecimal/download.html"
    regex(/href=.*?mpdecimal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
  test do
  end
end
