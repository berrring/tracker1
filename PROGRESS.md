# Checkpoint 04 — slide SOS and setup wizard

## Completed

- Matched reported V2.0 against published Waveshare references. GPIO7 is shared with the camera and is excluded from the SOS profile. There is no assigned SOS pin.
- Added a default-locked baseline/V2 firmware profile, explicit local SOS approval with debounce and hold, SIM diagnostics and optional MAX17048 readings.
- Implemented eight-step USB setup, optional diagnostic fields for older firmware, local serial fallback and clearer demo labels.

## In progress

- Verify the host SOS switch tests and Flutter tests, then rebuild the Android APK and deployment files in public/.
- Exercise the production web build and verify the authorized GitHub refs.

## Known issues and next steps

- The physical PCB revision, modem variant and external switch wiring remain unconfirmed. Identify and inspect them against [HARDWARE_SETUP.md](HARDWARE_SETUP.md) before enabling a profile.
- Keep `SAFETRACK_VERIFIED_PROFILE=0` and `SAFETRACK_SOS_PIN=-1` until verification. No firmware was flashed.
- After local verification, run `flutter build web --release --no-web-resources-cdn` and `python tools/prepare_public.py`, audit staged data, then fast-forward and verify `origin/main`.
- The existing Vercel project uses the GitHub integration. Preserve vercel.json and confirm the deployed commit in Vercel if accessible.
- Android device execution and iOS execution remain separate checks. iOS requires macOS and Xcode.
