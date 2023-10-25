class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/8.2.1.tar.gz"
  sha256 "f4f4e4173578fd91ca9ef107ca74640a2b7b9420fd11cebe764a86438561134a"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  depends_on "dafyk/mpv/gobject-introspection" => :build
  depends_on "dafyk/mpv/meson" => :build
  depends_on "dafyk/mpv/ninja" => :build
  depends_on "dafyk/mpv/pkg-config" => :build
  depends_on "dafyk/mpv/python@3.11" => :build
  depends_on "dafyk/mpv/cairo"
  depends_on "dafyk/mpv/freetype"
  depends_on "dafyk/mpv/glib"
  depends_on "dafyk/mpv/graphite2"
  depends_on "dafyk/mpv/icu4c"

  resource "homebrew-test-ttf" do
    url "https://github.com/harfbuzz/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
    sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
  end

  def install
    args = %w[
      --default-library=both
      -Dcairo=enabled
      -Dcoretext=enabled
      -Dfreetype=enabled
      -Dglib=enabled
      -Dgobject=enabled
      -Dgraphite=enabled
      -Dicu=enabled
      -Dintrospection=enabled
      -Dtests=disabled
    ]

    system "meson", "setup", "build", *std_meson_args, *args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end
  test do
  end
end
