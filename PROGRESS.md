# Checkpoint 03

## Completed

- Reviewed and preserved original Arduino sketches outside Git. Existing Flutter Web, Android and iOS project files were retained.
- Added separate local USB setup, browser-local demo persistence, the default-locked Arduino bench firmware and a serial fallback.
- Verified Flutter analysis and 18 tests, web release, Android ARM64 APK, and Arduino compilation for both profile variants.
- Exercised desktop and phone-width previews, demo tabs, hardware route reload and persistence. Prepared and checked the static Vercel output.
- Verified the earlier GitHub firmware checkpoint push on `checkpoint/03-web-usb` at `37f8f8174cf03474d1bbaae0695d952fede61a68`. The verified production bundle is recorded by the release commit on `main`.

## Pending and known issues

- Vercel CLI returned `Logged out.` No public Vercel URL exists yet.
- The physical PCB revision is unconfirmed. Arduino CLI detected no connected boards. Live USB, GNSS and SMS verification remains pending.
- iOS build requires macOS and Xcode. Android APK assembly succeeded, and the Windows emulator remains unavailable for launch verification.

## Continue

1. On the iPhone, open [Vercel New Project](https://vercel.com/new), import `berrring/tracker1` with production branch `main` and select **Other**, root `./`, empty Install and Build commands and output `public`. See [DEPLOYMENT.md](DEPLOYMENT.md).
2. Open the public URL and reload the main screen and `/#/hardware`.
3. Identify the physical board revision, check the vendor pinout and follow [HARDWARE_SETUP.md](HARDWARE_SETUP.md) before enabling the bench profile or uploading.
4. For future edits, update the source and regenerated `public/` together, review staged data and verify the remote hash after the push.
