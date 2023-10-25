class Libbs2b < Formula
  desc "Bauer stereophonic-to-binaural DSP"
  homepage "https://bs2b.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/bs2b/libbs2b/3.1.0/libbs2b-3.1.0.tar.gz"
  sha256 "6aaafd81aae3898ee40148dd1349aab348db9bfae9767d0e66e0b07ddd4b2528"
  license "MIT"

  depends_on "dafyk/mpv/autoconf" => :build
  depends_on "dafyk/mpv/automake" => :build
  depends_on "dafyk/mpv/libtool" => :build
  depends_on "dafyk/mpv/pkg-config" => :build
  depends_on "dafyk/mpv/libsndfile"

  def install
    if OS.mac?
      # fix 'error: support for lzma-compressed distribution archives has been removed'
      inreplace "configure.ac", "dist-lzma", ""
      system "autoreconf", "--force", "--verbose", "--install"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--enable-static",
                          "--enable-shared"
    system "make", "install"
  end
  test do
  end
end
