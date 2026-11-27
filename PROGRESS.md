# Checkpoint 03

## Completed

- Reviewed original Arduino sketches and compared them with Waveshare and SIMCom references. Original sketches are outside Git.
- Added the default-locked Arduino bench firmware and local serial utility. Both firmware profiles compiled on Arduino ESP32 3.3.12.
- Added local demo persistence, a dedicated USB setup route and Vercel settings. The first release built and ran in local desktop and phone-width previews. The hardware route survived reload and the demo retained its offline state.
- Vercel CLI reported `Logged out`. No public deployment URL exists yet.

## In progress

- Rebuild the final Flutter release and Android APK after the latest UI wording and feedback changes, then verify the tests.
- Audit public/ and put the verified deployment files on `main`.

## Known issues

- The physical Waveshare revision is unconfirmed and Arduino CLI detected no connected boards. USB, RF, GNSS and real SMS have not been verified.
- iOS requires macOS and Xcode. The Windows Android emulator previously failed to boot.

## Continue

1. Run `flutter gen-l10n`, `flutter analyze`, `flutter test`, and `flutter build web --release --no-web-resources-cdn`.
2. Run `python tools/prepare_public.py` and check the localhost release.
3. Audit source and public artifacts, push a verified fast-forward update to `main` and record the hash.
4. Import the existing Git repository from Vercel using [DEPLOYMENT.md](DEPLOYMENT.md).
