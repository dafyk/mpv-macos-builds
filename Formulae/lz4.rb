class Lz4 < Formula
  desc "Extremely Fast Compression algorithm"
  homepage "https://lz4.github.io/lz4/"
  url "https://github.com/lz4/lz4/archive/v1.9.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/lz4-1.9.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/lz4-1.9.4.tar.gz"
  sha256 "0b0e3aa07c8c063ddf40b082bdf7e37a1562bda40a0ff5272957f3e987e0e54b"
  license "BSD-2-Clause"
  head "https://github.com/lz4/lz4.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
  test do
  end
end
