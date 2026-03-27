class Vx < Formula
  desc "Universal Development Tool Manager"
  homepage "https://github.com/loonghao/vx"
  version "0.8.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.8.9/vx-aarch64-apple-darwin.tar.gz"
      sha256 "fd03ae399af38002862b5f682447b99c0f664f218f02a607ddd4aca1a9a6595d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.8.9/vx-x86_64-apple-darwin.tar.gz"
      sha256 "019d107e2c324ab137ede0b4e0c65350e21b8a8226572aa323b27a42f32c372d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.8.9/vx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d84969092d72b582b9bedc6af85baccad5604cc47b5d895c63cdb3abc174c907"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.8.9/vx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "23a45262bf856234b6e6f0052bf19ecc51c478deb44ec02d9acaeae1c80d05be"
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
