class Tag < Formula
  desc "Manipulate and query tags on macOS files"
  homepage "https://github.com/jdberry/tag/"
  url "https://github.com/jdberry/tag/archive/v0.10.tar.gz"
  sha256 "5ab057d3e3f0dbb5c3be3970ffd90f69af4cb6201c18c1cbaa23ef367e5b071e"
  license "MIT"
  head "https://github.com/jdberry/tag.git", branch: "master"

  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"
  end
  test do
  end
end
