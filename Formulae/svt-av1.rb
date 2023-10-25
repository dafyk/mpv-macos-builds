class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v1.7.0/SVT-AV1-v1.7.0.tar.bz2"
  sha256 "e7995dfc8774f301ac94367a2e5d266dc855cf62ee3d39a635f3a014708e98e1"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  depends_on "dafyk/mpv/cmake" => :build
  depends_on "dafyk/mpv/yasm" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end
  test do
  end
end
