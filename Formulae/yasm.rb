class Yasm < Formula
  desc "Modular BSD reimplementation of NASM"
  homepage "https://yasm.tortall.net/"
  url "https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz"
  mirror "https://ftp.openbsd.org/pub/OpenBSD/distfiles/yasm-1.3.0.tar.gz"
  sha256 "3dce6601b495f5b3d45b59f7d2492a340ee7e84b5beca17e48f862502bd5603f"

  livecheck do
    url "https://yasm.tortall.net/Download.html"
    regex(/href=.*?yasm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --disable-python
    ]

    # https://github.com/Homebrew/legacy-homebrew/pull/19593
    ENV.deparallelize

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end
  test do
  end
end
