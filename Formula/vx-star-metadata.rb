class VxStarMetadata < Formula
  desc "Zero-dependency static metadata parser for provider.star files"
  homepage "https://github.com/loonghao/vx"
  version "0.8.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.8.8/vx-star-metadata-aarch64-apple-darwin.tar.gz"
      sha256 "3c9e91adba32787f1a71dde8bcfa63340652deb2b0b249044b16dafa7c3884a8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.8.8/vx-star-metadata-x86_64-apple-darwin.tar.gz"
      sha256 "c64b4dc6f0c11b08f6a72f1d1030b6fcf20fa04cf01496a9f74963aff7cb828d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.8.8/vx-star-metadata-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "897a585712a7a728db7d044651f316caf25163415e9ab4d13b327085e91b770f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.8.8/vx-star-metadata-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "20fed6ca4fcac322d6dd29ba0d7fb9d6904fc97bf632fe6c2c3d582eae3c7df3"
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
