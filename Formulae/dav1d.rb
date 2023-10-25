class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/1.2.1/dav1d-1.2.1.tar.bz2"
  sha256 "a4003623cdc0109dec3aac8435520aa3fb12c4d69454fa227f2658cdb6dab5fa"
  license "BSD-2-Clause"

  depends_on "dafyk/mpv/meson" => :build
  depends_on "dafyk/mpv/ninja" => :build
  depends_on "dafyk/mpv/nasm" => :build

  def install
    system "meson", *std_meson_args, "--default-library=both", "build"
    system "ninja", "install", "-C", "build"
  end
  test do
  end
end
