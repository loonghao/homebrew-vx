class Vx < Formula
  desc "Universal Development Tool Manager"
  homepage "https://github.com/loonghao/vx"
  version "0.9.16"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.9.16/vx-aarch64-apple-darwin.tar.gz"
      sha256 "a4960286767532859a28b46e1874a28ba5a908feb1d3a855dc3cddf6ac9c72f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.9.16/vx-x86_64-apple-darwin.tar.gz"
      sha256 "f297c99e56fe234031b28fa262c1815323907fb3014a9032c397acadb20c6430"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.9.16/vx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f243036e5eebe963927570897e80d407f135dd600f460ef64c8631cfe7a0d93c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.9.16/vx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "81f41d1134d8077b23b7a020b7ed8f49ba19807633b0cfcb443c0eefcd932779"
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
    bin.install "vx" if OS.mac? && Hardware::CPU.arm?
    bin.install "vx" if OS.mac? && Hardware::CPU.intel?
    bin.install "vx" if OS.linux? && Hardware::CPU.arm?
    bin.install "vx" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
