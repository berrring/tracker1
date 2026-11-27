import 'dart:js_interop';

import 'tracker_usb.dart';

@JS('safeTrackSerial')
external _SerialBridge? get _bridge;

extension type _SerialBridge(JSObject _) implements JSObject {
  external bool supported();
  external bool connected();
  external JSPromise<JSString> connect();
  external JSPromise<JSString> request(String command, String args);
  external JSPromise<JSAny?> disconnect();
}

TrackerUsb createUsb() => _BrowserUsb();

class _BrowserUsb implements TrackerUsb {
  @override
  bool get supported => _bridge?.supported() ?? false;

  @override
  bool get connected => _bridge?.connected() ?? false;

  @override
  Future<TrackerReply> connect() async {
    final bridge = _bridge;
    if (bridge == null || !supported) return const TrackerReply('unsupported');
    final reply = await _decode(bridge.connect());
    if (reply.device == null) await disconnect();
    return reply;
  }

  @override
  Future<TrackerReply> request(String command, [String arguments = '']) async {
    final bridge = _bridge;
    if (bridge == null || !connected) return const TrackerReply('disconnected');
    return _decode(bridge.request(command, arguments));
  }

  Future<TrackerReply> _decode(JSPromise<JSString> promise) async {
    try {
      return TrackerReply.decode((await promise.toDart).toDart);
    } on FormatException {
      return const TrackerReply('wrong_device');
    } catch (_) {
      return const TrackerReply('serial_error');
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      await _bridge?.disconnect().toDart;
    } catch (_) {
      // Unplugging already releases the underlying port.
    }
  }
}
