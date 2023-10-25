class Libmysofa < Formula
  desc "Library for reading AES SOFA files"
  homepage "https://github.com/hoene/libmysofa"
  url "https://github.com/hoene/libmysofa/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "a8a8cbf7b0b2508a6932278799b9bf5c63d833d9e7d651aea4622f3bc6b992aa"
  license "BSD-3-Clause"
  head "https://github.com/hoene/libmysofa.git", branch: "master"

  depends_on "dafyk/mpv/cmake" => :build
  depends_on "dafyk/mpv/cunit"

  def install
    opts = "-Ofast -flto=thin " + (Hardware::CPU.arm? ? "-mcpu=native " : "-march=native -mtune=native ")
    ENV.append "CFLAGS",      opts
    ENV.append "LDFLAGS",     opts + " -dead_strip"

    cd "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_BUILD_TYPE=Release"
      system "make", "all"
      system "make", "install"
    end
  end
  test do
  end
end
