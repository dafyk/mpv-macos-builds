class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  url "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.14.2.tar.xz"
  sha256 "dba695b57bce15023d2ceedef82062c2b925e51f5d4cc4aef736cf13f60a468b"
  license "MIT"

  livecheck do
    url :stable
    regex(/href=.*?fontconfig[._-]v?(\d+\.\d+\.(?:\d|[0-8]\d+))\.t/i)
  end

  depends_on "dafyk/mpv/pkg-config" => :build
  depends_on "dafyk/mpv/python@3.11" => :build
  depends_on "dafyk/mpv/freetype"

  uses_from_macos "gperf" => :build
  #uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "bzip2"
  uses_from_macos "expat"

  def install
    font_dirs = %w[
      /System/Library/Fonts
      /Library/Fonts
      ~/Library/Fonts
    ]

    font_dirs << Dir["/System/Library/Assets{,V2}/com_apple_MobileAsset_Font*"].max if MacOS.version >= :sierra

    system "autoreconf", "-iv" if build.head?
    ENV["UUID_CFLAGS"] = "-I#{Formula["util-linux"].include}" if OS.linux?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-docs",
                          "--enable-static",
                          "--with-add-fonts=#{font_dirs.join(",")}",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}"
    system "make", "install", "RUN_FC_CACHE_TEST=false"
  end
  test do
  end
end
