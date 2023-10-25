class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.3.2.tar.gz"
  sha256 "2a499607df669e40258e53d0ade8035ba4ec0175244869d1025d460562aa09b4"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libwebp.git", branch: "main"

  depends_on "dafyk/mpv/cmake" => :build
  depends_on "dafyk/mpv/giflib"
  depends_on "dafyk/mpv/jpeg-turbo"
  depends_on "dafyk/mpv/libpng"
  depends_on "dafyk/mpv/libtiff"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF", *args
    system "cmake", "--build", "static"
    lib.install buildpath.glob("static/*.a")
  end
  test do
  end
end
