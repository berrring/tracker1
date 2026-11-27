import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:safetrack_family/app/app.dart';
import 'package:safetrack_family/data/demo_store.dart';
import 'package:safetrack_family/data/mock_tracker_repository.dart';
import 'package:safetrack_family/features/hardware_setup.dart';
import 'package:safetrack_family/hardware/tracker_usb.dart';

class _Store implements DemoStore {
  final values = <String, String>{};
  @override
  String? read(String key) => values[key];
  @override
  void write(String key, String value) => values[key] = value;
}

class _FakeUsb implements TrackerUsb {
  _FakeUsb({this.supported = true});
  @override
  final bool supported;
  @override
  bool connected = false;

  @override
  Future<TrackerReply> connect() async {
    connected = true;
    return const TrackerReply(
      'status',
      device: TrackerDevice(
        firmware: '0.3.0-bench',
        name: 'Bench',
        configured: true,
        profileEnabled: true,
        modem: 'ready',
        network: 'registered',
        gnss: 'no_fix',
      ),
    );
  }

  @override
  Future<TrackerReply> request(String command, [String arguments = '']) async =>
      const TrackerReply('sms_rejected');

  @override
  Future<void> disconnect() async => connected = false;
}

Future<void> _open(WidgetTester tester, TrackerUsb usb) async {
  await tester.binding.setSurfaceSize(const Size(400, 850));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(SafeTrackApp());
  final nav = tester.state<NavigatorState>(find.byType(Navigator).first);
  nav.push(
    MaterialPageRoute<void>(
      builder: (_) => HardwareSetupScreen(transport: usb),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, String label) async {
  final found = find.text(label).last;
  await tester.ensureVisible(found);
  await tester.pumpAndSettle();
  await tester.tap(found);
  await tester.pumpAndSettle();
}

void main() {
  test(
    'international contact format accepts only bounded digits after plus',
    () {
      // Construct format-only values. No routable fixture is stored or used.
      final digits = '1${List.filled(7, '0').join()}';
      expect(isInternationalPhone('+$digits'), isTrue);
      for (final invalid in [
        digits,
        '+0$digits',
        '+$digits\n',
        '+1 00',
        '+$digits$digits',
      ]) {
        expect(isInternationalPhone(invalid), isFalse);
      }
      expect(isTrackerName('Стенд'), isTrue);
      expect(isTrackerName('x|y'), isFalse);
    },
  );

  test(
    'demo state and preferences restore without including device contact',
    () {
      final store = _Store();
      final first = MockTrackerRepository(store: store);
      first.changePreferences(battery: false, network: false);
      first.select(TrackerStatus.offline);
      final restored = MockTrackerRepository(store: store);
      expect(restored.status, TrackerStatus.offline);
      expect(restored.notifyBattery || restored.notifyNetwork, isFalse);
      expect(restored.startSos(), SosDemoState.offline);
      expect(store.values.values.single, isNot(contains('contact')));
      first.dispose();
      restored.dispose();
    },
  );

  test('status must identify the expected board and protocol', () {
    expect(
      TrackerReply.decode('{"code":"status","protocol":2}').code,
      'wrong_device',
    );
    expect(TrackerReply.decode('{"code":"sms_unknown"}').device, isNull);
  });

  testWidgets('unsupported browser offers local fallback', (tester) async {
    await _open(tester, _FakeUsb(supported: false));
    expect(find.textContaining('локальную утилиту'), findsOneWidget);
    expect(find.text('Выбрать USB-порт'), findsNothing);
  });

  testWidgets('device status is separate and SMS rejection stays visible', (
    tester,
  ) async {
    await _open(tester, _FakeUsb());
    await _tap(tester, 'Выбрать USB-порт');
    expect(find.text('USB подключён'), findsOneWidget);
    expect(find.text('0.3.0-bench'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Отправить тестовое SMS'), 250);
    await _tap(tester, 'Отправить тестовое SMS');
    expect(find.textContaining('SafeTrack bench test'), findsOneWidget);
    await _tap(tester, 'Подтвердить тестовое SMS');
    expect(
      find.text('Модем отклонил тестовое SMS.').hitTestable(),
      findsOneWidget,
    );
  });
}
