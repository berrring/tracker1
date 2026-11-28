import 'dart:async';

import 'package:flutter/foundation.dart';

import 'tracker_usb.dart';

/// A USB setup session. Identifiers and contact inputs never enter demo storage.
class TrackerSession extends ChangeNotifier {
  TrackerSession(this.usb) {
    _monitor = Timer.periodic(const Duration(seconds: 1), (_) {
      if (device != null && !usb.connected) {
        device = null;
        result = pending == 'TEST' ? 'sms_unknown' : 'disconnected';
        notifyListeners();
      }
    });
  }

  final TrackerUsb usb;
  late final Timer _monitor;
  bool _disposed = false;
  TrackerDevice? device;
  String? pending;
  String? result;
  String? testResult;

  bool get ready => device?.profileEnabled == true && pending == null;

  Future<void> run(String action, [String arguments = '']) async {
    if (pending != null || _disposed) return;
    pending = action;
    if (action == 'CONNECT') testResult = null;
    result = null;
    notifyListeners();
    TrackerReply reply;
    try {
      reply = await (action == 'CONNECT'
          ? usb.connect()
          : usb.request(action, arguments));
    } catch (_) {
      reply = const TrackerReply('serial_error');
    }
    if (_disposed) {
      if (action == 'CONNECT') await usb.disconnect();
      return;
    }
    pending = null;
    final uncertain = const {
      'disconnected',
      'serial_error',
      'wrong_device',
    }.contains(reply.code);
    result = action == 'TEST' && uncertain ? 'sms_unknown' : reply.code;
    if (action == 'TEST') testResult = result;
    if (reply.code == 'saved' || reply.code == 'cleared') testResult = null;
    if (!usb.connected) {
      device = null;
    } else if (reply.device != null) {
      device = reply.device;
    }
    notifyListeners();
  }

  Future<void> disconnect() async {
    if (pending != null) return;
    await usb.disconnect();
    if (_disposed) return;
    device = null;
    result = null;
    testResult = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _monitor.cancel();
    unawaited(usb.disconnect());
    super.dispose();
  }
}
