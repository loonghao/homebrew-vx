class Vx < Formula
  desc "Universal Development Tool Manager"
  homepage "https://github.com/loonghao/vx"
  version "0.9.30"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.9.30/vx-aarch64-apple-darwin.tar.gz"
      sha256 "32d78da2e713b50258b33abd7c14da8039aa1d26624ba27dbb6c18e0ed010191"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.9.30/vx-x86_64-apple-darwin.tar.gz"
      sha256 "fa08b31861a920c1772d786e08a5ebdeaa8080205a56684d6577a67cb08f1bef"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.9.30/vx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6f8fa8057664490149991dbfd276f34254985fa217cacfb92b1095f76f419d14"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.9.30/vx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a5d14819c901b9b1f58e52a71c4a866a4754e7a773c7394f00f1b6c06f44461d"
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
