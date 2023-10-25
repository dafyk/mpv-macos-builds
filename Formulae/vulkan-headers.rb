class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.268.tar.gz"
  sha256 "d5c59d5fc3ab264006dfea1eb1a11f609ea5dfa8319a5aaca061007828012a78"
  license "Apache-2.0"

  depends_on "dafyk/mpv/cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end
  test do
  end
end
