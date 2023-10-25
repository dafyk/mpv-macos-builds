class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/v1.11.1.tar.gz"
  sha256 "31747ae633213f1eda3842686f83c2aa1412e0f5691d1c14dbbcc67fe7400cea"
  license "Apache-2.0"
  head "https://github.com/ninja-build/ninja.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  uses_from_macos "python" => :build

  # Fix `source code cannot contain null bytes` for Python 3.11.4+
  # https://github.com/ninja-build/ninja/pull/2311
  patch do
    url "https://github.com/ninja-build/ninja/commit/67834978a6abdfb790dac165b8b1f1c93648e624.patch?full_index=1"
    sha256 "078c7d08278aebff346b0e7490d98f3d147db88ebfa6abf34be615b5f12bdf42"
  end

  def install
    system "python3", "configure.py", "--bootstrap", "--verbose", "--with-python=python3"

    bin.install "ninja"
    bash_completion.install "misc/bash-completion" => "ninja-completion.sh"
    zsh_completion.install "misc/zsh-completion" => "_ninja"
    doc.install "doc/manual.asciidoc"
    elisp.install "misc/ninja-mode.el"
    (share/"vim/vimfiles/syntax").install "misc/ninja.vim"
  end
  test do
  end
end
