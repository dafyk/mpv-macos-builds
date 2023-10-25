class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  url "https://github.com/libjxl/libjxl/archive/v0.8.2.tar.gz"
  sha256 "c70916fb3ed43784eb840f82f05d390053a558e2da106e40863919238fa7b420"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  # depends_on "asciidoc" => :build
  depends_on "dafyk/mpv/cmake" => :build
  # depends_on "docbook-xsl" => :build
  depends_on "dafyk/mpv/pkg-config" => :build
  # depends_on "sphinx-doc" => :build
  depends_on "dafyk/mpv/brotli"
  depends_on "dafyk/mpv/giflib"
  depends_on "dafyk/mpv/highway"
  depends_on "dafyk/mpv/imath"
  depends_on "dafyk/mpv/jpeg-turbo"
  depends_on "dafyk/mpv/libpng"
  depends_on "dafyk/mpv/little-cms2"
  depends_on "dafyk/mpv/openexr"
  depends_on "dafyk/mpv/webp"

  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build # for xsltproc

  fails_with gcc: "5"
  fails_with gcc: "6"

  # These resources are versioned according to the script supplied with jpeg-xl to download the dependencies:
  # https://github.com/libjxl/libjxl/tree/v#{version}/third_party
  resource "sjpeg" do
    url "https://github.com/webmproject/sjpeg.git",
        revision: "868ab558fad70fcbe8863ba4e85179eeb81cc840"
  end

  def install
    ENV.append_path "XML_CATALOG_FILES", HOMEBREW_PREFIX/"etc/xml/catalog"
    resources.each { |r| r.stage buildpath/"third_party"/r.name }
    system "cmake", "-S", ".", "-B", "build",
                    "-DJPEGXL_FORCE_SYSTEM_BROTLI=ON",
                    "-DJPEGXL_FORCE_SYSTEM_LCMS2=ON",
                    "-DJPEGXL_FORCE_SYSTEM_HWY=ON",
                    "-DJPEGXL_STATIC=ON",
                    "-DJPEGXL_ENABLE_JNI=OFF",
                    "-DJPEGXL_ENABLE_SKCMS=OFF",
                    "-DJPEGXL_ENABLE_DOXYGEN=OFF",
                    "-DJPEGXL_ENABLE_BENCHMARK=OFF",
                    "-DJPEGXL_ENABLE_EXAMPLES=OFF",
                    "-DJPEGXL_VERSION=#{version}",
                    "-DJPEGXL_ENABLE_MANPAGES=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    # "-DPython3_EXECUTABLE=#{Formula["asciidoc"].libexec/"bin/python3"}",
                    "-DCMAKE_CXX_FLAGS=-DFJXL_ENABLE_AVX512=0",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "install"
  end
  test do
  end
end
