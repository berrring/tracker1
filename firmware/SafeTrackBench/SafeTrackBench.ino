#include <Arduino.h>
#include <Preferences.h>
#include <cstring>
#include "board_profile.h"

constexpr char firmwareVersion[] = "0.3.0-bench";
constexpr char boardModel[] = "ESP32-S3-A7670E-4G";
constexpr char testText[] = "SafeTrack bench test. No emergency.";
constexpr uint32_t approvalWindow = 20000;
HardwareSerial modem(1);
Preferences storage;
bool storageReady = false;
String contact, deviceName, input;
bool discardInput = false;
const char *modemState = "not_checked";
bool submissionUnknown = false;
const char *network = "not_checked";
const char *gnss = "not_checked";

enum class Action { none, save, clear, test };
struct Pending {
  Action action = Action::none;
  String id, number, name;
  uint32_t began = 0;
};
Pending pending;
bool lastButton = HIGH, stableButton = HIGH;
uint32_t buttonChange = 0;

void light(uint8_t red, uint8_t green, uint8_t blue) {
  if (profileEnabled) rgbLedWrite(rgbPin, red, green, blue);
}

bool validNumber(const String &number) {
  if (number.length() < 9 || number.length() > 16 || number[0] != '+' ||
      number[1] < '1' || number[1] > '9') return false;
  for (size_t i = 2; i < number.length(); ++i) {
    if (number[i] < '0' || number[i] > '9') return false;
  }
  return true;
}

bool validName(const String &name) {
  if (name.isEmpty() || name.length() > 48) return false;
  for (size_t i = 0; i < name.length(); ++i) {
    const unsigned char c = name[i];
    if (c < 32 || c == 127 || c == '|') return false;
  }
  return true;
}

void beginReply(const String &id, const char *code) {
  Serial.print("ST1 ");
  Serial.print(id);
  Serial.print(" {\"code\":\"");
  Serial.print(code);
  Serial.print('"');
}

void result(const String &id, const char *code) {
  beginReply(id, code);
  Serial.println('}');
}

void status(const String &id, const char *code = "status") {
  beginReply(id, code);
  Serial.printf(",\"protocol\":1,\"board\":\"%s\",\"firmware\":\"%s\",\"name\":\"",
                boardModel, firmwareVersion);
  for (size_t i = 0; i < deviceName.length(); ++i) {
    const char c = deviceName[i];
    if (c == '\\' || c == '"') Serial.write('\\');
    Serial.write(c);
  }
  Serial.printf("\",\"configured\":%s,\"profile\":%s,\"modem\":\"%s\",\"network\":\"%s\",\"gnss\":\"%s\"}\n",
                contact.isEmpty() ? "false" : "true", profileEnabled ? "true" : "false",
                profileEnabled ? modemState : "unavailable", network, gnss);
}

enum class AtEnd { ok, prompt, rejected, timeout };
struct AtReply {
  AtEnd end = AtEnd::timeout;
  String data;
  bool messageReference = false;
};

AtReply readAt(uint32_t timeout, const char *prefix = "", bool expectPrompt = false) {
  AtReply reply;
  String line;
  bool overflow = false;
  const uint32_t start = millis();
  while (millis() - start < timeout) {
    while (modem.available() && millis() - start < timeout) {
      const char c = char(modem.read());
      if (expectPrompt && !overflow && c == '>' && line.isEmpty()) {
        reply.end = AtEnd::prompt;
        return reply;
      }
      if (c != '\r' && c != '\n') {
        if (line.length() < 256) line += c;
        else overflow = true;
        continue;
      }
      if (overflow) {
        overflow = false;
        line = "";
        continue;
      }
      line.trim();
      if (line == "OK" || line == "ERROR" ||
          line.startsWith("+CMS ERROR:") || line.startsWith("+CME ERROR:")) {
        reply.end = line == "OK" ? AtEnd::ok : AtEnd::rejected;
        return reply;
      }
      if (*prefix && line.startsWith(prefix)) reply.data = line;
      if (line.startsWith("+CMGS:")) {
        const char *value = line.c_str() + 6;
        while (*value == ' ') ++value;
        reply.messageReference = *value >= '0' && *value <= '9';
      }
      line = "";
    }
    delay(2);
  }
  return reply;
}

AtReply command(const String &at, uint32_t timeout = 2000, const char *prefix = "") {
  const uint32_t start = millis();
  while (modem.available() && millis() - start < 20) modem.read();
  modem.print(at);
  modem.write('\r');
  return readAt(timeout, prefix);
}

bool registered(const char *at, const char *prefix) {
  const AtReply reply = command(at, 1500, prefix);
  if (reply.end != AtEnd::ok) return false;
  const int colon = reply.data.indexOf(':');
  if (colon < 0) return false;
  int mode, state;
  return sscanf(reply.data.c_str() + colon + 1, " %d , %d", &mode, &state) == 2 &&
         (state == 1 || state == 5);
}

bool networkReady() {
  const bool yes = registered("AT+CREG?", "+CREG:") ||
                   registered("AT+CEREG?", "+CEREG:");
  network = yes ? "registered" : "not_registered";
  return yes;
}

bool probeModem() {
  const bool modemPresent = command("AT").end == AtEnd::ok;
  modemState = modemPresent ? "ready" : "unavailable";
  if (modemPresent) command("ATE0");
  return modemPresent;
}

void diagnose(const String &id) {
  if (!profileEnabled) { result(id, "profile_locked"); return; }
  light(0, 0, 20);
  if (!submissionUnknown && probeModem()) {
    networkReady();
    if (command("AT+CGNSSPWR=1", 4500).end == AtEnd::ok) {
      const AtReply fix = command("AT+CGNSSINFO", 2000, "+CGNSSINFO:");
      if (fix.end == AtEnd::ok && !fix.data.isEmpty()) {
        String mode = fix.data.substring(fix.data.indexOf(':') + 1);
        mode.trim();
        gnss = mode.startsWith("2,") || mode.startsWith("3,") ? "fix" : "no_fix";
      } else gnss = "unavailable";
    } else gnss = "unavailable";
  } else {
    network = "unavailable";
    gnss = "unavailable";
  }
  status(id);
  light(0, 10, 0);
}

const char *testSms() {
  if (submissionUnknown) return "sms_unknown";
  if (!probeModem()) return "no_modem";
  if (!networkReady()) return "not_registered";
  if (command("AT+CMGF=1").end != AtEnd::ok ||
      command("AT+CSCS=\"GSM\"").end != AtEnd::ok) return "sms_rejected";
  modem.print("AT+CMGS=\"");
  modem.print(contact);
  modem.print("\"\r");
  const AtReply prompt = readAt(10000, "", true);
  if (prompt.end != AtEnd::prompt) {
    modem.write(27);
    return prompt.end == AtEnd::rejected ? "sms_rejected" : "timeout";
  }
  modem.print(testText);
  modem.write(26);
  const AtReply sent = readAt(65000);
  if (sent.end == AtEnd::ok && sent.messageReference) return "sms_accepted";
  if (sent.end == AtEnd::rejected) return "sms_rejected";
  submissionUnknown = true;
  return "sms_unknown";
}

void approve() {
  const Pending approved = pending;
  pending = {};
  if (approved.action == Action::none) return;
  light(0, 0, 24);
  if (approved.action == Action::test) {
    const char *outcome = testSms();
    result(approved.id, outcome);
    light(std::strcmp(outcome, "sms_accepted") == 0 ? 0 : 12, 10, 0);
    return;
  }
  if (!storageReady) {
    result(approved.id, "storage_error");
  } else if (approved.action == Action::clear) {
    if (storage.remove("profile") || !storage.isKey("profile")) {
      contact = "";
      deviceName = "";
      status(approved.id, "cleared");
    } else result(approved.id, "storage_error");
  } else {
    const String entry = approved.number + '|' + approved.name;
    if (storage.putString("profile", entry) == entry.length()) {
      contact = approved.number;
      deviceName = approved.name;
      status(approved.id, "saved");
    } else result(approved.id, "storage_error");
  }
  light(0, 10, 0);
}

void handleLine(String line) {
  line.trim();
  if (!line.startsWith("ST1 ")) return;
  const int separator = line.indexOf(' ', 4);
  if (separator < 5 || separator > 14) return;
  const String id = line.substring(4, separator);
  for (size_t i = 0; i < id.length(); ++i) if (!isDigit(id[i])) return;
  const String action = line.substring(separator + 1);
  if (action == "CANCEL") {
    if (pending.action != Action::none) result(pending.id, "cancelled");
    pending = {};
    light(0, 10, 0);
    return;
  }
  if (action == "STATUS") { status(id); return; }
  if (pending.action != Action::none) { result(id, "busy"); return; }
  if (!profileEnabled) { result(id, "profile_locked"); return; }
  if (action == "DIAG") { diagnose(id); return; }
  if (action == "TEST") {
    if (contact.isEmpty()) { result(id, "not_configured"); return; }
    pending = {Action::test, id, "", "", millis()};
  } else if (action == "CLEAR") {
    pending = {Action::clear, id, "", "", millis()};
  } else if (action.startsWith("SET ")) {
    const int divider = action.indexOf('|', 4);
    if (divider < 0) { result(id, "invalid"); return; }
    const String number = action.substring(4, divider);
    const String name = action.substring(divider + 1);
    if (!validNumber(number) || !validName(name)) { result(id, "invalid"); return; }
    pending = {Action::save, id, number, name, millis()};
  } else { result(id, "invalid"); return; }
  light(25, 10, 0);
}

void setup() {
  Serial.begin(baud);
  if (profileEnabled) {
    pinMode(bootButton, INPUT_PULLUP);
    lastButton = stableButton = digitalRead(bootButton);
    modem.begin(baud, SERIAL_8N1, modemRx, modemTx);
    storageReady = storage.begin("safetrack", false);
    if (storageReady) {
      const String saved = storage.getString("profile", "");
      const int divider = saved.indexOf('|');
      if (divider >= 0 && validNumber(saved.substring(0, divider)) &&
          validName(saved.substring(divider + 1))) {
        contact = saved.substring(0, divider);
        deviceName = saved.substring(divider + 1);
      }
    }
    light(0, 10, 0);
  }
}

void loop() {
  while (Serial.available()) {
    const char c = char(Serial.read());
    if (c == '\n') {
      if (!discardInput) handleLine(input);
      input = "";
      discardInput = false;
    } else if (c != '\r' && !discardInput) {
      if (input.length() < 128) input += c;
      else discardInput = true;
    }
  }
  if (pending.action != Action::none && millis() - pending.began >= approvalWindow) {
    result(pending.id, "confirm_timeout");
    pending = {};
    light(0, 10, 0);
  }
  if (profileEnabled) {
    const bool reading = digitalRead(bootButton);
    if (reading != lastButton) {
      lastButton = reading;
      buttonChange = millis();
    }
    if (reading != stableButton && millis() - buttonChange >= 40) {
      stableButton = reading;
      if (stableButton == LOW && pending.action != Action::none &&
          int32_t(buttonChange - pending.began) > 0) approve();
    }
  }
  delay(2);
}
