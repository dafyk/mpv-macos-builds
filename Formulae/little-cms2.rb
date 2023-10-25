class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "https://www.littlecms.com/"
  # Ensure release is announced at https://www.littlecms.com/categories/releases/
  # (or https://www.littlecms.com/blog/)
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.15/lcms2-2.15.tar.gz"
  sha256 "b20cbcbd0f503433be2a4e81462106fa61050a35074dc24a4e356792d971ab39"
  license "MIT"
  version_scheme 1

  # The Little CMS website has been redesigned and there's no longer a
  # "Download" page we can check for releases. As of writing this, checking the
  # "Releases" blog posts seems to be our best option and we just have to hope
  # that the post URLs, headings, etc. maintain a consistent format.
  livecheck do
    url "https://www.littlecms.com/categories/releases/"
    regex(/Little\s*CMS\s+v?(\d+(?:\.\d+)+)\s+released/im)
  end

  depends_on "dafyk/mpv/jpeg-turbo"
  depends_on "dafyk/mpv/libtiff"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end
  test do
  end
end
