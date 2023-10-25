class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "https://graphite.sil.org/"
  url "https://github.com/silnrsi/graphite/releases/download/1.3.14/graphite2-1.3.14.tgz"
  sha256 "f99d1c13aa5fa296898a181dff9b82fb25f6cc0933dbaa7a475d8109bd54209d"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "MPL-1.1+"]
  head "https://github.com/silnrsi/graphite.git", branch: "master"

  depends_on "dafyk/mpv/cmake" => :build

  patch do
    url "https://www.savero.net/CMakeLists.txt.patch"
    sha256 "cd8980cba3aeca5145a12e973622d95f362d0ab1c4b896c8786c825c2c9fd6c3"
  end

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "make", "install"
  end
  test do
  end
end
