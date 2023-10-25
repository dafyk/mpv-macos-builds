class Libdvdcss < Formula
  desc "Access DVDs as block devices without the decryption"
  homepage "https://www.videolan.org/developers/libdvdcss.html"
  url "https://download.videolan.org/pub/videolan/libdvdcss/1.4.3/libdvdcss-1.4.3.tar.bz2"
  sha256 "233cc92f5dc01c5d3a96f5b3582be7d5cee5a35a52d3a08158745d3d86070079"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.videolan.org/pub/libdvdcss/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  def install
    system "autoreconf", "-if" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
  test do
  end
end
