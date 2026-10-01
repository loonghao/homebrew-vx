class Vx < Formula
  desc "Universal Development Tool Manager"
  homepage "https://github.com/loonghao/vx"
  version "0.9.34"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.9.34/vx-aarch64-apple-darwin.tar.gz"
      sha256 "784c08256c99133981bf02f8fa62b471596b4a7b93d1b3c0adbdcc26433d2d60"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.9.34/vx-x86_64-apple-darwin.tar.gz"
      sha256 "1016c530292ee7e1a0f3875863689ef81796fd1ec142895e6c8f0168798e4e97"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.9.34/vx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ea43c1458a07632a0783840a2093bc6f0e6e0c264a2e695e88e8b1feabb83f8b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.9.34/vx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fd952d351ee4d90bc46f9ed242d1af50b1dfb994b39b3ecdb90441c3ef9302ec"
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
