# jinreiyu/tap

Homebrew tap for jinreiyu's tools.

```bash
brew install jinreiyu/tap/call-captions
```

| Formula | What it is |
| --- | --- |
| [call-captions](https://github.com/jinreiyu/call-captions) | Live Japanese-to-English call captions, on-device on Apple Silicon Macs. Always the latest version (now 1.10.1). |
| call-captions-1.10.0 | Milestone 2 (1.10.0), the latest known-good version, kept installable for rollback. |
| call-captions-1.2.0 | Milestone 1 (1.2.0), the first known-good version. |

## Milestones and rollback

A milestone is a version confirmed to work on a real Mac. Each one stays installable as its own
formula, pinned to the exact code on the `milestone/vX.Y.Z` branch of
[call-captions](https://github.com/jinreiyu/call-captions).

```bash
# Stay on the version you have (brew upgrade skips it until you unpin)
brew pin call-captions

# Roll back to milestone 2 (1.10.0) if an update breaks something
brew uninstall call-captions && brew install jinreiyu/tap/call-captions-1.10.0 && call-captions

# Further back, to milestone 1 (1.2.0)
brew uninstall call-captions-1.10.0 && brew install jinreiyu/tap/call-captions-1.2.0 && call-captions

# Go back to the latest version (from whichever milestone you're on)
brew uninstall call-captions-1.10.0 && brew install jinreiyu/tap/call-captions && call-captions
brew uninstall call-captions-1.2.0 && brew install jinreiyu/tap/call-captions && call-captions
```

Your settings (`~/call-captions`) and the "Call Captions Output" sound routing are kept when you
switch. The models are downloaded again (about 5 GB for 1.10.0, 2 to 3 GB for 1.2.0) because
each formula keeps its own copy.
