# Checkpoint 05 — SafeTrack dashboard redesign

- Implemented Inter and the route mark, desktop navigation and dashboard, mobile map-first flow, chronological events, SOS details, family permissions and compact device and USB screens.
- Added the shared map controls and provider selection. Web uses 2GIS when configured, MapLibre otherwise. Android and iOS use MapLibre.
- The supplied mobile SDK key remains outside the source and deployment bundle. A browser MapGL key is still needed for a live 2GIS test. See [MAP_PROVIDER.md](MAP_PROVIDER.md).
- Recorded the reported header installation. IO13 and IO14 share the camera interface and remain unassigned. Firmware files are unchanged.
- Chromium preview rendered OpenFreeMap tiles and attribution and exercised zoom and recenter. Inspected map, events, SOS details, family profiles, pairing, device controls and the disconnected USB wizard at 390, 820 and 1440 px widths.
- Flutter analysis, 22 widget and unit tests, and three MapGL adapter tests passed during development. The final release is pending a rebuild after visual fixes. The Android build is being retried with built-in Kotlin enabled for MapLibre.
- Next: verify native build output, audit the final public/ bundle, advance main and confirm that the Vercel production bundle matches the Git commit.

# Checkpoint 04 — slide SOS and setup wizard

## Completed

- Matched reported V2.0 against published Waveshare references. GPIO7 is shared with the camera and is excluded from the SOS profile. There is no assigned SOS pin.
- Added a default-locked baseline/V2 firmware profile, explicit local SOS approval with debounce and hold, SIM diagnostics and optional MAX17048 readings.
- Implemented eight-step USB setup, optional diagnostic fields for older firmware, local serial fallback and clearer demo labels.

## Software verification

- Flutter analysis passed and all 21 tests passed, including offline SOS, pairing, invalid configuration, missing battery data, disabled profile and USB disconnection.
- Web release built and 34 files were synced into `public/`. Inspected the production bundle in Chromium at 1280 × 820 and 390 × 844. Checked the map, events, family, device, demo SOS, pairing, disconnected wizard and `/#/hardware` reload. Connected wizard states use test fixtures.
- Android ARM64 debug build passed. Local APK: `build/app/outputs/flutter-apk/app-debug.apk`.
- Arduino CLI compiled profiles 0, 1 and 2 with ESP32 core 3.3.12. The host C++ switch tests passed. The serial helper starts with pyserial 3.5.
- Firmware checkpoint pushed and verified on `checkpoint/04-slide-wizard` at `81f7da6c926d7717b3745df86694c6f36b6da85d`.

## Known issues and next steps

- The physical PCB revision, modem variant and external switch wiring remain unconfirmed. Identify and inspect them against [HARDWARE_SETUP.md](HARDWARE_SETUP.md) before enabling a profile.
- Keep `SAFETRACK_VERIFIED_PROFILE=0` and `SAFETRACK_SOS_PIN=-1` until verification. No firmware was flashed.
- After the physical review and explicit flash authorization, build the matching profile, then follow the manual bench checks in HARDWARE_SETUP.md. Record modem acceptance and handset receipt separately.
- Run the Android APK on a device. Use macOS and Xcode for `flutter build ios --no-codesign` and iOS execution.
- For future web changes, run `flutter build web --release --no-web-resources-cdn` then `python tools/prepare_public.py`. Vercel uses the existing GitHub integration and unchanged `vercel.json`. Confirm the deployed commit in Vercel.
