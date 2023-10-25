class Libogg < Formula
  desc "Ogg Bitstream Library"
  homepage "https://www.xiph.org/ogg/"
  url "https://ftp.osuosl.org/pub/xiph/releases/ogg/libogg-1.3.5.tar.gz"
  sha256 "0eb4b4b9420a0f51db142ba3f9c64b333f826532dc0f48c6410ae51f4799b664"
  license "BSD-3-Clause"
  head "https://gitlab.xiph.org/xiph/ogg.git", branch: "master"

  depends_on "dafyk/mpv/cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-static/libogg.a"
  end
  test do
  end
end
