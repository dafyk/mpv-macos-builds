class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https://sourceware.org/libffi/"
  url "https://github.com/libffi/libffi/releases/download/v3.4.4/libffi-3.4.4.tar.gz"
  sha256 "d66c56ad259a82cf2a9dfc408b32bf5da52371500b84745f7fb8b645712df676"
  license "MIT"

  keg_only :provided_by_macos

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end
  test do
  end
end
