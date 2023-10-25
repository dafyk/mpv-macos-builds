class OpensslAT3 < Formula
  desc "Cryptography and SSL/TLS Toolkit"
  homepage "https://openssl.org/"
  url "https://www.openssl.org/source/openssl-3.1.3.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-3.1.3.tar.gz"
  mirror "https://www.openssl.org/source/old/3.1/openssl-3.1.3.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/old/3.1/openssl-3.1.3.tar.gz"
  mirror "http://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-3.1.3.tar.gz"
  mirror "http://www.mirrorservice.org/sites/ftp.openssl.org/source/old/3.1/openssl-3.1.3.tar.gz"
  sha256 "f0316a2ebd89e7f2352976445458689f80302093788c466692fb2a188b2eacf6"
  license "Apache-2.0"

  livecheck do
    url "https://www.openssl.org/source/"
    regex(/href=.*?openssl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "dafyk/mpv/ca-certificates"

  link_overwrite "bin/c_rehash", "bin/openssl", "include/openssl/*"
  link_overwrite "lib/libcrypto*", "lib/libssl*"
  link_overwrite "lib/pkgconfig/libcrypto.pc", "lib/pkgconfig/libssl.pc", "lib/pkgconfig/openssl.pc"
  link_overwrite "share/doc/openssl/*", "share/man/man*/*ssl"

  # SSLv2 died with 1.1.0, so no-ssl2 no longer required.
  # SSLv3 & zlib are off by default with 1.1.0 but this may not
  # be obvious to everyone, so explicitly state it for now to
  # help debug inevitable breakage.
  def configure_args
    args = %W[
      --prefix=#{prefix}
      --openssldir=#{openssldir}
      --libdir=#{lib}
      no-ssl3
      no-ssl3-method
      no-zlib
      no-asm
    ]
    on_linux do
      args += (ENV.cflags || "").split
      args += (ENV.cppflags || "").split
      args += (ENV.ldflags || "").split
    end
    args
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", buildpath/"lib/perl5"
      ENV.prepend_path "PATH", buildpath/"bin"

      %w[ExtUtils::MakeMaker Test::Harness Test::More].each do |r|
        resource(r).stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}", "CC=#{ENV.cc}"
          system "make", "install"
        end
      end
    end

    # This could interfere with how we expect OpenSSL to build.
    ENV.delete("OPENSSL_LOCAL_CONFIG_DIR")

    # This ensures where Homebrew's Perl is needed the Cellar path isn't
    # hardcoded into OpenSSL's scripts, causing them to break every Perl update.
    # Whilst our env points to opt_bin, by default OpenSSL resolves the symlink.
    ENV["PERL"] = Formula["perl"].opt_bin/"perl" if which("perl") == Formula["perl"].opt_bin/"perl"

    arch_args = []
    if OS.mac?
      arch_args += %W[darwin64-#{Hardware::CPU.arch}-cc enable-ec_nistp_64_gcc_128]
    elsif Hardware::CPU.intel?
      arch_args << (Hardware::CPU.is_64_bit? ? "linux-x86_64" : "linux-elf")
    elsif Hardware::CPU.arm?
      arch_args << (Hardware::CPU.is_64_bit? ? "linux-aarch64" : "linux-armv4")
    end

    openssldir.mkpath
    system "perl", "./Configure", *(configure_args + arch_args)
    system "make"
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
    system "make", "test"
  end

  def openssldir
    etc/"openssl@3"
  end

  def post_install
    rm_f openssldir/"cert.pem"
    openssldir.install_symlink Formula["dafyk/mpv/ca-certificates"].pkgetc/"cert.pem"
  end

  def caveats
    <<~EOS
      A CA file has been bootstrapped using certificates from the system
      keychain. To add additional certificates, place .pem files in
        #{openssldir}/certs

      and run
        #{opt_bin}/c_rehash
    EOS
  end
  test do
  end
end
