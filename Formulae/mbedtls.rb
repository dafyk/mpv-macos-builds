class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/archive/mbedtls-3.5.0.tar.gz"
  sha256 "02311fc8bd032d89ff9aee535dddb55458108dc0d4c5280638fc611aea7c5e4a"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    regex(/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  depends_on "dafyk/mpv/cmake" => :build
  depends_on "dafyk/mpv/python@3.11" => :build

  def install
    inreplace "include/mbedtls/mbedtls_config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
      # enable DTLS-SRTP extension
      s.gsub! "//#define MBEDTLS_SSL_DTLS_SRTP", "#define MBEDTLS_SSL_DTLS_SRTP"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_SHARED_MBEDTLS_LIBRARY=On",
                    "-DPython3_EXECUTABLE=#{which("python3.12")}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DGEN_FILES=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    # We run CTest because this is a crypto library. Running tests in parallel causes failures.
    # https://github.com/Mbed-TLS/mbedtls/issues/4980
    with_env(CC: DevelopmentTools.locate(DevelopmentTools.default_compiler)) do
      system "ctest", "--parallel", "1", "--test-dir", "build", "--rerun-failed", "--output-on-failure"
    end
    system "cmake", "--install", "build"

    # Why does Mbedtls ship with a "Hello World" executable. Let's remove that.
    rm_f bin/"hello"
    # Rename benchmark & selftest, which are awfully generic names.
    mv bin/"benchmark", bin/"mbedtls-benchmark"
    mv bin/"selftest", bin/"mbedtls-selftest"
    # Demonstration files shouldn't be in the main bin
    libexec.install bin/"mpi_demo"
  end
  test do
  end
end
