class FdkAac < Formula
  desc "Standalone library of the Fraunhofer FDK AAC code from Android"
  homepage "https://sourceforge.net/projects/opencore-amr/"
  url "https://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-2.0.2.tar.gz"
  sha256 "c9e8630cf9d433f3cead74906a1520d2223f89bcd3fa9254861017440b8eb22f"
  license "Apache-2.0"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-example"
    system "make", "install"
  end
  test do
  end
end
