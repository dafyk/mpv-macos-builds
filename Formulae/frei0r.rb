class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "dd6dbe49ba743421d8ced07781ca09c2ac62522beec16abf1750ef6fe859ddc9"
  license "GPL-2.0-or-later"

  depends_on "dafyk/mpv/cmake" => :build

  def install
    # Disable opportunistic linking against Cairo
    inreplace "CMakeLists.txt", "find_package (Cairo)", ""

    args = %w[
      -DWITHOUT_OPENCV=ON
      -DWITHOUT_GAVL=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end
  test do
  end
end
