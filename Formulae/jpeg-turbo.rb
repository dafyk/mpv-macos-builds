class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  license "IJG"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git", branch: "main"

  stable do
    url "https://downloads.sourceforge.net/project/libjpeg-turbo/3.0.0/libjpeg-turbo-3.0.0.tar.gz"
    sha256 "c77c65fcce3d33417b2e90432e7a0eb05f59a7fff884022a9d931775d583bfaa"

    # Patch to fix regression test concurrency issue. Remove in next release.
    patch do
      url "https://github.com/libjpeg-turbo/libjpeg-turbo/commit/035ea386d1b6a99a8a1e2ab57cc1fc903569136c.patch?full_index=1"
      sha256 "7389d29c16be16ae23e40f6ac31e78ca366550644ab96810f1e21bece71919bb"
    end
  end

  # Versions with a 90+ patch are unstable (e.g., 2.1.90 corresponds to
  # 3.0 beta1) and this regex should only match the stable versions.
  livecheck do
    url :stable
    regex(%r{url=.*?/libjpeg-turbo[._-]v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)\.t}i)
  end

  depends_on "dafyk/mpv/cmake" => :build
  depends_on "dafyk/mpv/nasm" => :build

  # These conflict with `jpeg`, which is now keg-only.
  link_overwrite "bin/cjpeg", "bin/djpeg", "bin/jpegtran", "bin/rdjpgcom", "bin/wrjpgcom"
  link_overwrite "include/jconfig.h", "include/jerror.h", "include/jmorecfg.h", "include/jpeglib.h"
  link_overwrite "lib/libjpeg.dylib", "lib/libjpeg.so", "lib/libjpeg.a", "lib/pkgconfig/libjpeg.pc"
  link_overwrite "share/man/man1/cjpeg.1", "share/man/man1/djpeg.1", "share/man/man1/jpegtran.1",
                 "share/man/man1/rdjpgcom.1", "share/man/man1/wrjpgcom.1"

  def install
    args = ["-DWITH_JPEG8=1", "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}"]
    # https://github.com/libjpeg-turbo/libjpeg-turbo/issues/709
    args << "-DFLOATTEST12=" if Hardware::CPU.arm? && MacOS.version >= :ventura
    args += std_cmake_args.reject { |arg| arg["CMAKE_INSTALL_LIBDIR"].present? }

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--rerun-failed", "--output-on-failure", "--parallel", ENV.make_jobs
    system "cmake", "--install", "build"
  end
  test do
  end
end
