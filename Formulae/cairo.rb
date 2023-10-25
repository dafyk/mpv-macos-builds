class Cairo < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/cairo-1.18.0.tar.xz"
  sha256 "243a0736b978a33dee29f9cca7521733b78a65b5418206fef7bd1c3d4cf10b64"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]
  head "https://gitlab.freedesktop.org/cairo/cairo.git", branch: "master"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)cairo[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t}i)
  end

  depends_on "dafyk/mpv/meson" => :build
  depends_on "dafyk/mpv/ninja" => :build
  depends_on "dafyk/mpv/pkg-config" => :build
  depends_on "dafyk/mpv/fontconfig"
  depends_on "dafyk/mpv/freetype"
  depends_on "dafyk/mpv/glib"
  depends_on "dafyk/mpv/libpng"
  #depends_on "libx11"
  #depends_on "libxcb"
  #depends_on "libxext"
  #depends_on "libxrender"
  depends_on "dafyk/mpv/lzo"
  depends_on "dafyk/mpv/pixman"

  uses_from_macos "zlib"

  def install
    args = %w[
      -Dfontconfig=enabled
      -Dfreetype=enabled
      -Dpng=enabled
      -Dglib=enabled
      -Dxcb=disabled
      -Dxlib=disabled
      -Dzlib=enabled
      -Dglib=enabled
    ]
    args << "-Dquartz=enabled" if OS.mac?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end
  test do
  end
end
