class VxMsbuildBridge < Formula
  desc "MSBuild.exe bridge that delegates to system VS MSBuild with Spectre auto-detection - used by vx MSVC provider"
  homepage "https://github.com/loonghao/vx"
  version "0.8.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.8.8/vx-msbuild-bridge-aarch64-apple-darwin.tar.gz"
      sha256 "d9d1135efcac54cfbd862109d43a6f73e250b5cd5d9e01e21a3a0ac060fe9719"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.8.8/vx-msbuild-bridge-x86_64-apple-darwin.tar.gz"
      sha256 "67b6b217451bfb1b6298ecd70a4bda0f25effc7af26c5c2f8840ee68b53cfb59"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.8.8/vx-msbuild-bridge-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d30db7f46cba932f01f47c21ca81522fa9eafd363ec5fe596a7621951efc3115"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.8.8/vx-msbuild-bridge-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e1c3ddea2a3263b2ad1b50b9c8359e89c6075d55fac0d9f5d6188ea5ee070e84"
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
    bin.install "MSBuild" if OS.mac? && Hardware::CPU.arm?
    bin.install "MSBuild" if OS.mac? && Hardware::CPU.intel?
    bin.install "MSBuild" if OS.linux? && Hardware::CPU.arm?
    bin.install "MSBuild" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
