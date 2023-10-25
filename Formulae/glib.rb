class Glib < Formula
  include Language::Python::Shebang

  desc "Core application library for C"
  homepage "https://developer.gnome.org/glib/"
  url "https://download.gnome.org/sources/glib/2.78/glib-2.78.0.tar.xz"
  sha256 "44eaab8b720877ce303c5540b657b126f12dc94972d9880b52959f43fb537b30"
  license "LGPL-2.1-or-later"

  depends_on "dafyk/mpv/gettext" => :build
  depends_on "dafyk/mpv/meson" => :build
  depends_on "dafyk/mpv/ninja" => :build
  depends_on "dafyk/mpv/pkg-config" => :build
  depends_on "dafyk/mpv/pcre2"
  depends_on "dafyk/mpv/libffi"
  depends_on "dafyk/mpv/python@3.11"

  #uses_from_macos "libffi", since: :catalina
  #uses_from_macos "python", since: :catalina

  # These used to live in the now defunct `glib-utils`.
  link_overwrite "bin/gdbus-codegen", "bin/glib-genmarshal", "bin/glib-mkenums", "bin/gtester-report"
  link_overwrite "share/glib-2.0/codegen", "share/glib-2.0/gdb"

  # replace several hardcoded paths with homebrew counterparts
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/43467fd8dfc0e8954892ecc08fab131242dca025/glib/hardcoded-paths.diff"
    sha256 "d81c9e8296ec5b53b4ead6917f174b06026eeb0c671dfffc4965b2271fb6a82c"
  end

  def install
    inreplace %w[gio/xdgmime/xdgmime.c glib/gutils.c], "@@HOMEBREW_PREFIX@@", HOMEBREW_PREFIX
    # Avoid the sandbox violation when an empty directory is created outside of the formula prefix.
    inreplace "gio/meson.build", "install_emptydir(glib_giomodulesdir)", ""

    # Disable dtrace; see https://trac.macports.org/ticket/30413
    # and https://gitlab.gnome.org/GNOME/glib/-/issues/653
    args = %W[
      --default-library=both
      --localstatedir=#{var}
      -Dgio_module_dir=#{HOMEBREW_PREFIX}/lib/gio/modules
      -Dbsymbolic_functions=false
      -Ddtrace=false
      -Druntime_dir=#{var}/run
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # ensure giomoduledir contains prefix, as this pkgconfig variable will be
    # used by glib-networking and glib-openssl to determine where to install
    # their modules
    inreplace lib/"pkgconfig/gio-2.0.pc",
              "giomoduledir=#{HOMEBREW_PREFIX}/lib/gio/modules",
              "giomoduledir=${libdir}/gio/modules"

    if OS.mac?
      # `pkg-config --libs glib-2.0` includes -lintl, and gettext itself does not
      # have a pkgconfig file, so we add gettext lib and include paths here.
      gettext = Formula["dafyk/mpv/gettext"].opt_prefix
      inreplace lib/"pkgconfig/glib-2.0.pc" do |s|
        s.gsub! "Libs: -L${libdir} -lglib-2.0 -lintl",
                "Libs: -L${libdir} -lglib-2.0 -L#{gettext}/lib -lintl"
        s.gsub! "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include",
                "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include -I#{gettext}/include"
      end
    end

    if MacOS.version < :catalina
      # `pkg-config --print-requires-private gobject-2.0` includes libffi,
      # but that package is keg-only so it needs to look for the pkgconfig file
      # in libffi's opt path.
      libffi = Formula["dafyk/mpv/libffi"].opt_prefix
      inreplace lib/"pkgconfig/gobject-2.0.pc" do |s|
        s.gsub! "Requires.private: libffi",
                "Requires.private: #{libffi}/lib/pkgconfig/libffi.pc"
      end
    end

    rm "gio/completion/.gitignore"
    bash_completion.install (buildpath/"gio/completion").children
    rewrite_shebang detected_python_shebang(use_python_from_path: true), *bin.children
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/gio/modules").mkpath
  end
  test do
  end
end
