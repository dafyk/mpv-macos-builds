class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/v1.5.3.tar.gz"
  sha256 "befaeb16f628c46387b898df02bc6fba84868e86a6f6d8294755375b9932d777"
  license "MPL-2.0"
  head "https://github.com/Haivision/srt.git", branch: "master"

  depends_on "dafyk/mpv/cmake" => :build
  depends_on "dafyk/mpv/pkg-config" => :build
  depends_on "dafyk/mpv/openssl@3"

  def install
    openssl = Formula["dafyk/mpv/openssl@3"]
    system "cmake", ".", "-DWITH_OPENSSL_INCLUDEDIR=#{openssl.opt_include}",
                         "-DWITH_OPENSSL_LIBDIR=#{openssl.opt_lib}",
                         "-DCMAKE_INSTALL_BINDIR=bin",
                         "-DCMAKE_INSTALL_LIBDIR=lib",
                         "-DCMAKE_INSTALL_INCLUDEDIR=include",
                         *std_cmake_args
    system "make", "install"
  end
  test do
  end
end
