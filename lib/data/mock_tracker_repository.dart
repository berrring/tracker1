import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'demo_store.dart';

enum TrackerStatus {
  fresh,
  stale,
  offline,
  lowBattery,
  sos,
  loading,
  empty,
  unavailable,
  error,
}

enum SosDemoState { ready, preparing, sending, acknowledged, offline }

enum FamilyRole { owner, adult, wearer }

enum SafetyEvent { update, lost, restored, battery, sos }

class LocationSample {
  const LocationSample(this.x, this.y, this.accuracy, this.age);
  // Position in an invented local map, measured as fractions of its bounds.
  final double x;
  final double y;
  final int accuracy;
  final Duration age;

  bool get isStale => age >= const Duration(minutes: 5);
}

class MockTrackerRepository extends ChangeNotifier {
  MockTrackerRepository({DemoStore? store}) : _store = store {
    final saved = store?.read('tracker');
    if (saved == null) return;
    try {
      final data = jsonDecode(saved);
      if (data is! Map<String, dynamic>) return;
      _status = TrackerStatus.values.firstWhere(
        (status) => status.name == data['status'],
        orElse: () => TrackerStatus.fresh,
      );
      _notifyBattery = data['notifyBattery'] != false;
      _notifyNetwork = data['notifyNetwork'] != false;
      _sosAcknowledged = data['sosAcknowledged'] == true;
    } on FormatException {
      // Invalid browser data falls back to the initial demonstration.
    }
  }

  final DemoStore? _store;
  static const trackerId = 'ST-DEMO-042';
  static const pairingCode = 'DEMO-042';

  TrackerStatus _status = TrackerStatus.fresh;
  bool _notifyBattery = true;
  bool _notifyNetwork = true;
  bool _sosAcknowledged = false;

  TrackerStatus get status => _status;
  bool get notifyBattery => _notifyBattery;
  bool get notifyNetwork => _notifyNetwork;
  bool get sosAcknowledged => _sosAcknowledged;
  bool get hasTracker => _status != TrackerStatus.empty;
  bool get hasDeviceData =>
      hasTracker &&
      _status != TrackerStatus.loading &&
      _status != TrackerStatus.error;
  bool get isOffline => _status == TrackerStatus.offline;
  bool get canTestSos => hasDeviceData;
  int? get battery =>
      hasDeviceData ? (_status == TrackerStatus.lowBattery ? 18 : 82) : null;

  LocationSample? get location => switch (_status) {
    TrackerStatus.stale => const LocationSample(
      .44,
      .48,
      32,
      Duration(minutes: 24),
    ),
    TrackerStatus.offline => const LocationSample(
      .59,
      .43,
      24,
      Duration(minutes: 12),
    ),
    TrackerStatus.fresh || TrackerStatus.lowBattery || TrackerStatus.sos =>
      const LocationSample(.52, .44, 18, Duration(seconds: 24)),
    _ => null,
  };

  void select(TrackerStatus value) {
    _status = value;
    _save();
  }

  bool isPairingCodeValid(String code) =>
      code.trim().toUpperCase() == pairingCode;

  bool pair(String code) {
    if (!isPairingCodeValid(code)) return false;
    select(TrackerStatus.fresh);
    return true;
  }

  void remove() {
    _sosAcknowledged = false;
    select(TrackerStatus.empty);
  }

  SosDemoState startSos() =>
      !canTestSos || isOffline ? SosDemoState.offline : SosDemoState.preparing;

  SosDemoState advanceSos(SosDemoState current) {
    if (!canTestSos || isOffline) return SosDemoState.offline;
    if (current == SosDemoState.preparing) return SosDemoState.sending;
    if (current == SosDemoState.sending) {
      _sosAcknowledged = true;
      _save();
      return SosDemoState.acknowledged;
    }
    return current;
  }

  void changePreferences({bool? battery, bool? network}) {
    _notifyBattery = battery ?? _notifyBattery;
    _notifyNetwork = network ?? _notifyNetwork;
    _save();
  }

  void _save() {
    _store?.write(
      'tracker',
      jsonEncode({
        'status': _status.name,
        'notifyBattery': _notifyBattery,
        'notifyNetwork': _notifyNetwork,
        'sosAcknowledged': _sosAcknowledged,
      }),
    );
    notifyListeners();
  }
}
