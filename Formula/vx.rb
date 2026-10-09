class Vx < Formula
  desc "Universal Development Tool Manager"
  homepage "https://github.com/loonghao/vx"
  version "0.9.36"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.9.36/vx-aarch64-apple-darwin.tar.gz"
      sha256 "4ea75dfe572b5fc573ae2fb0fb13957f2d6c7ddfa673af772f064d1488ac6ea3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.9.36/vx-x86_64-apple-darwin.tar.gz"
      sha256 "5be168580bdffd9b8982fef4a695ec66c93415fa601c2ba7c02182142dfc948b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.9.36/vx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bf595b0b4cb88195071ff3309f9a8ac2a691d701513d4cd76a9d9f83652df4bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.9.36/vx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4399c3acb64fea8bb4adee147e17b7f127e74a8dc29a5fbb4c24567a823f243f"
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
