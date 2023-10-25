class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.36.0/aria2-1.36.0.tar.xz"
  sha256 "58d1e7608c12404f0229a3d9a4953d0d00c18040504498b483305bcb3de907a5"
  license "GPL-2.0-or-later"

  depends_on "dafyk/mpv/pkg-config" => :build
  depends_on "dafyk/mpv/gettext"
  depends_on "dafyk/mpv/libssh2"
  depends_on "dafyk/mpv/openssl@3"
  depends_on "dafyk/mpv/sqlite"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    ENV.cxx11

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-libssh2
      --without-gnutls
      --without-libgmp
      --without-libnettle
      --without-libgcrypt
    ]
    if OS.mac?
      args << "--with-appletls"
      args << "--without-openssl"
    else
      args << "--without-appletls"
      args << "--with-openssl"
    end

    system "./configure", *args
    system "make", "install"
  end
  test do
  end
end
