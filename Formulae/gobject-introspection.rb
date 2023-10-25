class GobjectIntrospection < Formula
  include Language::Python::Shebang

  desc "Generate introspection data for GObject libraries"
  homepage "https://gi.readthedocs.io/en/latest/"
  url "https://download.gnome.org/sources/gobject-introspection/1.78/gobject-introspection-1.78.1.tar.xz"
  sha256 "bd7babd99af7258e76819e45ba4a6bc399608fe762d83fde3cac033c50841bb4"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]

  depends_on "dafyk/mpv/bison" => :build
  depends_on "dafyk/mpv/cmake" => :build
  depends_on "dafyk/mpv/meson" => :build
  depends_on "dafyk/mpv/ninja" => :build
  depends_on "dafyk/mpv/cairo"
  depends_on "dafyk/mpv/glib"
  depends_on "dafyk/mpv/pkg-config"
  # Ships a `_giscanner.cpython-311-darwin.so`, so needs a specific version.
  depends_on "dafyk/mpv/python@3.11"
  depends_on "dafyk/mpv/libffi"

  uses_from_macos "flex" => :build
  #uses_from_macos "libffi", since: :catalina

  # Fix library search path on non-/usr/local installs (e.g. Apple Silicon)
  # See: https://github.com/Homebrew/homebrew-core/issues/75020
  #      https://gitlab.gnome.org/GNOME/gobject-introspection/-/merge_requests/273
  patch do
    url "https://gitlab.gnome.org/tschoonj/gobject-introspection/-/commit/a7be304478b25271166cd92d110f251a8742d16b.diff"
    sha256 "740c9fba499b1491689b0b1216f9e693e5cb35c9a8565df4314341122ce12f81"
  end

  def python3
    which("python3.11")
  end

  def install
    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"

    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "meson.build",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', join_paths(get_option('prefix'), get_option('libdir')))",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', '#{HOMEBREW_PREFIX}/lib')"

    system "meson", "setup", "build", "-Dpython=#{python3}",
                                      "-Dextra_library_paths=#{HOMEBREW_PREFIX}/lib",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    #rewrite_shebang detected_python_shebang, *bin.children
  end
  test do
  end
end
