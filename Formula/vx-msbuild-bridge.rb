class VxMsbuildBridge < Formula
  desc "MSBuild.exe bridge that delegates to system VS MSBuild with Spectre auto-detection - used by vx MSVC provider"
  homepage "https://github.com/loonghao/vx"
  version "0.8.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.8.2/vx-msbuild-bridge-aarch64-apple-darwin.tar.gz"
      sha256 "51dcf35685d6366069d1069688f96c7feb765661fb3eee769f15ee9ae01c9bf4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.8.2/vx-msbuild-bridge-x86_64-apple-darwin.tar.gz"
      sha256 "749c25d2023a1a3891dfb3a308fb7ddd554e216660f1ba96c56ab85f4994b58f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/loonghao/vx/releases/download/v0.8.2/vx-msbuild-bridge-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b87ce02f37fd2677d003eece8dcfc216c14134c673d686d3c7e46f4bd7b1c549"
    end
    if Hardware::CPU.intel?
      url "https://github.com/loonghao/vx/releases/download/v0.8.2/vx-msbuild-bridge-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "12df9f3b9eddea213a73fefd77a1f2004f40d3493425b6e8cae57f7f7d0f0e87"
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
