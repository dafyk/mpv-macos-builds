class Uchardet < Formula
  desc "Encoding detector library"
  homepage "https://www.freedesktop.org/wiki/Software/uchardet/"
  url "https://www.freedesktop.org/software/uchardet/releases/uchardet-0.0.8.tar.xz"
  sha256 "e97a60cfc00a1c147a674b097bb1422abd9fa78a2d9ce3f3fdcc2e78a34ac5f0"
  head "https://gitlab.freedesktop.org/uchardet/uchardet.git", branch: "master"

  depends_on "dafyk/mpv/cmake" => :build

  def install
    args = std_cmake_args
    args << "-DCMAKE_INSTALL_NAME_DIR=#{lib}"
    system "cmake", ".", *args
    system "make", "install"
  end
  test do
  end
end
