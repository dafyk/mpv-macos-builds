class VulkanLoader < Formula
  desc "Vulkan ICD Loader"
  homepage "https://github.com/KhronosGroup/Vulkan-Loader"
  url "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.3.268.tar.gz"
  sha256 "bddabbf8ebbbd38bdb58dfb50fbd94dbd84b8c39c34045e13c9ad46bd3cae167"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-Loader.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "dafyk/mpv/cmake" => :build
  depends_on "dafyk/mpv/pkg-config" => :build
  depends_on "dafyk/mpv/python@3.11" => :build
  depends_on "dafyk/mpv/vulkan-headers"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_STATIC_LOADER=ON",
                    "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["dafyk/mpv/vulkan-headers"].opt_prefix}",
                    "-DFALLBACK_DATA_DIRS=#{HOMEBREW_PREFIX}/share:/usr/local/share:/usr/share",
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DFALLBACK_CONFIG_DIRS=#{etc}/xdg:/etc/xdg",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end
  test do
  end
end
