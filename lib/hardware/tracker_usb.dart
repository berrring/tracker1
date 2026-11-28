import 'dart:convert';

import 'tracker_usb_stub.dart'
    if (dart.library.js_interop) 'tracker_usb_web.dart'
    as platform;

const trackerBoard = 'ESP32-S3-A7670E-4G';

bool isInternationalPhone(String value) =>
    RegExp(r'^\+[1-9][0-9]{7,14}$').firstMatch(value)?.end == value.length;

bool isTrackerName(String value) =>
    value.trim().isNotEmpty &&
    utf8.encode(value).length <= 48 &&
    !RegExp(r'[\x00-\x1f\x7f|]').hasMatch(value);

abstract interface class TrackerUsb {
  bool get supported;
  bool get connected;
  Future<TrackerReply> connect();
  Future<TrackerReply> request(String command, [String arguments = '']);
  Future<void> disconnect();
}

TrackerUsb createTrackerUsb() => platform.createUsb();

class TrackerReply {
  const TrackerReply(this.code, {this.device});

  final String code;
  final TrackerDevice? device;

  factory TrackerReply.decode(String json) {
    final value = jsonDecode(json);
    if (value is! Map<String, dynamic> || value['code'] is! String) {
      throw const FormatException('Invalid tracker protocol response');
    }
    if (value['code'] != 'status' &&
        value['code'] != 'saved' &&
        value['code'] != 'cleared') {
      return TrackerReply(value['code'] as String);
    }
    if (value['protocol'] != 1 ||
        value['board'] != trackerBoard ||
        value['firmware'] is! String ||
        value['name'] is! String ||
        value['configured'] is! bool ||
        value['profile'] is! bool ||
        value['modem'] is! String ||
        value['network'] is! String ||
        value['gnss'] is! String) {
      return const TrackerReply('wrong_device');
    }
    return TrackerReply(
      value['code'] as String,
      device: TrackerDevice(
        firmware: value['firmware'] as String,
        name: value['name'] as String,
        configured: value['configured'] as bool,
        profileEnabled: value['profile'] as bool,
        modem: value['modem'] as String,
        network: value['network'] as String,
        gnss: value['gnss'] as String,
        sim: value['sim'] is String ? value['sim'] as String : 'not_checked',
        testInput: switch (value['testInput']) {
          'slide' => 'slide',
          'boot' => 'boot',
          _ => value['profile'] == true ? 'boot' : 'unavailable',
        },
        batteryPercent: _reading(value['batteryPercent'], 0, 100),
        batteryMillivolts: _reading(value['batteryMillivolts'], 2500, 4500),
      ),
    );
  }

  static int? _reading(Object? value, int min, int max) =>
      value is int && value >= min && value <= max ? value : null;
}

class TrackerDevice {
  const TrackerDevice({
    required this.firmware,
    required this.name,
    required this.configured,
    required this.profileEnabled,
    required this.modem,
    required this.network,
    required this.gnss,
    this.sim = 'not_checked',
    this.testInput = 'boot',
    this.batteryPercent,
    this.batteryMillivolts,
  });
  final String firmware;
  final String name;
  final bool configured;
  final bool profileEnabled;
  final String modem;
  final String network;
  final String gnss;
  final String sim;
  final String testInput;
  final int? batteryPercent;
  final int? batteryMillivolts;
}
