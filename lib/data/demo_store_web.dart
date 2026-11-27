import 'dart:js_interop';

import 'demo_store.dart';

@JS('localStorage')
external _Storage get _localStorage;

extension type _Storage(JSObject _) implements JSObject {
  external String? getItem(String key);
  external void setItem(String key, String value);
}

DemoStore createDemoStore() => _BrowserStore();

class _BrowserStore implements DemoStore {
  static const _prefix = 'safetrack.demo.v1.';

  @override
  String? read(String key) {
    try {
      return _localStorage.getItem('$_prefix$key');
    } catch (_) {
      return null;
    }
  }

  @override
  void write(String key, String value) {
    try {
      _localStorage.setItem('$_prefix$key', value);
    } catch (_) {
      // The current session works when browser storage is disabled.
    }
  }
}
