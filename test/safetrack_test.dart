import 'package:material_ui/material_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safetrack_family/app/app.dart';
import 'package:safetrack_family/data/mock_tracker_repository.dart';

Future<void> openApp(WidgetTester tester, MockTrackerRepository repo) async {
  await tester.binding.setSurfaceSize(const Size(420, 880));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(SafeTrackApp(repository: repo));
  await tester.pumpAndSettle();
}

Future<void> tap(WidgetTester tester, Finder target) async {
  await tester.ensureVisible(target);
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Finder nav(String label) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

void main() {
  testWidgets('wide screens leave room for the app title', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 720);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const SafeTrackApp());
    await tester.pumpAndSettle();
    expect(
      tester.getSize(find.text('SafeTrack Family')).width,
      greaterThan(160),
    );
    expect(find.byType(NavigationBar), findsNothing);
    expect(
      tester.getSize(find.byKey(const ValueKey('desktop-sidebar'))).width,
      248,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('dashboard-map'))).width,
      greaterThan(600),
    );
  });

  testWidgets('family and SOS details clarify sharing and simulation', (
    tester,
  ) async {
    final repo = MockTrackerRepository();
    await openApp(tester, repo);
    await tap(tester, nav('Семья'));
    await tap(tester, find.text('Тимур'));
    expect(find.text('Доступ к геопозиции'), findsOneWidget);
    expect(find.textContaining('После принятия приглашения'), findsOneWidget);
    await tap(tester, find.text('Закрыть'));

    await tap(tester, nav('События'));
    await tester.scrollUntilVisible(
      find.text('Тестовый SOS подтверждён'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tap(tester, find.text('Тестовый SOS подтверждён'));
    expect(find.text('Детали события SOS'), findsOneWidget);
    expect(find.textContaining('демонстрационный сценарий'), findsOneWidget);
  });

  testWidgets('system back returns to the map before leaving the shell', (
    tester,
  ) async {
    await openApp(tester, MockTrackerRepository());
    await tap(tester, nav('Устройство'));
    expect(find.text('ST-DEMO-042'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Последние известные данные'), findsOneWidget);
  });

  testWidgets('compact iOS layout keeps the tracker selector operable', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    try {
      await tester.binding.setSurfaceSize(const Size(320, 650));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      tester.platformDispatcher.textScaleFactorTestValue = 1.8;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(const SafeTrackApp());
      await tester.pumpAndSettle();
      await tap(tester, find.text('Трекер Аяна'));
      expect(find.text('Трекеры семьи'), findsOneWidget);
      await tap(tester, find.text('Добавить устройство'));
      expect(find.text('Демонстрационный код'), findsOneWidget);
      expect(find.text(MockTrackerRepository.pairingCode), findsOneWidget);
      expect(tester.takeException(), isNull);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  test(
    'mock snapshots update deterministically and classify stale positions',
    () {
      final repo = MockTrackerRepository();
      expect(repo.location?.isStale, false);
      expect(repo.battery, 82);
      repo.select(TrackerStatus.stale);
      expect(repo.location?.isStale, true);
      expect(repo.location?.accuracy, 32);
      repo.select(TrackerStatus.lowBattery);
      expect(repo.battery, 18);
      repo.remove();
      expect(repo.location, isNull);
      expect(repo.pair('wrong'), false);
      expect(repo.hasTracker, false);
      expect(repo.pair(' demo-042 '), true);
      expect(repo.status, TrackerStatus.fresh);
      repo.dispose();
    },
  );

  test('loss of connectivity during SOS prevents acknowledgement', () {
    final repo = MockTrackerRepository();
    final sending = repo.advanceSos(repo.startSos());
    expect(sending, SosDemoState.sending);
    repo.select(TrackerStatus.offline);
    expect(repo.advanceSos(sending), SosDemoState.offline);
    expect(repo.sosAcknowledged, false);
    repo.dispose();
  });

  testWidgets('initial map reports last position and tabs expose key content', (
    tester,
  ) async {
    await openApp(tester, MockTrackerRepository());
    expect(find.byType(NavigationDestination), findsNWidgets(4));
    expect(find.widgetWithText(NavigationDestination, 'Карта'), findsOneWidget);
    for (final label in ['Сегодня, 14:32', '±18 м', '82%', 'В сети · LTE']) {
      expect(find.text(label), findsOneWidget);
    }
    await tap(tester, nav('События'));
    expect(find.text('Координаты обновлены'), findsOneWidget);
    await tap(tester, nav('Семья'));
    for (final role in [
      'Владелец семьи',
      'Доверенный взрослый',
      'Ребёнок / носитель трекера',
    ]) {
      expect(find.text(role), findsOneWidget);
    }
    await tap(tester, nav('Устройство'));
    expect(find.text('ST-DEMO-042'), findsOneWidget);
  });

  testWidgets('device menu drives the offline map and offline SOS result', (
    tester,
  ) async {
    final repo = MockTrackerRepository();
    await openApp(tester, repo);
    await tap(tester, nav('Устройство'));
    await tap(tester, find.byType(DropdownButtonFormField<TrackerStatus>));
    await tap(tester, find.text('Нет связи').last);
    expect(repo.status, TrackerStatus.offline);
    await tap(tester, nav('Карта'));
    expect(find.text('Сегодня, 14:20'), findsOneWidget);
    await tap(tester, nav('Устройство'));
    await tap(tester, find.text('Тестовый SOS'));
    expect(
      find.text(
        'Это демонстрационный сценарий. Реальный сигнал никому не отправляется.',
      ),
      findsOneWidget,
    );
    await tap(tester, find.text('Запустить демонстрацию SOS'));
    expect(
      find.text('Последняя связь с устройством: 12 мин назад.'),
      findsOneWidget,
    );
    expect(find.text('SOS не подтверждён.'), findsOneWidget);
    expect(
      find.text('Нет данных, подтверждающих доставку сигнала.'),
      findsOneWidget,
    );
    expect(find.text('Демо-SOS подтверждён'), findsNothing);
  });

  testWidgets('connected SOS shows timed progress and explicit simulation', (
    tester,
  ) async {
    await openApp(tester, MockTrackerRepository());
    await tap(tester, nav('Устройство'));
    await tap(tester, find.text('Тестовый SOS'));
    await tester.tap(find.text('Запустить демонстрацию SOS'));
    await tester.pump();
    expect(find.text('Подготовка'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 750));
    expect(find.text('Отправка'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 750));
    await tester.pumpAndSettle();
    expect(find.text('Демо-SOS подтверждён'), findsOneWidget);
    expect(
      find.text(
        'Это только симуляция интерфейса. Реальное сообщение не отправлялось.',
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'pairing validates the code and changes state only after access review',
    (tester) async {
      final repo = MockTrackerRepository()..remove();
      await openApp(tester, repo);
      await tap(tester, find.text('Добавить устройство'));
      await tap(tester, find.text('Продолжить'));
      expect(find.text('Проверьте демонстрационный код.'), findsOneWidget);
      await tester.enterText(
        find.byType(TextField),
        MockTrackerRepository.pairingCode,
      );
      await tap(tester, find.text('Продолжить'));
      expect(find.text('Проверьте права доступа'), findsOneWidget);
      expect(find.textContaining('Тимур получит доступ'), findsOneWidget);
      expect(repo.hasTracker, false);
      await tap(tester, find.text('Подтвердить подключение'));
      expect(repo.hasTracker, true);
    },
  );

  testWidgets('loading, empty, unavailable and error have visible fallbacks', (
    tester,
  ) async {
    final repo = MockTrackerRepository();
    await openApp(tester, repo);
    for (final (state, label) in [
      (TrackerStatus.loading, 'Загрузка данных'),
      (TrackerStatus.empty, 'Трекер не подключён'),
      (TrackerStatus.unavailable, 'Позиция недоступна'),
      (TrackerStatus.error, 'Не удалось загрузить данные'),
    ]) {
      repo.select(state);
      await tester.pump();
      expect(find.text(label), findsWidgets);
    }
    await tap(tester, find.text('Повторить'));
    expect(find.text('±18 м'), findsOneWidget);
  });

  testWidgets('locale switch updates content and navigation', (tester) async {
    await openApp(tester, MockTrackerRepository());
    await tap(tester, find.byTooltip('Язык интерфейса'));
    await tap(tester, find.text('English'));
    expect(find.text('Last known location'), findsOneWidget);
    expect(nav('Device'), findsOneWidget);
  });

  testWidgets(
    'map meets accessibility guidelines for targets, labels and contrast',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await openApp(tester, MockTrackerRepository());
        expect(find.byTooltip('На последнее местоположение'), findsOneWidget);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      } finally {
        semantics.dispose();
      }
    },
  );

  testWidgets('large text preserves layout on a compact screen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 740));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const SafeTrackApp());
    await tester.pumpAndSettle();
    for (final label in ['События', 'Семья', 'Устройство', 'Карта']) {
      await tap(tester, nav(label));
      expect(tester.takeException(), isNull);
    }
  });
}
