class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "https://code.videolan.org/videolan/x264.git",
      revision: "31e19f92f00c7003fa115047ce50978bc98c3a0d"
  version "r3108"
  license "GPL-2.0-only"
  head "https://code.videolan.org/videolan/x264.git", branch: "master"

  # Cross-check the abbreviated commit hashes from the release filenames with
  # the latest commits in the `stable` Git branch:
  # https://code.videolan.org/videolan/x264/-/commits/stable
  livecheck do
    url "https://artifacts.videolan.org/x264/release-macos-arm64/"
    regex(%r{href=.*?x264[._-](r\d+)[._-]([\da-z]+)/?["' >]}i)
    strategy :page_match do |page, regex|
      # Match the version and abbreviated commit hash in filenames
      matches = page.scan(regex)

      # Fetch the `stable` Git branch Atom feed
      stable_page_data = Homebrew::Livecheck::Strategy.page_content("https://code.videolan.org/videolan/x264/-/commits/stable?format=atom")
      next if stable_page_data[:content].blank?

      # Extract commit hashes from the feed content
      commit_hashes = stable_page_data[:content].scan(%r{/commit/([\da-z]+)}i).flatten
      next if commit_hashes.blank?

      # Only keep versions with a matching commit hash in the `stable` branch
      matches.map do |match|
        release_hash = match[1]
        commit_in_stable = commit_hashes.any? do |commit_hash|
          commit_hash.start_with?(release_hash)
        end

        match[0] if commit_in_stable
      end
    end
  end

  depends_on "dafyk/mpv/nasm" => :build

  # https://code.videolan.org/videolan/x264/-/commit/b5bc5d69c580429ff716bafcd43655e855c31b02
  fails_with :clang do
    build 902
    cause "Stack realignment requires newer Clang"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-lsmash
      --disable-swscale
      --disable-ffms
      --enable-shared
      --enable-static
      --enable-strip
    ]

    system "./configure", *args
    system "make", "install"
  end
  test do
  end
end
