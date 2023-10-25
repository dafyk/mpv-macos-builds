class Lame < Formula
  desc "High quality MPEG Audio Layer III (MP3) encoder"
  homepage "https://lame.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz"
  sha256 "ddfe36cab873794038ae2c1210557ad34857a4b6bdc515785d1da9e175b1da1e"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/lame[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  uses_from_macos "ncurses"

  def install
    # Fix undefined symbol error _lame_init_old
    # https://sourceforge.net/p/lame/mailman/message/36081038/
    inreplace "include/libmp3lame.sym", "lame_init_old\n", ""

    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--enable-nasm"
    system "make", "install"
  end
  test do
  end
end
