class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.32.3.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.32.3/mpg123-1.32.3.tar.bz2"
  sha256 "2d9913a57d4ee8f497a182c6e82582602409782a4fb481e989feebf4435867b4"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  def install
    args = %w[
      --with-module-suffix=.so
      --enable-static
    ]

    args << "--with-default-audio=coreaudio" if OS.mac?

    args << if Hardware::CPU.arm?
      "--with-cpu=aarch64"
    else
      "--with-cpu=x86-64"
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end
  test do
  end
end
