class Speex < Formula
  desc "Audio codec designed for speech"
  homepage "https://speex.org/"
  url "https://downloads.xiph.org/releases/speex/speex-1.2.1.tar.gz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/speex/speex-1.2.1.tar.gz"
  sha256 "4b44d4f2b38a370a2d98a78329fefc56a0cf93d1c1be70029217baae6628feea"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/speex/?C=M&O=D"
    regex(/href=.*?speex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "dafyk/mpv/pkg-config" => :build
  depends_on "dafyk/mpv/libogg"

  def install
    ENV.deparallelize
    system "./configure", *std_configure_args
    system "make", "install"
  end
  test do
  end
end
