# jinreiyu/tap

Homebrew tap for jinreiyu's tools.

```bash
brew install jinreiyu/tap/call-captions
```

| Formula | What it is |
| --- | --- |
| [call-captions](https://github.com/jinreiyu/call-captions) | Live Japanese-to-English call captions, on-device on Apple Silicon Macs. Always the latest version (now 1.6.2). |
| call-captions-1.2.0 | Milestone 1.2.0, a known-good version kept installable for rollback. |

## Milestones and rollback

A milestone is a version confirmed to work on a real Mac. Each one stays installable as its own
formula, pinned to the exact code on the `milestone/vX.Y.Z` branch of
[call-captions](https://github.com/jinreiyu/call-captions).

```bash
# Stay on the version you have (brew upgrade skips it until you unpin)
brew pin call-captions

# Roll back to milestone 1.2.0 if an update breaks something
brew uninstall call-captions && brew install jinreiyu/tap/call-captions-1.2.0 && call-captions

# Go back to the latest version
brew uninstall call-captions-1.2.0 && brew install jinreiyu/tap/call-captions && call-captions
```

Your settings (`~/call-captions`) and the "Call Captions Output" sound routing are kept when you
switch. The models are downloaded again (2 to 3 GB) because each formula keeps its own copy.
