class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/3f/aa/1a5c72615e0ba4dc30cc36de7e8a9a2eca2158922b0677654fced0d3476c/Cython-3.0.4.tar.gz"
  sha256 "2e379b491ee985d31e5faaf050f79f4a8f59f482835906efe4477b33b4fbe9ff"
  license "Apache-2.0"

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "dafyk/mpv/python@3.11"

  def python3
    "python3.11"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)
    system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."

    bin.install (libexec/"bin").children
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end
  test do
  end
end
