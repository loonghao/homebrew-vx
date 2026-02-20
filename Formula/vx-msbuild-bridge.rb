class VxMsbuildBridge < Formula
  desc "MSBuild.exe bridge that delegates to system VS MSBuild with Spectre auto-detection - used by vx MSVC provider"
  homepage "https://github.com/loonghao/vx"
  version "0.8.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.8.4/vx-msbuild-bridge-aarch64-apple-darwin.tar.gz"
      sha256 "5dc103f9922ffd1ab7b0e568d2649b71060913cf951a249f69507b10560388de"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.8.4/vx-msbuild-bridge-x86_64-apple-darwin.tar.gz"
      sha256 "63bb82f6b0cfcd3dd1b351bd47ffbb8971848ad42c75261200273c0b4b3ca629"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.8.4/vx-msbuild-bridge-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2651a0c154c37e64f3a1b9df5ca6abe9dba55cfe7df0a1a9e0a30b79e97a131d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.8.4/vx-msbuild-bridge-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "68afb2a92010ef7b4615ecc21259f81cbab0c4cf76a47669829c320042d3230e"
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
