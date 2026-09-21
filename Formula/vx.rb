class Vx < Formula
  desc "Universal Development Tool Manager"
  homepage "https://github.com/loonghao/vx"
  version "0.9.33"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.9.33/vx-aarch64-apple-darwin.tar.gz"
      sha256 "176036294dd5e4a1d070c0ab8e059452634695b893f3cd9a496e63692683103b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.9.33/vx-x86_64-apple-darwin.tar.gz"
      sha256 "5693a5a4f6e30b4e89618fbf18a8f4fecff26767c1a7a4a2b434ca86f720c0dc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.9.33/vx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ce446f28f3bba4a425a64b794719f394c1d7f05e99d151f1b019739c84e37d45"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.9.33/vx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3fc13d33f0884e77c24976c94c097061a8ab55f1da8e51c21d624cce984fe80a"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "vx"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "vx"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "vx"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "vx"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
