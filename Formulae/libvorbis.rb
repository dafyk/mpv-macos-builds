class Libvorbis < Formula
  desc "Vorbis General Audio Compression Codec"
  homepage "https://xiph.org/vorbis/"
  url "https://downloads.xiph.org/releases/vorbis/libvorbis-1.3.7.tar.xz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/vorbis/libvorbis-1.3.7.tar.xz"
  sha256 "b33cc4934322bcbf6efcbacf49e3ca01aadbea4114ec9589d1b1e9d20f72954b"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/vorbis/?C=M&O=D"
    regex(/href=.*?libvorbis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "dafyk/mpv/pkg-config" => :build
  depends_on "dafyk/mpv/libogg"

  def install
    system "./autogen.sh" if build.head?
    inreplace "configure", " -force_cpusubtype_ALL", ""
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
  end
end
