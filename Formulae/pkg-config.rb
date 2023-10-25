class PkgConfig < Formula
  desc "Manage compile and link flags for libraries"
  homepage "https://freedesktop.org/wiki/Software/pkg-config/"
  url "https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/pkg-config-0.29.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/pkg-config-0.29.2.tar.gz"
  sha256 "6fc69c01688c9458a57eb9a1664c9aba372ccda420a02bf4429fe610e7e7d591"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pkg-config.freedesktop.org/releases/"
    regex(/href=.*?pkg-config[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  def install
    pc_path = %W[
      #{HOMEBREW_PREFIX}/lib/pkgconfig
      #{HOMEBREW_PREFIX}/share/pkgconfig
    ]
    pc_path << if OS.mac?
      pc_path << "/usr/local/lib/pkgconfig"
      pc_path << "/usr/lib/pkgconfig"
      "#{HOMEBREW_LIBRARY}/Homebrew/os/mac/pkgconfig/#{MacOS.version}"
    else
      "#{HOMEBREW_LIBRARY}/Homebrew/os/linux/pkgconfig"
    end

    pc_path = pc_path.uniq.join(File::PATH_SEPARATOR)

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-host-tool",
                          "--with-internal-glib",
                          "--with-pc-path=#{pc_path}",
                          "--with-system-include-path=#{MacOS.sdk_path_if_needed}/usr/include"
    system "make"
    system "make", "install"
  end
  test do
  end
end
