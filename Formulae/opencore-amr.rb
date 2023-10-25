class OpencoreAmr < Formula
  desc "Audio codecs extracted from Android open source project"
  homepage "https://opencore-amr.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.6.tar.gz"
  sha256 "483eb4061088e2b34b358e47540b5d495a96cd468e361050fae615b1809dc4a1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/opencore-amr[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--enable-static", "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
  end
end
