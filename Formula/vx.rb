class Vx < Formula
  desc "Universal Development Tool Manager"
  homepage "https://github.com/loonghao/vx"
  version "0.8.31"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.8.31/vx-aarch64-apple-darwin.tar.gz"
      sha256 "4a009f55c794678a19582a9a317d82582df22865d4144e09bbd945dc8ed726c8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.8.31/vx-x86_64-apple-darwin.tar.gz"
      sha256 "c2e45bc75b6f8707cf7524f108bde33eb651f5dae643d7084720a2d3982e3946"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.8.31/vx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a1d546c0882962645da96fc4de2db69b11447684946c52c122508744e7149347"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.8.31/vx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1bfec2da61936927cbd8f11b691a062d21719ad8c8cff2baa22d4e5de918cf9f"
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
