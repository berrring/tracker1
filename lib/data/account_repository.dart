import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AccountRepository implements Listenable {
  String? get userId;
  bool get recovering;
  bool get available;
  Future<void> login(String email, String password);
  Future<void> register(String email, String password);
  Future<void> reset(String email);
  Future<void> changePassword(String password);
  Future<void> logout();
}

class SupabaseAccountRepository extends ChangeNotifier
    implements AccountRepository {
  SupabaseAccountRepository(this.client) {
    client.auth.onAuthStateChange.listen(
      (message) {
        if (message.event == AuthChangeEvent.passwordRecovery) {
          _recovering = true;
        }
        if (message.event == AuthChangeEvent.signedOut) _recovering = false;
        notifyListeners();
      },
      onError: (Object _) {
        notifyListeners();
      },
    );
  }

  static const nativeRedirect = 'com.safetrack.family://account';
  static const webRedirect = 'https://tracker1-six.vercel.app/?account=1';

  final SupabaseClient client;
  bool _recovering = false;

  String get redirect => kIsWeb
      ? (Uri.base.host == 'localhost' || Uri.base.host == '127.0.0.1')
            ? Uri.base
                  .replace(path: '/', query: 'account=1', fragment: '')
                  .toString()
            : webRedirect
      : nativeRedirect;

  @override
  bool get recovering => _recovering;

  @override
  bool get available => true;

  @override
  String? get userId => client.auth.currentUser?.id;

  @override
  Future<void> login(String email, String password) async {
    await client.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> register(String email, String password) async {
    await client.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: redirect,
    );
  }

  @override
  Future<void> reset(String email) =>
      client.auth.resetPasswordForEmail(email, redirectTo: redirect);

  @override
  Future<void> changePassword(String password) async {
    await client.auth.updateUser(UserAttributes(password: password));
    _recovering = false;
    notifyListeners();
  }

  @override
  Future<void> logout() => client.auth.signOut();
}
