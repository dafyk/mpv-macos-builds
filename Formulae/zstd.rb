class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/v1.5.5.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zstd-1.5.5.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zstd-1.5.5.tar.gz"
  sha256 "98e9c3d949d1b924e28e01eccb7deed865eefebf25c2f21c702e5cd5b63b85e1"
  license "BSD-3-Clause"
  head "https://github.com/facebook/zstd.git", branch: "dev"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "dafyk/mpv/cmake" => :build
  depends_on "dafyk/mpv/lz4"
  depends_on "dafyk/mpv/xz"
  uses_from_macos "zlib"

  def install
    # Legacy support is the default after
    # https://github.com/facebook/zstd/commit/db104f6e839cbef94df4df8268b5fecb58471274
    # Set it to `ON` to be explicit about the configuration.
    system "cmake", "-S", "build/cmake", "-B", "builddir",
                    "-DZSTD_PROGRAMS_LINK_SHARED=ON", # link `zstd` to `libzstd`
                    "-DZSTD_BUILD_CONTRIB=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DZSTD_LEGACY_SUPPORT=ON",
                    "-DZSTD_ZLIB_SUPPORT=ON",
                    "-DZSTD_LZMA_SUPPORT=ON",
                    "-DZSTD_LZ4_SUPPORT=ON",
                    "-DCMAKE_CXX_STANDARD=11",
                    *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"

    # Prevent dependents from relying on fragile Cellar paths.
    # https://github.com/ocaml/ocaml/issues/12431
    inreplace lib/"pkgconfig/libzstd.pc", prefix, opt_prefix
  end
  test do
  end
end
