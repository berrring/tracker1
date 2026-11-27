"""Configure SafeTrack over a local ESP32-S3 serial port."""
import argparse
import getpass
import json
import re
import secrets
import sys
import time

import serial

BOARD = "ESP32-S3-A7670E-4G"
PHONE = re.compile(r"\+[1-9][0-9]{7,14}")
TIMEOUTS = {"STATUS": 5, "DIAG": 16, "SET": 25, "CLEAR": 25, "TEST": 125}


def request(port, command, args=""):
    request_id = 1 + secrets.randbelow(999999999)
    prefix = f"ST1 {request_id} ".encode("ascii")
    port.write(prefix + (command + (" " + args if args else "") + "\n").encode())
    deadline = time.monotonic() + TIMEOUTS[command]
    buffer = bytearray()
    discard = False
    while time.monotonic() < deadline:
        for byte in port.read(max(1, min(port.in_waiting, 512))):
            if byte == 10:
                if not discard and buffer.startswith(prefix):
                    value = json.loads(buffer[len(prefix):])
                    if not isinstance(value, dict) or not isinstance(value.get("code"), str):
                        raise ValueError("Invalid SafeTrack response")
                    return value
                buffer.clear()
                discard = False
            elif not discard:
                buffer.append(byte)
                if len(buffer) > 512:
                    discard = True
    raise TimeoutError


def confirmed():
    return input("Confirm this local operation by typing YES: ").strip() == "YES"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("port", help="USB serial port, for example COM3 or /dev/ttyUSB0")
    parser.add_argument("action", choices=("status", "diag", "set", "clear", "test"))
    args = parser.parse_args()
    action = args.action.upper()
    try:
        with serial.Serial(args.port, 115200, timeout=0.2, write_timeout=2) as port:
            try:
                status = request(port, "STATUS")
            except TimeoutError:
                status = request(port, "STATUS")
            if status.get("protocol") != 1 or status.get("board") != BOARD:
                print("SafeTrack firmware did not identify itself.", file=sys.stderr)
                return 2
            if action == "STATUS":
                response = status
            elif status.get("profile") is not True:
                print("The device's verified board profile is disabled.", file=sys.stderr)
                return 2
            else:
                payload = ""
                if action == "SET":
                    name = input("Device name: ").strip()
                    number = getpass.getpass("Authorized number (+country code and digits): ").strip()
                    if (not PHONE.fullmatch(number) or not name or len(name.encode()) > 48
                            or any(ord(c) < 32 or ord(c) == 127 or c == "|" for c in name)):
                        print("Invalid name or international number.", file=sys.stderr)
                        return 2
                    print("Confirm the number you entered and consent from its owner.")
                    payload = number + "|" + name
                elif action == "TEST":
                    print('A real SMS, "SafeTrack bench test. No emergency.", will be sent to the saved contact.')
                elif action == "CLEAR":
                    print("Remove the saved contact from the connected device.")
                if action in {"SET", "TEST", "CLEAR"}:
                    if not confirmed():
                        return 1
                    print("Press BOOT on the connected board within 20 seconds.")
                try:
                    response = request(port, action, payload)
                except (KeyboardInterrupt, TimeoutError):
                    try:
                        port.write(b"ST1 0 CANCEL\n")
                    except serial.SerialException:
                        pass
                    raise
            # Keep the number, raw modem replies and user-entered name out of output.
            known = {"status", "saved", "cleared", "sms_accepted", "sms_rejected",
                     "sms_unknown", "not_registered", "no_modem", "confirm_timeout",
                     "storage_error", "not_configured", "profile_locked", "invalid",
                     "cancelled", "busy", "timeout"}
            code = response["code"] if response["code"] in known else "invalid_reply"
            print(code)
            if code == "sms_accepted":
                print("Modem accepted the SMS. Recipient delivery is unconfirmed.")
            if code in {"status", "saved", "cleared"}:
                for field in ("configured", "profile", "firmware", "modem", "network", "gnss"):
                    if field in response:
                        item = response[field]
                        if isinstance(item, bool) or (
                            isinstance(item, str) and re.fullmatch("[a-zA-Z0-9_.-]{1,32}", item)
                        ):
                            print(f"{field}: {item}")
            return 0 if code in {"status", "saved", "cleared", "sms_accepted"} else 2
    except (OSError, ValueError, TimeoutError, KeyboardInterrupt):
        if action == "TEST":
            print("No final result. SMS submission and delivery are unknown.", file=sys.stderr)
        else:
            print("Serial operation did not complete. Check the port and firmware.", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
