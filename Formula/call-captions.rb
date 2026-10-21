class CallCaptions < Formula
  desc "Live Japanese-to-English call captions, on-device on Apple Silicon"
  homepage "https://github.com/jinreiyu/call-captions"
  url "https://github.com/jinreiyu/call-captions/archive/a0e97d8c2b2f30828fd7e671f79f7c055905c425.tar.gz"
  version "1.0.0"
  sha256 "ccbc375ec3a08f7138a0a7345f17b5f899dd640416fd6ba80d52ca609a9bf414"

  depends_on arch: :arm64
  depends_on :macos
  depends_on "uv"

  def install
    libexec.install "bin", "app", "live_captions.py", "requirements.txt"
    bin.write_exec_script libexec/"bin/call-captions"
  end

  def caveats
    <<~EOS
      Finish setup once. It installs Python and about 2 GB of models into
      ~/call-captions and adds "Call Captions" to your Applications folder:
        call-captions setup

      Call audio is read from a BlackHole loopback driver. If you don't have one:
        brew install --cask blackhole-2ch
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/call-captions version")
  end
end
