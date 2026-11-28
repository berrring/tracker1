import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:safetrack_family/app/design.dart';
import 'package:safetrack_family/data/account_repository.dart';
import 'package:safetrack_family/data/family_repository.dart';
import 'package:safetrack_family/features/accounts_screen.dart';

class _Account extends ChangeNotifier implements AccountRepository {
  @override
  bool available = true;
  @override
  bool recovering = false;
  @override
  String? userId;
  bool offline = false;
  String? registration;
  String? resetAddress;
  String? newPassword;

  @override
  Future<void> login(String email, String password) async {
    if (offline) throw StateError('offline');
    userId = 'owner';
    notifyListeners();
  }

  @override
  Future<void> register(String email, String password) async =>
      registration = email;

  @override
  Future<void> reset(String email) async => resetAddress = email;

  @override
  Future<void> changePassword(String password) async {
    newPassword = password;
    recovering = false;
    notifyListeners();
  }

  @override
  Future<void> logout() async {
    userId = null;
    notifyListeners();
  }
}

class _Family implements FamilyRepository {
  final List<RecordData> groups = [];
  final List<RecordData> inbox = [
    {'id': 'incoming', 'family_name': 'Fixture parents'},
    {'id': 'other', 'family_name': 'Fixture cousins'},
  ];
  final List<RecordData> people = [
    {'user_id': 'owner', 'role': 'owner', 'label': 'Owner'},
    {'user_id': 'other-user', 'role': 'member', 'label': 'Fixture member'},
  ];
  final List<bool> responses = [];
  String? invited;
  bool offline = false;

  @override
  Future<List<RecordData>> families() async {
    if (offline) throw StateError('offline');
    return [...groups];
  }

  @override
  Future<List<RecordData>> invitations() async => [...inbox];
  @override
  Future<List<RecordData>> members(String familyId) async => [...people];
  @override
  Future<void> createFamily(String name) async =>
      groups.add({'id': 'family', 'name': name});
  @override
  Future<void> invite(String familyId, String email) async => invited = email;
  @override
  Future<void> respond(String inviteId, bool accept) async {
    inbox.removeWhere((row) => row['id'] == inviteId);
    responses.add(accept);
  }

  @override
  Future<void> revoke(String familyId, String userId) async =>
      people.removeWhere((row) => row['user_id'] == userId);
}

Future<void> tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _show(WidgetTester tester, _Account account, _Family repo) async {
  await tester.binding.setSurfaceSize(const Size(560, 1100));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      theme: familyTheme(),
      home: AccountsScreen(accounts: account, families: repo),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  const email = 'fixture@example.invalid';
  const password = 'test fixture password';

  testWidgets('login gates the family workspace and handles offline errors', (
    tester,
  ) async {
    final account = _Account()..offline = true;
    await _show(tester, account, _Family());
    expect(find.text('Your families'), findsNothing);
    await tester.enterText(find.byType(TextFormField).first, email);
    await tester.enterText(find.byType(TextFormField).last, password);
    await tap(tester, find.text('Sign in'));
    expect(find.textContaining('Sign-in failed'), findsOneWidget);
    account.offline = false;
    await tap(tester, find.text('Sign in'));
    expect(find.text('Your families'), findsOneWidget);
    await tap(tester, find.text('Sign out'));
    expect(find.text('Your families'), findsNothing);
  });

  testWidgets('registration, reset and recovery keep the workspace protected', (
    tester,
  ) async {
    final account = _Account();
    final repo = _Family();
    await _show(tester, account, repo);
    await tap(tester, find.text('Create an account'));
    await tester.enterText(find.byType(TextFormField).first, email);
    await tester.enterText(find.byType(TextFormField).last, password);
    await tap(tester, find.text('Create account'));
    expect(account.registration, email);
    expect(find.textContaining('confirmation link'), findsOneWidget);
    await tap(tester, find.text('Back to sign in'));
    await tap(tester, find.text('Forgot password?'));
    await tap(tester, find.text('Send reset link'));
    expect(account.resetAddress, email);
    account.userId = 'owner';
    account.recovering = true;
    account.notifyListeners();
    await tester.pumpAndSettle();
    expect(find.text('Your families'), findsNothing);
    await tester.enterText(find.byType(TextFormField), password);
    await tap(tester, find.text('Set new password'));
    expect(account.newPassword, password);
    expect(find.text('Your families'), findsOneWidget);
  });

  testWidgets('restored identity sees the family workspace and owner actions', (
    tester,
  ) async {
    final repo = _Family();
    await _show(tester, _Account()..userId = 'owner', repo);
    await tap(tester, find.text('Accept').first);
    await tap(tester, find.text('Decline'));
    expect(repo.responses, [true, false]);
    await tap(tester, find.text('Create family'));
    await tester.enterText(find.byType(TextFormField), 'Fixture family');
    await tap(tester, find.widgetWithText(FilledButton, 'Create family').last);
    expect(find.text('Fixture family'), findsOneWidget);
    await tap(tester, find.text('Invite a member'));
    await tester.enterText(find.byType(TextFormField), email);
    await tap(tester, find.text('Create invitation'));
    expect(repo.invited, email);
    await tap(tester, find.byTooltip('Revoke member access'));
    await tap(tester, find.text('Revoke'));
    expect(find.text('Fixture member'), findsNothing);
    repo.offline = true;
    await tap(tester, find.text('Refresh'));
    expect(find.textContaining('Family data is unavailable'), findsOneWidget);
    expect(find.text('Fixture family'), findsNothing);
  });
}
