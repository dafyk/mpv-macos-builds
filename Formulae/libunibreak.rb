class Libunibreak < Formula
  desc "Implementation of the Unicode line- and word-breaking algorithms"
  homepage "https://github.com/adah1972/libunibreak"
  url "https://github.com/adah1972/libunibreak/releases/download/libunibreak_5_1/libunibreak-5.1.tar.gz"
  sha256 "dd1a92d4c5646aa0e457ff41d89812ec5243863be6c20bbcb5ee380f3dd78377"
  license "Zlib"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[_-]\d+)+)$/i)
    strategy :git do |tags|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end
  test do
  end
end
