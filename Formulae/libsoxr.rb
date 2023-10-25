class Libsoxr < Formula
  desc "High quality, one-dimensional sample-rate conversion library"
  homepage "https://sourceforge.net/projects/soxr/"
  url "https://downloads.sourceforge.net/project/soxr/soxr-0.1.3-Source.tar.xz"
  sha256 "b111c15fdc8c029989330ff559184198c161100a59312f5dc19ddeb9b5a15889"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/soxr[._-]v?(\d+(?:\.\d+)+)(?:-Source)?\.t}i)
  end

  depends_on "dafyk/mpv/cmake" => :build

  # Fixes the build on 64-bit ARM macOS; the __arm__ define used in the
  # code isn't defined on 64-bit Apple Silicon.
  # Upstream pull request: https://sourceforge.net/p/soxr/code/merge-requests/5/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/76868b36263be42440501d3692fd3a258f507d82/libsoxr/arm64_defines.patch"
    sha256 "9df5737a21b9ce70cc136c302e195fad9f9f6c14418566ad021f14bb34bb022c"
  end

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "make", "install"
  end
  test do
  end
end
