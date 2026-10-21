class CallCaptions < Formula
  desc "Live Japanese-to-English call captions, on-device on Apple Silicon"
  homepage "https://github.com/jinreiyu/call-captions"
  url "https://github.com/jinreiyu/call-captions/archive/56c623846c6323f1d5be1c4a61858e1673af610e.tar.gz"
  version "1.6.2"
  sha256 "eb3456e635e4305fd41aa5601b2006d9dd22b2da7a5d35841dec54c3e36b7f62"

  depends_on arch: :arm64
  depends_on :macos
  depends_on "llama.cpp" # runs the word lookup's small models on the CPU
  depends_on "uv"

  def install
    # Small helper that creates the "Call Captions Output" sound routing and switches to it.
    system ENV.cc, "-O2", "-Wall", "-o", "bin/call-captions-audio", "src/audio.c",
           "-framework", "CoreAudio", "-framework", "CoreFoundation"
    libexec.install "bin", "app", "live_captions.py", "lookup.py", "requirements.txt"
    bin.write_exec_script libexec/"bin/call-captions"
  end

  # Python, its packages and the models go into this formula's own folder, so
  # `brew uninstall call-captions` removes them too. Upgrades reuse the models.
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
    found = Dir["/Library/Audio/Plug-Ins/HAL/BlackHole*.driver"].map { |d| File.basename(d, ".driver") }
    audio = if found.empty?
      "No BlackHole audio driver found; the first run offers to install BlackHole 2ch."
    else
      "Call audio will come through your existing #{found.join(" / ")}. Nothing else to install."
    end
    <<~EOS
      Start it with:
        call-captions
      The first run adds "Call Captions" to your Applications folder and sets up the
      sound routing ("Call Captions Output": your headset + BlackHole) for you.

      #{audio}

      Remove everything (app, settings, Python, models):
        call-captions uninstall
      BlackHole is never removed.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/call-captions version")
  end
end
