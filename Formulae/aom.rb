class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.6.1",
      revision: "7ade96172b95adc91a5d85bf80c90989cd543ee8"
  license "BSD-2-Clause"

  depends_on "dafyk/mpv/cmake" => :build
  depends_on "dafyk/mpv/yasm" => :build
  depends_on "dafyk/mpv/pkg-config" => :build
  depends_on "dafyk/mpv/jpeg-xl"
  #depends_on "dafyk/mpv/libvmaf" => :optional

  def install
    ENV.runtime_cpu_detection unless Hardware::CPU.arm?

    args = std_cmake_args + [
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DENABLE_DOCS=off",
      "-DENABLE_EXAMPLES=off",
      "-DENABLE_TESTDATA=off",
      "-DENABLE_TESTS=off",
      "-DENABLE_TOOLS=off",
      "-DBUILD_SHARED_LIBS=off",
      "-DCONFIG_TUNE_VMAF=0",
    ]
    # Runtime CPU detection is not currently enabled for ARM on macOS.
    args << "-DCONFIG_RUNTIME_CPU_DETECT=0" if Hardware::CPU.arm?

    system "cmake", "-S", ".", "-B", "brewbuild", *args
    system "cmake", "--build", "brewbuild"
    system "cmake", "--install", "brewbuild"
  end
  test do
  end
end
