class Automake < Formula
  desc "Tool for generating GNU Standards-compliant Makefiles"
  homepage "https://www.gnu.org/software/automake/"
  url "https://ftp.gnu.org/gnu/automake/automake-1.16.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/automake/automake-1.16.5.tar.xz"
  sha256 "f01d58cd6d9d77fbdca9eb4bbd5ead1988228fdb73d6f7a201f5f8d6b118b469"
  license "GPL-2.0-or-later"

  depends_on "dafyk/mpv/autoconf"

  def install
    ENV["PERL"] = "/usr/bin/perl" if OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Our aclocal must go first. See:
    # https://github.com/Homebrew/homebrew/issues/10618
    (share/"aclocal/dirlist").write <<~EOS
      #{HOMEBREW_PREFIX}/share/aclocal
      /usr/share/aclocal
    EOS
  end
  test do
  end
end
