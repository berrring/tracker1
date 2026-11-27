# SafeTrack checkpoint 03

## Release

- GitHub repository: [berrring/tracker1](https://github.com/berrring/tracker1)
- Production branch: `main`. The release commit contains the compiled Flutter bundle in `public/`, `vercel.json`, and the corresponding source.
- Vercel URL: pending. `npx vercel whoami` returned `Logged out.` Import the repository in Safari using [DEPLOYMENT.md](DEPLOYMENT.md).
- Android ARM64 debug APK: `build/app/outputs/flutter-apk/app-debug.apk`.
- Firmware: `firmware/SafeTrackBench/SafeTrackBench.ino`. Local fallback: `tools/tracker_serial.py`.
- Firmware and checkpoint rules were first pushed on `checkpoint/03-web-usb` at `37f8f8174cf03474d1bbaae0695d952fede61a68`.

## Verification

| Check | Result |
| --- | --- |
| Dart format | Clean |
| `flutter analyze` | Passed, no issues |
| `flutter test` | 18 passed, including demo persistence, phone format, device state, USB fallback and SOS regressions |
| `flutter build web --release --no-web-resources-cdn` | Passed. The copied static build uses bundled renderer assets. |
| Local browser | Rendered at desktop and phone widths. The four demo tabs and local USB screen opened. The hardware hash route and offline demo state survived reload. The browser error log was empty during the verification. |
| Android ARM64 debug APK | Build passed |
| Arduino CLI and Espressif ESP32 3.3.12 | Default-locked build and compile-time enabled profile both passed |
| Physical device | Arduino CLI detected no boards. Hardware, GNSS, real SMS and upload were not exercised. |
| iOS | Existing project preserved. Native build requires macOS and Xcode. |

## Follow-up

- Verify the physical PCB revision, modem and the UART, BOOT and LED pins against the Waveshare schematic. Then follow the consented bench checklist in [HARDWARE_SETUP.md](HARDWARE_SETUP.md).
- Import GitHub into Vercel and verify the production URL on the iPhone. Future verified releases update source and `public/` in the same push.
- A future backend requires authenticated device enrollment, explicit access and revocation, protected storage and clear consent for any live data. This release has no backend, real location sharing or emergency-services integration.
