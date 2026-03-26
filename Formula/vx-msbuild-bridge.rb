class VxMsbuildBridge < Formula
  desc "MSBuild.exe bridge that delegates to system VS MSBuild with Spectre auto-detection - used by vx MSVC provider"
  homepage "https://github.com/loonghao/vx"
  version "0.8.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.8.7/vx-msbuild-bridge-aarch64-apple-darwin.tar.gz"
      sha256 "f2fb6157fb49ee8180ee543eff24f41e73cebd6283a56ada8abae03d9bda5251"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.8.7/vx-msbuild-bridge-x86_64-apple-darwin.tar.gz"
      sha256 "d26c55620badb0b88e807185fd4a2ddf2ee85e518882bc5e510da35af4c75575"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.8.7/vx-msbuild-bridge-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5f97a3be96317edbd95c219543b4650808dae80c6ee219d71324898d3c7dc522"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.8.7/vx-msbuild-bridge-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6110e76b019171f632570bb4fe97cd2b211810fbbd3c60652fc1e86903034f60"
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
