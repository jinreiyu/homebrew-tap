# Milestone 1.10.0 (milestone 2): a known-good version kept installable for rollback.
# It builds exactly the code on the call-captions `milestone/v1.10.0` branch.
#   Roll back:      brew uninstall call-captions && brew install jinreiyu/tap/call-captions-1.10.0
#   Back to latest: brew uninstall call-captions-1.10.0 && brew install jinreiyu/tap/call-captions
class CallCaptions1100 < Formula
  desc "Live Japanese-to-English call captions (milestone 1.10.0)"
  homepage "https://github.com/jinreiyu/call-captions"
  url "https://github.com/jinreiyu/call-captions/archive/f7e3b54a40d195edf96565e2d69f414cce05bd28.tar.gz"
  version "1.10.0"
  sha256 "066cb5413492dfbed549ee771f0929c6b8ff1138bf7afaf47766a3fa72be9459"

  depends_on arch: :arm64
  depends_on :macos
  depends_on "llama.cpp" # runs the word lookup's small models on the CPU
  depends_on "uv"

  def install
    # The 1.10.0 code names its formula `call-captions`; this copy is `call-captions-1.10.0`.
    # (Not `@1.10.0`: Homebrew would then also load `call-captions`, which it refuses once that
    # is uninstalled, because uninstalling drops its tap trust.)
    inreplace "bin/call-captions" do |s|
      s.gsub! "brew uninstall call-captions", "brew uninstall call-captions-1.10.0"
      s.gsub! "brew postinstall jinreiyu/tap/call-captions", "brew postinstall jinreiyu/tap/call-captions-1.10.0"
    end
    # Small helper that creates the "Call Captions Output" sound routing and switches to it.
    system ENV.cc, "-O2", "-Wall", "-o", "bin/call-captions-audio", "src/audio.c",
           "-framework", "CoreAudio", "-framework", "CoreFoundation"
    libexec.install "bin", "app", "live_captions.py", "lookup.py", "requirements.txt"
    bin.write_exec_script libexec/"bin/call-captions"
  end

  # Python, its packages and the models go into this formula's own folder, so
  # `brew uninstall` removes them too.
  if respond_to?(:post_install_steps)
    post_install_steps do
      run "bin/call-captions", args: ["install-env"], base: :libexec, print_stdout: true,
          env: { "HOMEBREW_PREFIX" => "{{HOMEBREW_PREFIX}}" }
    end
  else
    def post_install
      system libexec/"bin/call-captions", "install-env"
    end
  end

  def caveats
    <<~EOS
      This is milestone 1.10.0 (milestone 2), kept for rollback. Start it with:
        call-captions
      Your settings, options.txt and the "Call Captions Output" sound routing are reused.

      Back to the latest version:
        brew uninstall call-captions-1.10.0 && brew install jinreiyu/tap/call-captions
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/call-captions version")
  end
end
