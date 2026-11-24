class Vx < Formula
  desc "Universal Development Tool Manager"
  homepage "https://github.com/vx-org/vx"
  version "0.9.38"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vx-org/vx/releases/download/v0.9.38/vx-aarch64-apple-darwin.tar.gz"
      sha256 "caf3f2f4d32b6534fdb713af86db80be7e354fde39920073b85caf4d02a4fb50"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vx-org/vx/releases/download/v0.9.38/vx-x86_64-apple-darwin.tar.gz"
      sha256 "7dba3d7bc5838f94da0998dcc3962415c14110981a793290dd2b8609d754f7aa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vx-org/vx/releases/download/v0.9.38/vx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c0f048ef984b93c38d0fa7b4c9659767cb9670d202f4f1a4a3f3227dc1a4d9b4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vx-org/vx/releases/download/v0.9.38/vx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ebe1afe2f0d4a64918b1bf1b3273a7c5b32f21797d58daeddba5325692d74e9e"
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
