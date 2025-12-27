class Vx < Formula
  desc "Universal Development Tool Manager - Manage Node.js, Python, Go, Rust and more"
  homepage "https://github.com/loonghao/vx"
  license "MIT"
  version "0.5.21"

  on_macos do
    on_arm do
      url "https://github.com/loonghao/vx/releases/download/vx-v#{version}/vx-aarch64-apple-darwin.tar.gz"
      sha256 "PLACEHOLDER_SHA256_MACOS_ARM64"
    end
    on_intel do
      url "https://github.com/loonghao/vx/releases/download/vx-v#{version}/vx-x86_64-apple-darwin.tar.gz"
      sha256 "PLACEHOLDER_SHA256_MACOS_X64"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/loonghao/vx/releases/download/vx-v#{version}/vx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "PLACEHOLDER_SHA256_LINUX_ARM64"
    end
    on_intel do
      url "https://github.com/loonghao/vx/releases/download/vx-v#{version}/vx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "PLACEHOLDER_SHA256_LINUX_X64"
    end
  end

  def install
    bin.install "vx"
  end

  test do
    assert_match "vx #{version}", shell_output("#{bin}/vx --version")
  end
end
