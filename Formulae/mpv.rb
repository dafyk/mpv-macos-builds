class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "29abc44f8ebee013bb2f9fe14d80b30db19b534c679056e4851ceadf5a5e8bf6"
  license :cannot_represent

  depends_on "dafyk/mpv/docutils" => :build
  depends_on "dafyk/mpv/meson" => :build
  depends_on "dafyk/mpv/pkg-config" => [:build, :test]
  depends_on "dafyk/mpv/python@3.11" => :build
  depends_on xcode: :build

  depends_on "dafyk/mpv/ffmpeg"
  depends_on "dafyk/mpv/libass"
  depends_on "dafyk/mpv/libplacebo"
  depends_on "dafyk/mpv/yt-dlp"
  depends_on "dafyk/mpv/jpeg-turbo"
  depends_on "dafyk/mpv/libarchive"
  depends_on "dafyk/mpv/libdvdnav"
  depends_on "dafyk/mpv/little-cms2"
  depends_on "dafyk/mpv/luajit"
  depends_on "dafyk/mpv/mujs"
  depends_on "dafyk/mpv/uchardet"
  depends_on "dafyk/mpv/zimg"
  depends_on "dafyk/mpv/libiconv"
  depends_on "dafyk/mpv/zlib"
  depends_on "dafyk/mpv/libdvdcss"
  depends_on "dafyk/mpv/libdvdread"
  depends_on "dafyk/mpv/libdvdnav"

  depends_on "dafyk/mpv/libbluray" => :optional
  depends_on "dafyk/mpv/rubberband" => :optional
  depends_on "dafyk/mpv/sdl2" => :optional
  depends_on "dafyk/mpv/vapoursynth" => :optional

  on_macos do
    depends_on "dafyk/mpv/coreutils" => :recommended
    depends_on "dafyk/mpv/tag" => :recommended
    depends_on "dafyk/mpv/trash" => :recommended
  end

  patch do
    url "https://raw.githubusercontent.com/dafyk/mpv-macos-builds/main/swift_compat.patch"
    sha256 "3c4d1ce9dcfef9ce0656b49b5f40606fcf2fc890e60599817090cb2f7da98d41"
  end

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"]   = "en_US.UTF-8"

    # force meson find ninja from homebrew
    ENV["NINJA"] = Formula["dafyk/mpv/ninja"].opt_bin/"ninja"

    # libarchive is keg-only
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["dafyk/mpv/libarchive"].opt_lib/"pkgconfig"

    ENV["LDFLAGS"] = "-lstdc++"

    args = %W[
      -Db_lto=true
      -Db_lto_mode=thin

      -Dhtml-build=disabled
      -Dmanpage-build=disabled
      -Dpdf-build=disabled
      -Dx11=disabled
      -Dmacos-10-14-features=disabled
      -Dmacos-touchbar=disabled
      -Dtests=false
      -Dcplayer=true
      -Dlibmpv=true
      -Dcocoa=enabled
      -Dgl-cocoa=enabled
      -Dmacos-cocoa-cb=enabled
      -Dplain-gl=enabled
      -Dmacos-media-player=enabled
      -Dcoreaudio=enabled
      -Dcplugins=enabled
      -Ddvdnav=enabled
      -Dgl=enabled
      -Djavascript=enabled
      -Dlcms2=enabled
      -Dlibplacebo=enabled
      -Dlua=luajit
      -Duchardet=enabled
      -Dvideotoolbox-gl=enabled
      -Dvulkan=enabled
      -Dzimg=enabled
      -Dzlib=enabled
      -Dlibarchive=enabled
      -Dshaderc=enabled
      --default-library=static
      --prefer-static

      --sysconfdir=#{pkgetc}
      --datadir=#{pkgshare}
      --mandir=#{man}
    ]

    args << "-Dsdl2=enabled" if build.with? "sdl2"

    args << ("-Dc_args=" + (Hardware::CPU.arm? ? "-mcpu=native" : "-march=native -mtune=native") + " -Ofast")
    args << "-Dswift-flags=-O -wmo -target x86_64-apple-macosx10.13"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    if OS.mac?
      # `pkg-config --libs mpv` includes libarchive, but that package is
      # keg-only so it needs to look for the pkgconfig file in libarchive's opt
      # path.
      libarchive = Formula["dafyk/mpv/libarchive"].opt_prefix
      inreplace lib/"pkgconfig/mpv.pc" do |s|
        s.gsub!(/^Requires\.private:(.*)\blibarchive\b(.*?)(,.*)?$/,
                "Requires.private:\\1#{libarchive}/lib/pkgconfig/libarchive.pc\\3")
      end
    end

    # Build, Fix, and Codesign App Bundle
    system "python3.11", "TOOLS/osxbundle.py", "build/mpv", "--skip-deps"
    bindir = "build/mpv.app/Contents/MacOS/"
    rm   bindir + "mpv-bundle"
    mv   bindir + "mpv", bindir + "mpv-bundle"
    ln_s "mpv-bundle", bindir + "mpv"
    system "codesign", "--deep", "-fs", "-", "build/mpv.app"
    prefix.install "build/mpv.app"
  end
  test do
  end
end
