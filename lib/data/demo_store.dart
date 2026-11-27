import 'demo_store_stub.dart'
    if (dart.library.js_interop) 'demo_store_web.dart'
    as platform;

abstract interface class DemoStore {
  String? read(String key);
  void write(String key, String value);
}

DemoStore browserDemoStore() => platform.createDemoStore();
