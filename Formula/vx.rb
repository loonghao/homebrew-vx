class Vx < Formula
  desc "Universal Development Tool Manager"
  homepage "https://github.com/loonghao/vx"
  version "0.9.29"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.9.29/vx-aarch64-apple-darwin.tar.gz"
      sha256 "11687f0bc7188337785c114bf873e0363f8da124123d62f5864ed1a75d26f5ca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.9.29/vx-x86_64-apple-darwin.tar.gz"
      sha256 "1d4487975b2ccde3b5b81b3a367791767e02008b68afe9f4b854bdb481dc0916"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.9.29/vx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d74dc5ab6d4734ef94bf7b13488d0ac0e9eb8e0f79afb31c12761d437fc7fdc6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.9.29/vx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1c587428472d3886ed764f0fef31844ce514489dbf35544c9f2eef3cf547132d"
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
