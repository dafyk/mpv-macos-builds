class Highway < Formula
  desc "Performance-portable, length-agnostic SIMD with runtime dispatch"
  homepage "https://github.com/google/highway"
  url "https://github.com/google/highway/archive/refs/tags/1.0.7.tar.gz"
  sha256 "5434488108186c170a5e2fca5e3c9b6ef59a1caa4d520b008a9b8be6b8abe6c5"
  license "Apache-2.0"
  head "https://github.com/google/highway.git", branch: "master"

  depends_on "dafyk/mpv/cmake" => :build

  # These used to be bundled with `jpeg-xl`.
  link_overwrite "include/hwy/*", "lib/pkgconfig/libhwy*"

  def install
    ENV.runtime_cpu_detection
    system "cmake", "-S", ".", "-B", "builddir",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DHWY_ENABLE_TESTS=OFF",
                    "-DHWY_ENABLE_EXAMPLES=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
    (share/"hwy").install "hwy/examples"
  end
  test do
  end
end
