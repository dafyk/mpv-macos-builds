# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/legacy-homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  # The archive.org mirror below needs to be manually created at `archive.org`.
  url "https://downloads.sourceforge.net/project/lzmautils/xz-5.4.4.tar.gz"
  mirror "https://tukaani.org/xz/xz-5.4.4.tar.gz"
  mirror "https://archive.org/download/xz-5.4.4/xz-5.4.4.tar.gz"
  mirror "http://archive.org/download/xz-5.4.4/xz-5.4.4.tar.gz"
  sha256 "aae39544e254cfd27e942d35a048d592959bd7a79f9a624afb0498bb5613bdf8"
  license all_of: [
    :public_domain,
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
  ]

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end
  test do
  end
end
