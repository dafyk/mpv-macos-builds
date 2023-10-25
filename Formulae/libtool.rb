class Libtool < Formula
  desc "Generic library support script"
  homepage "https://www.gnu.org/software/libtool/"
  url "https://ftp.gnu.org/gnu/libtool/libtool-2.4.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/libtool/libtool-2.4.7.tar.xz"
  sha256 "4f7f217f057ce655ff22559ad221a0fd8ef84ad1fc5fcb6990cecc333aa1635d"
  license "GPL-2.0-or-later"

  depends_on "dafyk/mpv/m4"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ltdl-install
    ]

    args << "--program-prefix=g" if OS.mac?

    system "./configure", *args
    system "make", "install"

    if OS.mac?
      %w[libtool libtoolize].each do |prog|
        (libexec/"gnubin").install_symlink bin/"g#{prog}" => prog
        (libexec/"gnuman/man1").install_symlink man1/"g#{prog}.1" => "#{prog}.1"
      end
      libexec.install_symlink "gnuman" => "man"
    end

    if OS.linux?
      bin.install_symlink "libtool" => "glibtool"
      bin.install_symlink "libtoolize" => "glibtoolize"

      # Avoid references to the Homebrew shims directory
      inreplace bin/"libtool", Superenv.shims_path, "/usr/bin"
    end
  end

  def caveats
    on_macos do
      <<~EOS
        All commands have been installed with the prefix "g".
        If you need to use these commands with their normal names, you
        can add a "gnubin" directory to your PATH from your bashrc like:
          PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end
  test do
  end
end
