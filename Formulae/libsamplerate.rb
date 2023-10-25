class Libsamplerate < Formula
  desc "Library for sample rate conversion of audio data"
  homepage "https://github.com/libsndfile/libsamplerate"
  url "https://github.com/libsndfile/libsamplerate/archive/0.2.2.tar.gz"
  sha256 "16e881487f184250deb4fcb60432d7556ab12cb58caea71ef23960aec6c0405a"
  license "BSD-2-Clause"

  depends_on "dafyk/mpv/cmake" => :build
  depends_on "dafyk/mpv/pkg-config" => :build

  def install
    system "cmake", "-S", ".", "-B", "build/shared",
      *std_cmake_args,
      "-DBUILD_SHARED_LIBS=ON",
      "-DLIBSAMPLERATE_EXAMPLES=OFF",
      "-DBUILD_TESTING=OFF"
    system "cmake", "--build", "build/shared"
    system "cmake", "--build", "build/shared", "--target", "install"

    system "cmake", "-S", ".", "-B", "build/static",
      *std_cmake_args,
      "-DBUILD_SHARED_LIBS=OFF",
      "-DLIBSAMPLERATE_EXAMPLES=OFF",
      "-DBUILD_TESTING=OFF"
    system "cmake", "--build", "build/static"
    system "cmake", "--build", "build/static", "--target", "install"
  end
  test do
  end
end
