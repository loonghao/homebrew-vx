class VxStarMetadata < Formula
  desc "Zero-dependency static metadata parser for provider.star files"
  homepage "https://github.com/loonghao/vx"
  version "0.8.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.8.9/vx-star-metadata-aarch64-apple-darwin.tar.gz"
      sha256 "95addc025b56f7bc6b5e8d4775a1e493ca543f9b2285a55e2fb1e26cb642d1bc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.8.9/vx-star-metadata-x86_64-apple-darwin.tar.gz"
      sha256 "2046cd927b9b6f8b085066d55533f78fc5df3ab5fc49262f6f781ba1d40276d0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.8.9/vx-star-metadata-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "caec98b77604f2f97a196e0e27579221606f57d1efda75678e68b0859c5604ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.8.9/vx-star-metadata-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bb14a4440dfb65fce943d5980ee8cd547b705f45c49769dc3cac8b9d55bc01b1"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "vx-star-discover-providers" if OS.mac? && Hardware::CPU.arm?
    bin.install "vx-star-discover-providers" if OS.mac? && Hardware::CPU.intel?
    bin.install "vx-star-discover-providers" if OS.linux? && Hardware::CPU.arm?
    bin.install "vx-star-discover-providers" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
