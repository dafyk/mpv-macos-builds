class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.1.9.tar.gz"
  sha256 "f1d8aacd46afed958babfced3190d2d3c8209b66da451f556abd6da94c165cf3"
  license "BSD-3-Clause"

  depends_on "dafyk/mpv/cmake" => :build

  # These used to be provided by `ilmbase`
  link_overwrite "lib/libImath.dylib"
  link_overwrite "lib/libImath.so"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end
  test do
  end
end
