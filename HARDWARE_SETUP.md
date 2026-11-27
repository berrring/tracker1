# Physical SafeTrack tracker setup

The public Flutter site is a demo. The physical setup screen is a separate workspace for a directly connected USB device. It does not feed the demo map or send device data to a server.

## Board revision

Target product: Waveshare ESP32-S3-A7670E-4G with SIMCom A7670. The supplied sketches and Waveshare's hardware serial example agree on ESP32 UART1 RX GPIO17, TX GPIO18 and 115200 8N1. Waveshare's Arduino documentation assigns the RGB LED to GPIO38. GPIO0 is the sample's BOOT input and an ESP32-S3 boot strap. The board uses its physical 4G power switch in this checkpoint. The firmware does not drive published modem power-control pins, which may vary by revision.

The exact **physical PCB revision and installed modem firmware** are unverified. Before enabling the profile, inspect the board silkscreen and modem label, match the board to the corresponding schematic, and verify UART, RGB and BOOT assignments. V1 and V2 differ in other peripherals and are not interchangeable board profiles. Leave the default lock in place if any pin or revision is uncertain. [Waveshare product overview](https://docs.waveshare.com/ESP32-S3-A7670E-4G) · [Arduino examples](https://docs.waveshare.com/ESP32-S3-A7670E-4G/Arduino) · [Waveshare revision and DIP-switch notes](https://docs.waveshare.com/ESP32-S3-A7670E-4G/FAQ)

## Local workflow

1. Use a data USB cable and the board's ESP32-S3 UART-to-USB selection. Check the board-specific DIP diagram before applying power. Close Serial Monitor so only one client can access the port.
2. In desktop Chrome or Edge, open SafeTrack on HTTPS or localhost. Go to **Устройство → Физический трекер**, then choose the ESP32-S3 serial port. The setup screen checks protocol, firmware and board identity.
3. With the verified board profile enabled, enter the device name and an authorized phone number. Use international format with a plus and 8–15 digits. Review the actual number and confirm consent.
4. Press and release BOOT on the board within 20 seconds when prompted. A fresh debounced press is required. Contact details are saved on the board in NVS and are not read back by the app.
5. Run modem/GNSS diagnostics and verify network registration. A first GNSS fix may require a clear sky view and time. A GNSS fix is not required for a test SMS.
6. Choose **Отправить тестовое SMS**, confirm the test and press BOOT again. Only the fixed test message is sent. The text contains no coordinates or emergency claim. Read the submission result and confirm receipt separately on the authorized phone.
7. To clear the number, select **Удалить контакт с платы** and approve on the board again.

If the browser cannot choose a serial port, use the local Python utility. Replace `COM3` with the detected port.

```sh
python -m pip install pyserial
python tools/tracker_serial.py COM3 status
python tools/tracker_serial.py COM3 diag
python tools/tracker_serial.py COM3 set
python tools/tracker_serial.py COM3 test
python tools/tracker_serial.py COM3 clear
```

The utility prompts for the number without echoing it or including it in command arguments. Serial Monitor can also inspect the read-only command `ST1 1 STATUS` at 115200 baud and LF line endings. No serial endpoint is exposed over the network. Browser support varies and selecting a port requires user activation. [Chrome Web Serial documentation](https://developer.chrome.com/docs/capabilities/serial)

## Manual bench verification

- Confirm the silkscreen revision, modem part and ESP32 serial endpoint.
- Check connected, wrong firmware, unplugged, modems without power and expired confirmation.
- Check that holding BOOT before the request does not approve it.
- Save an authorized test contact, power cycle and check that configuration persists without returning the number.
- Check modem failure, no SIM or no cellular service, GNSS unavailable and GNSS fix outdoors.
- Submit one consented test SMS and record modem acceptance and actual handset receipt separately. If submission becomes unknown, do not retry until you have checked the handset and restarted the board.
- Clear the contact and verify it remains clear after restart.

Physical USB, GNSS and SMS checks require a real board and consenting test recipient. They have not been performed on this host.
