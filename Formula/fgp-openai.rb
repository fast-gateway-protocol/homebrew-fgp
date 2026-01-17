# typed: false
# frozen_string_literal: true

class FgpOpenai < Formula
  desc "FGP OpenAI daemon - Fast embeddings, completions, and DALL-E"
  homepage "https://github.com/fast-gateway-protocol/openai"
  license "MIT"
  version "0.1.0"

  on_macos do
    on_arm do
      url "https://github.com/fast-gateway-protocol/openai/releases/download/v#{version}/fgp-openai-macos-arm64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/fast-gateway-protocol/openai/releases/download/v#{version}/fgp-openai-macos-x64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/fast-gateway-protocol/openai/releases/download/v#{version}/fgp-openai-linux-x64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  depends_on "fgp"

  def install
    bin.install "fgp-openai"
    (var/"fgp/services/openai").mkpath
  end

  def caveats
    <<~EOS
      OpenAI daemon requires API key setup.

      Set environment variable:
        export OPENAI_API_KEY="sk-..."

      Quick start:
        fgp start openai                         # Start daemon
        fgp call openai embed "Hello world"      # Get embedding
        fgp call openai image "A cute cat"       # Generate image

      Documentation: https://fast-gateway-protocol.github.io/fgp/daemons/openai/
    EOS
  end

  service do
    run [opt_bin/"fgp-openai", "start", "--foreground"]
    keep_alive true
    working_dir var/"fgp/services/openai"
    log_path var/"log/fgp-openai.log"
    error_log_path var/"log/fgp-openai.log"
  end

  test do
    assert_match "fgp-openai", shell_output("#{bin}/fgp-openai --version")
  end
end
