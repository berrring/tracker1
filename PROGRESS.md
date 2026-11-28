# Checkpoint 06 — Supabase family accounts

- Authenticated Supabase MCP inspection confirmed an empty public schema. The security advisor flagged API execution grants for the existing RLS event trigger helper.
- Applied `20261128033552_family_accounts.sql` through MCP. The hosted migration history records the same version. Verified eight RLS-protected tables, no anonymous table read grants, and an empty security-advisor report after revoking the existing helper's API permissions.
- PostgreSQL 16 policy assertions passed with fictional identities and transaction rollback. Hosted anonymous family reads returned HTTP 401. Local Supabase Auth and Mailpit passed email confirmation, login, refresh-token restoration, recovery and password replacement.
- Flutter analysis and 25 tests passed. The account-enabled Web release rebuilt `public/`, and the account callback route rendered in Chromium. Hosted Auth has email signup and confirmation enabled. The production Site URL and exact Web and native redirect URLs were saved and verified.
- Source checkpoint `97bcd6e47c7ac31f3333c61f703e15986e29b63c` was pushed and verified on `checkpoint/06-family-accounts`.
- Next: run the hosted two-account smoke test in DEPLOYMENT.md with authorized test inboxes, including browser reload and email receipt. Verify the native callbacks on Android and iOS before wider rollout. The Accounts workspace currently uses English.

# Checkpoint 05 — SafeTrack dashboard redesign

- Implemented Inter and the route mark, desktop navigation and dashboard, mobile map-first flow, chronological events, SOS details, family permissions and compact device and USB screens.
- Added the shared map controls and provider selection. Web uses 2GIS when configured, MapLibre otherwise. Android and iOS use MapLibre.
- The supplied mobile SDK key remains outside the source and deployment bundle. A browser MapGL key is still needed for a live 2GIS test. See [MAP_PROVIDER.md](MAP_PROVIDER.md).
- Recorded the reported header installation. IO13 and IO14 share the camera interface and remain unassigned. Firmware files are unchanged.
- Chromium preview rendered OpenFreeMap tiles and attribution and exercised zoom and recenter. Inspected map, events, SOS details, family profiles, pairing, device controls and the disconnected USB wizard at 390, 820 and 1440 px widths.
- Flutter analysis, 22 widget and unit tests, three MapGL adapter tests, and the final Flutter Web release passed. Rebuilt the 38-file `public/` directory and captured five screens at three widths.
- Verified source checkpoint `09d658a178c2f215a0ae640f12d3baefc3d45202` and web checkpoint `6223a7068b52636a31916da691f0525a0535d2df` on `checkpoint/05-dashboard`.
- Android debug assembly succeeded with AGP built-in Kotlin and Android SDK CMake 3.22.1. The APK is at `build/app/outputs/flutter-apk/app-debug.apk`.
- Next: run the APK on an Android device, build and run iOS on macOS with Xcode, and test live 2GIS using a valid browser-scoped key. Vercel uses the existing static GitHub integration and an empty runtime key file.

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
