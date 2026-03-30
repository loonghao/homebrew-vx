class VxMsbuildBridge < Formula
  desc "MSBuild.exe bridge that delegates to system VS MSBuild with Spectre auto-detection - used by vx MSVC provider"
  homepage "https://github.com/loonghao/vx"
  version "0.8.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/archive/refs/tags/v0.8.15.tar.gz"
      sha256 "79631b0843a0efed78dde5f331883127711188f07ecf6348679f5ecb7b17b6a9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.8.9/vx-msbuild-bridge-x86_64-apple-darwin.tar.gz"
      sha256 "2955ee925f9392daced919f1d322b2e7e8f7a674994c1a75afcb08d895855dcc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.8.9/vx-msbuild-bridge-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "056282810fa23767f17ae128e19f324f44b72e39a78bbf9449475fe6464cc8ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.8.9/vx-msbuild-bridge-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cffe111de0f4503287998ffa0fc8e2dabd25b9a806ed645d35c64922d45f17a3"
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
