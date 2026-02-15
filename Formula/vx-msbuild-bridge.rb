class VxMsbuildBridge < Formula
  desc "Minimal MSBuild.exe bridge that delegates to dotnet msbuild - used by vx MSVC provider"
  homepage "https://github.com/loonghao/vx"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.8.0/vx-msbuild-bridge-aarch64-apple-darwin.tar.gz"
      sha256 "2abe3bc1af59e7354d38a48cda7ca70495dcd59b4d44fd6330af21cd4d6698f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.8.0/vx-msbuild-bridge-x86_64-apple-darwin.tar.gz"
      sha256 "c93098805022732825358deb2c5658e3b60cac03801c58b3f5d08a6a7e2fa9c3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.8.0/vx-msbuild-bridge-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d102b22c0be49c94e83484215cbb64f5a10a9c41d189e9c58ed8f010da91c92b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.8.0/vx-msbuild-bridge-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "727dc73adc4c05d736f0c711ac0c6488001b4bab6afdb7c72813e8205d6b7a73"
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
