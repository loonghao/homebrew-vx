class Vx < Formula
  desc "Universal Development Tool Manager"
  homepage "https://github.com/loonghao/vx"
  version "0.9.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.9.9/vx-aarch64-apple-darwin.tar.gz"
      sha256 "16908b28d117e2b5231b5f13b4f9652fb00a7a782f2f61f98c0ec8a74312655c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.9.9/vx-x86_64-apple-darwin.tar.gz"
      sha256 "f51fff1bb33fef0fd27786335dcd6d7c1c8e2d0b44c141ddd2282d7ad75dbad2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.9.9/vx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8e8d94377262bffe5de6a4f72b1ceaa4c54009e1d1fb914506e66a18aa4c455a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.9.9/vx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "53d45e87fd32e7f1daea0b30a1d7df68bd2a161462d01132665c5e0315b0b97e"
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
