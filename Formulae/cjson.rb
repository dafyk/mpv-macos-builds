class Cjson < Formula
  desc "Ultralightweight JSON parser in ANSI C"
  homepage "https://github.com/DaveGamble/cJSON"
  url "https://github.com/DaveGamble/cJSON/archive/v1.7.16.tar.gz"
  sha256 "451131a92c55efc5457276807fc0c4c2c2707c9ee96ef90c47d68852d5384c6c"
  license "MIT"

  depends_on "dafyk/mpv/cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_CJSON_UTILS=ON",
                    "-DENABLE_CJSON_TEST=Off",
                    "-DBUILD_SHARED_AND_STATIC_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end
  test do
  end
end
