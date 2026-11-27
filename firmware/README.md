# SafeTrack bench firmware

Open `SafeTrackBench/SafeTrackBench.ino` with Arduino IDE. Install **esp32 by Espressif Systems** in Boards Manager. This checkpoint uses the bundled Arduino core, HardwareSerial, Preferences and RGB LED support. It requires no additional Arduino libraries.

Select **ESP32S3 Dev Module**, USB CDC on boot **Disabled** for the onboard USB-to-UART bridge, and the flash/PSRAM options matching the actual module. Waveshare's example settings specify 16 MB flash and OPI PSRAM for the listed board. Click **Verify** first. Only after checking the physical board as described in [HARDWARE_SETUP.md](../HARDWARE_SETUP.md), set `SAFETRACK_VERIFIED_PROFILE` to `1` in `board_profile.h`, verify again, select the detected ESP32 port and click **Upload**. The default build responds over USB for identification with modem and control GPIO disabled.

Command-line compile for the default build:

```sh
arduino-cli compile --fqbn esp32:esp32:esp32s3 firmware/SafeTrackBench
```

### Reference sketches

| Sketch | Comparison |
| --- | --- |
| L0000 | Starts an SMS sequence at boot. It checks for the prompt and displays modem data, but completion of the loop is not evidence of acceptance. |
| L0002 | Starts a one-shot location/SMS flow via BOOT. The presence of digits in a GNSS response is insufficient proof of a fix. |
| L0003 | Toggles periodic location SMS. The nested copy adds registration and response checks. Those checks are useful for diagnostics, but repeating location messages is outside the bench design. |

The top-level and nested reference sketches were inspected. They contain contact data and remain unmodified outside this repository. This firmware has a new serial protocol and never starts a message on boot or schedules periodic reports.

### Device protocol

Lines are `ST1 <id> <command>\n`. Replies carry the same ID followed by a JSON object. Commands are `STATUS`, `DIAG`, `SET`, `CLEAR`, `TEST` and `CANCEL`. `SET` takes the number and device name separated by a vertical bar. Configuration and SMS operations wait for physical BOOT approval for up to 20 seconds. The LED shows pending approval and active checks. Connect/disconnect and read failures are surfaced in the client.

Diagnostics interpret SIMCom `AT`, `CREG?`/`CEREG?`, `CGNSSPWR` and `CGNSSINFO`. SMS uses text mode, waits for the `CMGS` prompt, submits fixed demo content, and requires a message reference and final `OK` for modem acceptance. A modem error means rejection. An incomplete response after submission leaves the result unknown and blocks additional SMS attempts until restart. Modem acceptance is distinct from handset delivery. Raw modem data and coordinates are never echoed. [SIMCom A76XX AT command manual](https://files.waveshare.com/wiki/A7670E-Cat-1-GNSS-HAT/A76XX_Series_AT_Command_Manual_V1.09.pdf)
