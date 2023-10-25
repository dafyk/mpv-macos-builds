class Libb2 < Formula
  desc "Secure hashing function"
  homepage "https://blake2.net/"
  url "https://github.com/BLAKE2/libb2/releases/download/v0.98.1/libb2-0.98.1.tar.gz"
  sha256 "53626fddce753c454a3fea581cbbc7fe9bbcf0bc70416d48fdbbf5d87ef6c72e"
  license "CC0-1.0"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # SSE detection is broken on arm64 macos
    # https://github.com/BLAKE2/libb2/issues/36
    extra_args = []
    extra_args << "--enable-fat" unless Hardware::CPU.arm?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          *extra_args
    system "make", "install"
  end
  test do
  end
end
