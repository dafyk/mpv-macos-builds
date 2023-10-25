class Autoconf < Formula
  desc "Automatic configure script builder"
  homepage "https://www.gnu.org/software/autoconf"
  url "https://ftp.gnu.org/gnu/autoconf/autoconf-2.71.tar.gz"
  mirror "https://ftpmirror.gnu.org/autoconf/autoconf-2.71.tar.gz"
  sha256 "431075ad0bf529ef13cb41e9042c542381103e80015686222b8a9d4abef42a1c"
  license all_of: [
    "GPL-3.0-or-later",
    "GPL-3.0-or-later" => { with: "Autoconf-exception-3.0" },
  ]

  depends_on "dafyk/mpv/m4"
  uses_from_macos "perl"

  def install
    if OS.mac?
      ENV["PERL"] = "/usr/bin/perl"

      # force autoreconf to look for and use our glibtoolize
      inreplace "bin/autoreconf.in", "libtoolize", "glibtoolize"
      # also touch the man page so that it isn't rebuilt
      inreplace "man/autoreconf.1", "libtoolize", "glibtoolize"
    end

    system "./configure", "--prefix=#{prefix}", "--with-lispdir=#{elisp}"
    system "make", "install"

    rm_f info/"standards.info"
  end
  test do
  end
end
