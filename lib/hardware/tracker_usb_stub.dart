import 'tracker_usb.dart';

TrackerUsb createUsb() => _UnsupportedUsb();

class _UnsupportedUsb implements TrackerUsb {
  @override
  bool get supported => false;
  @override
  bool get connected => false;

  @override
  Future<TrackerReply> connect() async => const TrackerReply('unsupported');

  @override
  Future<TrackerReply> request(String command, [String arguments = '']) async =>
      const TrackerReply('unsupported');

  @override
  Future<void> disconnect() async {}
}
