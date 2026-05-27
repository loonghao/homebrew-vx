class Vx < Formula
  desc "Universal Development Tool Manager"
  homepage "https://github.com/loonghao/vx"
  version "0.9.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.9.8/vx-aarch64-apple-darwin.tar.gz"
      sha256 "6ece29c07313f3bee0d0581b2d21c31080bcbf394169e307cc35756056145f2a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.9.8/vx-x86_64-apple-darwin.tar.gz"
      sha256 "f4ff6c9a2408654a429cccf0686452c2ae736a37382eca73886fd19313dfa986"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.9.8/vx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2aa08f8e5dd93900f67c87163625dfffc8b7c5b36b2373e5320b94d04791d825"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.9.8/vx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b2bf8be9367d72316941772d2de58d49b9bbda2d6c91f5c74fe4851905852ed1"
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
