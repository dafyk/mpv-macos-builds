class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org/"
  url "https://downloads.xiph.org/releases/opus/opus-1.4.tar.gz", using: :homebrew_curl
  sha256 "c9b32b4253be5ae63d1ff16eea06b94b5f0f2951b7a02aceef58e3a3ce49c51f"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.xiph.org/releases/opus/"
    regex(%r{href=(?:["']?|.*?/)opus[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-doc", "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
  end
end
