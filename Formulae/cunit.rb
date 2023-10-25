class Cunit < Formula
  desc "Lightweight unit testing framework for C"
  homepage "https://cunit.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cunit/CUnit/2.1-3/CUnit-2.1-3.tar.bz2"
  sha256 "f5b29137f845bb08b77ec60584fdb728b4e58f1023e6f249a464efa49a40f214"

  depends_on "dafyk/mpv/autoconf" => :build
  depends_on "dafyk/mpv/automake" => :build
  depends_on "dafyk/mpv/libtool" => :build

  def install
    inreplace "bootstrap", "libtoolize", "glibtoolize"
    system "sh", "bootstrap", prefix
    system "make", "install"
  end
  test do
  end
end
