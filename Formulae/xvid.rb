class Xvid < Formula
  desc "High-performance, high-quality MPEG-4 video library"
  homepage "https://labs.xvid.com/"
  url "https://downloads.xvid.com/downloads/xvidcore-1.3.7.tar.bz2"
  sha256 "aeeaae952d4db395249839a3bd03841d6844843f5a4f84c271ff88f7aa1acff7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://downloads.xvid.com/downloads/"
    regex(/href=.*?xvidcore[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  def install
    cd "build/generic" do
      system "./configure", "--disable-assembly", "--enable-static", "--prefix=#{prefix}"
      ENV.deparallelize # Work around error: install: mkdir =build: File exists
      system "make"
      system "make", "install"
    end
  end
  test do
  end
end
