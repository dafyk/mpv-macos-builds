class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-3.3.0.tar.bz2"
  sha256 "d9ef89e2b8ef9f85b13ac3c2faec30e20acf2c9f3a9c8c45ce637f2bc95e576c"
  license "GPL-2.0-or-later"
  head "https://hg.sr.ht/~breakfastquay/rubberband", using: :hg

  livecheck do
    url :homepage
    regex(/href=.*?rubberband[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "dafyk/mpv/meson" => :build
  depends_on "dafyk/mpv/ninja" => :build
  depends_on "dafyk/mpv/pkg-config" => :build
  depends_on "dafyk/mpv/libsamplerate"
  depends_on "dafyk/mpv/libsndfile"

  fails_with gcc: "5"

  def install
    args = ["-Dresampler=libsamplerate"]
    args << "-Dfft=fftw" if OS.linux?
    mkdir "build" do
      system "meson", *std_meson_args, *args
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end
  test do
  end
end
