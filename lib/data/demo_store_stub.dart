import 'demo_store.dart';

DemoStore createDemoStore() => _SessionStore();

class _SessionStore implements DemoStore {
  final _values = <String, String>{};

  @override
  String? read(String key) => _values[key];

  @override
  void write(String key, String value) => _values[key] = value;
}
