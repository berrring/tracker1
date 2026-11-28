# SafeTrack bench firmware

Open `SafeTrackBench/SafeTrackBench.ino` with Arduino IDE. Install **esp32 by Espressif Systems** in Boards Manager. This checkpoint uses the bundled Arduino core, HardwareSerial, Preferences and RGB LED support. It requires no additional Arduino libraries.

Select **ESP32S3 Dev Module**, USB CDC on boot **Disabled** for the onboard USB-to-UART bridge, and the flash/PSRAM options matching the actual module. The default profile `0` answers USB identification with modem, switch, RGB and gauge disabled. Profile `1` is the earlier verified-board workflow; profile `2` additionally enables the documented V2 gauge bus. Use these profiles only after the physical checks in [HARDWARE_SETUP.md](../HARDWARE_SETUP.md). The SOS pin is `-1` by default and GPIO7 is excluded because it is shared with the camera. Compiling a profile is separate from authorizing a flash.

Command-line compile for the default build:

```sh
arduino-cli compile --fqbn esp32:esp32:esp32s3 firmware/SafeTrackBench
c++ -std=c++17 firmware/tests/switch_approval_test.cpp -o /tmp/safetrack-switch-test
/tmp/safetrack-switch-test
```

### Reference sketches

| Sketch | Comparison |
| --- | --- |
| L0000 | Starts an SMS sequence at boot. It checks for the prompt and displays modem data, but completion of the loop is not evidence of acceptance. |
| L0002 | Starts a one-shot location/SMS flow via BOOT. The presence of digits in a GNSS response is insufficient proof of a fix. |
| L0003 | Toggles periodic location SMS. The nested copy adds registration and response checks. Those checks are useful for diagnostics, but repeating location messages is outside the bench design. |

The top-level and nested reference sketches were inspected. They contain contact data and remain unmodified outside this repository. This firmware has a new serial protocol and never starts a message on boot or schedules periodic reports.

### Device protocol

Lines are `ST1 <id> <command>\n`. Replies carry the same ID followed by a JSON object. Commands are `STATUS`, `DIAG`, `SET`, `CLEAR`, `TEST` and `CANCEL`. `SET` takes the number and device name separated by a vertical bar. Contact changes wait for physical BOOT approval for up to 20 seconds. `TEST` uses a fresh BOOT press or, when an approved slide input is configured, stable OFF for 250 ms and then stable ON for 1.5 s. A switch alone cannot start a request. The LED shows approval and active checks. Status adds optional `sim`, `testInput`, `batteryPercent` and `batteryMillivolts`; unavailable battery values are null. The V2 gauge reads VCELL/SOC without writes. [Analog Devices MAX17048 data sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/MAX17048-MAX17049.pdf)

Diagnostics interpret SIMCom `AT`, `CREG?`/`CEREG?`, `CGNSSPWR` and `CGNSSINFO`. SMS uses text mode, waits for the `CMGS` prompt, submits fixed demo content, and requires a message reference and final `OK` for modem acceptance. A modem error means rejection. An incomplete response after submission leaves the result unknown and blocks additional SMS attempts until restart. Modem acceptance is distinct from handset delivery. Raw modem data and coordinates are never echoed. [SIMCom A76XX AT command manual](https://files.waveshare.com/wiki/A7670E-Cat-1-GNSS-HAT/A76XX_Series_AT_Command_Manual_V1.09.pdf)
