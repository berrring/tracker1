import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'data/account_repository.dart';
import 'data/family_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const url = String.fromEnvironment('SUPABASE_URL');
  const key = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
  SupabaseClient? client;
  if (Uri.tryParse(url)?.scheme == 'https' &&
      key.startsWith('sb_publishable_')) {
    try {
      await Supabase.initialize(url: url, publishableKey: key);
      client = Supabase.instance.client;
    } catch (_) {
      // The local demo remains available if account startup fails.
    }
  }
  runApp(
    SafeTrackApp(
      interactiveMaps: true,
      accounts: client == null ? null : SupabaseAccountRepository(client),
      families: client == null ? null : SupabaseFamilyRepository(client),
    ),
  );
}
