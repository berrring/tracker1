# SafeTrack Family

SafeTrack Family is a Russian-first Flutter prototype for a family safety tracker on Android, iOS and web. It opens on a local, illustrated map of a fictional neighborhood. Every person, position, device ID, event and SOS result is demo data. The app never sends a real SOS.

## Run locally

Install the [stable Flutter SDK](https://docs.flutter.dev/install/archive). Connect an Android device or start an emulator, then run these commands from the project directory.

```sh
flutter pub get
flutter gen-l10n
flutter run
```

Select the Android target when prompted. To run iOS, use macOS with Xcode and an iOS simulator or device. The app uses Flutter's Material 3 widgets and has no backend, tracker hardware, runtime API key or secret. SDK and package downloads may require network access during setup.

To build a debug APK for an ARM64 Android device, run `flutter build apk --debug --target-platform android-arm64`. On macOS, `flutter build ios --no-codesign` checks the iOS build without code signing.

For a browser demo, run `flutter run -d chrome`. The production bundle in `public/` can be imported from GitHub into Vercel without installing Flutter there. See [DEPLOYMENT.md](DEPLOYMENT.md) for the iPhone import settings.

## Demonstrate the prototype

- **Карта** shows the last recorded position, timestamp, accuracy radius, charge and connection. Pan or zoom the fictional map and tap the crosshair to recenter.
- **События** lists a small set of fictional safety events. Confirming a demo SOS adds a local event.
- **Семья** shows the owner, an invited trusted adult and the tracker wearer. Tap **Добавить устройство**, enter **DEMO-042**, review the access for each person and explicitly confirm.
- **Устройство → Демо-сценарий** switches among fresh, stale, offline, low battery, SOS, loading, empty, unavailable and error. The selected scenario is shared by the screens.
- **Устройство → Тестовый SOS** demonstrates preparation, sending and simulated acknowledgement. With **Нет связи** selected, the flow shows an unconfirmed result and the time of last contact.
- Web demo state, notification choices and language are stored locally in the browser. Native targets keep demo state in the current session.
- **Устройство → Физический трекер** opens the separate USB setup. Real hardware contact and diagnostics never enter the demo map or browser storage.

## Source and localization

- `lib/app/` contains the Material theme, shared UI and navigation shell.
- [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md) documents the shared tokens, components, and accessibility behavior.
- `lib/features/` contains the map, event feed, family and pairing, device and SOS screens.
- `lib/hardware/` and `web/tracker_serial.js` implement the local USB transport and platform fallback.
- [HARDWARE_SETUP.md](HARDWARE_SETUP.md) documents local USB and the serial utility. [firmware/README.md](firmware/README.md) covers the Arduino bench build.
- `lib/data/mock_tracker_repository.dart` provides deterministic state, mock positions, pairing, notification preferences and SOS transitions.
- `lib/l10n/` holds the Russian template, complete English translations and an empty Kyrgyz ARB scaffold. The globe menu switches between Russian and English. The Kyrgyz preview uses Russian pending review by a fluent translator and support for Kyrgyz Material control labels.

Run the checks with:

```sh
flutter pub get
flutter gen-l10n
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

## Scope and limitations

The demo uses fictional map positions, family members and events. The separate bench setup can exchange commands over an explicitly chosen USB port and needs physical approval to save contacts or send a fixed test SMS. The firmware starts with its hardware profile disabled until the board revision and connections are checked. Live location, remote configuration, production authentication, push notifications and emergency-services integration remain outside this MVP.

The Windows host's API 37 emulator did not complete boot. Browser and widget tests exercise the shared UI. Building or launching the iOS target requires macOS and Xcode. No Waveshare board was detected for an on-device check.
