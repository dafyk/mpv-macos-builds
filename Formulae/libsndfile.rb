class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "https://libsndfile.github.io/libsndfile/"
  url "https://github.com/libsndfile/libsndfile/releases/download/1.2.2/libsndfile-1.2.2.tar.xz"
  sha256 "3799ca9924d3125038880367bf1468e53a1b7e3686a934f098b7e1d286cdb80e"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "dafyk/mpv/cmake" => :build
  depends_on "dafyk/mpv/python@3.11" => :build
  depends_on "dafyk/mpv/flac"
  depends_on "dafyk/mpv/lame"
  depends_on "dafyk/mpv/libogg"
  depends_on "dafyk/mpv/libvorbis"
  depends_on "dafyk/mpv/mpg123"
  depends_on "dafyk/mpv/opus"

  #uses_from_macos "python" => :build, since: :catalina

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_PROGRAMS=ON",
                    "-DENABLE_PACKAGE_CONFIG=ON",
                    "-DINSTALL_PKGCONFIG_MODULE=ON",
                    "-DBUILD_EXAMPLES=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DPYTHON_EXECUTABLE=#{which("python3")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end
  test do
  end
end
