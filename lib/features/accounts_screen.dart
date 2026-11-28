import 'package:material_ui/material_ui.dart';

import '../app/design.dart';
import '../data/account_repository.dart';
import '../data/family_repository.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({
    super.key,
    required this.accounts,
    required this.families,
  });
  final AccountRepository? accounts;
  final FamilyRepository? families;

  @override
  Widget build(BuildContext context) {
    final account = accounts;
    final family = families;
    return Scaffold(
      appBar: AppBar(title: const Text('Family account')),
      body: SafeArea(
        child: account == null || family == null
            ? const PageList(
                children: [
                  SectionHeading(
                    'Account service unavailable',
                    'The local demo is available.',
                  ),
                ],
              )
            : ListenableBuilder(
                listenable: account,
                builder: (_, _) {
                  final id = account.userId;
                  return id == null || account.recovering
                      ? _SignIn(
                          key: ValueKey(account.recovering),
                          account: account,
                        )
                      : _Workspace(
                          key: ValueKey(id),
                          account: account,
                          repo: family,
                          id: id,
                        );
                },
              ),
      ),
    );
  }
}

enum _Mode { login, register, reset, recover }

class _SignIn extends StatefulWidget {
  const _SignIn({super.key, required this.account});
  final AccountRepository account;
  @override
  State<_SignIn> createState() => _SignInState();
}

class _SignInState extends State<_SignIn> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  _Mode mode = _Mode.login;
  bool busy = false;
  String? feedback;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void switchTo(_Mode next) => setState(() {
    mode = next;
    feedback = null;
    password.clear();
  });

  Future<void> submit(_Mode action) async {
    if (busy || form.currentState?.validate() != true) return;
    final address = email.text.trim();
    final pass = password.text;
    setState(() {
      busy = true;
      feedback = null;
    });
    try {
      switch (action) {
        case _Mode.login:
          await widget.account.login(address, pass);
        case _Mode.register:
          await widget.account.register(address, pass);
          feedback = 'Check your email for a confirmation link.';
        case _Mode.reset:
          await widget.account.reset(address);
          feedback = 'If this address has an account, a reset link will arrive by email.';
        case _Mode.recover:
          await widget.account.changePassword(pass);
      }
    } catch (_) {
      feedback = action == _Mode.login
          ? 'Sign-in failed. Check your connection, password and email confirmation.'
          : 'Could not complete the request. Check your connection and try again.';
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final action = widget.account.recovering ? _Mode.recover : mode;
    final title = switch (action) {
      _Mode.login => 'Sign in',
      _Mode.register => 'Create account',
      _Mode.reset => 'Send reset link',
      _Mode.recover => 'Set new password',
    };
    return PageList(
      children: [
        const SectionHeading(
          'Family accounts',
          'Manage your family and review sharing permissions.',
        ),
        Panel(
          child: Form(
            key: form,
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (action != _Mode.recover) ...[
                    TextFormField(
                      enabled: !busy,
                      controller: email,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      validator: (value) =>
                          _isEmail(value) ? null : 'Enter a valid email.',
                    ),
                    const SizedBox(height: SafeSpace.md),
                  ],
                  if (action != _Mode.reset) ...[
                    TextFormField(
                      enabled: !busy,
                      controller: password,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      autofillHints: [
                        action == _Mode.login
                            ? AutofillHints.password
                            : AutofillHints.newPassword,
                      ],
                      validator: (value) =>
                          (value?.length ?? 0) >=
                              (action == _Mode.login ? 1 : 8)
                          ? null
                          : (action == _Mode.login
                                ? 'Enter your password.'
                                : 'Use at least 8 characters.'),
                      onFieldSubmitted: (_) => submit(action),
                    ),
                    const SizedBox(height: SafeSpace.md),
                  ],
                  if (busy)
                    const LinearProgressIndicator(semanticsLabel: 'Working'),
                  if (feedback case final message?)
                    Padding(
                      padding: const EdgeInsets.only(bottom: SafeSpace.md),
                      child: Semantics(liveRegion: true, child: Text(message)),
                    ),
                  FilledButton(
                    onPressed: busy ? null : () => submit(action),
                    child: Text(title),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (action == _Mode.login)
          Wrap(
            children: [
              TextButton(
                onPressed: busy ? null : () => switchTo(_Mode.register),
                child: const Text('Create an account'),
              ),
              TextButton(
                onPressed: busy ? null : () => switchTo(_Mode.reset),
                child: const Text('Forgot password?'),
              ),
            ],
          )
        else if (action != _Mode.recover)
          TextButton(
            onPressed: busy ? null : () => switchTo(_Mode.login),
            child: const Text('Back to sign in'),
          ),
      ],
    );
  }
}

class _Workspace extends StatefulWidget {
  const _Workspace({
    super.key,
    required this.account,
    required this.repo,
    required this.id,
  });
  final AccountRepository account;
  final FamilyRepository repo;
  final String id;
  @override
  State<_Workspace> createState() => _WorkspaceState();
}

class _WorkspaceState extends State<_Workspace> {
  List<RecordData> families = [];
  List<RecordData> invites = [];
  List<RecordData> roster = [];
  String? selected;
  bool busy = true;
  bool failed = false;
  String? feedback;

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<void> reload() async {
    try {
      final data = await Future.wait([
        widget.repo.families(),
        widget.repo.invitations(),
      ]);
      final next = data.first;
      final family = next.any((row) => row['id'] == selected)
          ? selected
          : next.firstOrNull?['id'] as String?;
      final people = family == null
          ? <RecordData>[]
          : await widget.repo.members(family);
      if (mounted) {
        setState(() {
          families = next;
          invites = data.last;
          roster = people;
          selected = family;
          busy = false;
          failed = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          families = [];
          invites = [];
          roster = [];
          selected = null;
          busy = false;
          failed = true;
        });
      }
    }
  }

  Future<void> run(Future<void> Function() action, [String? success]) async {
    if (busy) return;
    setState(() {
      busy = true;
      feedback = null;
    });
    try {
      await action();
      feedback = success;
    } catch (_) {
      feedback =
          'Could not complete the request. Check your connection and access.';
    }
    if (mounted) await reload();
  }

  Future<void> input(String? family) async {
    final value = await showDialog<String>(
      context: context,
      builder: (_) => _EntryDialog(invitation: family != null),
    );
    if (!mounted || value == null) return;
    if (family == null) {
      await run(() => widget.repo.createFamily(value));
    } else {
      await run(
        () => widget.repo.invite(family, value),
        'Invitation added to the recipient’s account inbox.',
      );
    }
  }

  Future<void> revoke(String family, String member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revoke access?'),
        content: const Text(
          'This member will lose access to the family and its devices.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Revoke'),
          ),
        ],
      ),
    );
    if (mounted && confirmed == true) {
      await run(() => widget.repo.revoke(family, member));
    }
  }

  @override
  Widget build(BuildContext context) {
    final family = selected;
    final owner = roster.any(
      (person) => person['user_id'] == widget.id && person['role'] == 'owner',
    );
    return PageList(
      maxWidth: 720,
      children: [
        const SectionHeading(
          'Your families',
          'Approved members can view shared device status. Live location collection is off.',
        ),
        Wrap(
          spacing: SafeSpace.sm,
          children: [
            FilledButton(
              onPressed: busy || failed ? null : () => input(null),
              child: const Text('Create family'),
            ),
            TextButton(
              onPressed: busy ? null : () => run(() async {}),
              child: const Text('Refresh'),
            ),
            TextButton(
              onPressed: busy ? null : () => run(widget.account.logout),
              child: const Text('Sign out'),
            ),
          ],
        ),
        if (busy)
          const LinearProgressIndicator(semanticsLabel: 'Loading families'),
        if (failed)
          const DemoNotice(
            'Family data is unavailable. Check your network and select Refresh.',
          ),
        if (feedback case final message?)
          Semantics(liveRegion: true, child: Text(message)),
        const SizedBox(height: SafeSpace.md),
        if (invites.isNotEmpty) ...[
          Text('Invitations', style: context.type.titleLarge),
          for (final invite in invites)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: SafeSpace.xs),
              child: Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invite['family_name'] as String,
                      style: context.type.bodyLarge,
                    ),
                    const Text(
                      'Only accept an invitation from a family you trust.',
                    ),
                    Wrap(
                      spacing: SafeSpace.sm,
                      children: [
                        FilledButton(
                          onPressed: busy
                              ? null
                              : () => run(
                                  () => widget.repo.respond(
                                    invite['id'] as String,
                                    true,
                                  ),
                                ),
                          child: const Text('Accept'),
                        ),
                        TextButton(
                          onPressed: busy
                              ? null
                              : () => run(
                                  () => widget.repo.respond(
                                    invite['id'] as String,
                                    false,
                                  ),
                                ),
                          child: const Text('Decline'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
        if (!failed && !busy && families.isEmpty)
          const Text(
            'Your families and incoming invitations will appear here.',
          ),
        if (family != null) ...[
          DropdownButtonFormField<String>(
            key: ValueKey(family),
            initialValue: family,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Family'),
            items: [
              for (final row in families)
                DropdownMenuItem(
                  value: row['id'] as String,
                  child: Text(
                    row['name'] as String,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: busy
                ? null
                : (value) {
                    if (value != null) {
                      run(() async {
                        selected = value;
                        roster = [];
                      });
                    }
                  },
          ),
          const SizedBox(height: SafeSpace.md),
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Members', style: context.type.titleLarge),
                for (final person in roster)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.person_outline),
                    title: Text(
                      person['user_id'] == widget.id
                          ? 'You'
                          : (person['label'] as String),
                    ),
                    subtitle: Text(
                      person['role'] == 'owner'
                          ? 'Owner · manages access'
                          : 'Member · views shared device status',
                    ),
                    trailing: owner && person['role'] == 'member'
                        ? IconButton(
                            tooltip: 'Revoke member access',
                            icon: const Icon(Icons.person_remove_outlined),
                            onPressed: busy
                                ? null
                                : () => revoke(
                                    family,
                                    person['user_id'] as String,
                                  ),
                          )
                        : null,
                  ),
                if (owner)
                  OutlinedButton(
                    onPressed: busy ? null : () => input(family),
                    child: const Text('Invite a member'),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

bool _isEmail(String? value) {
  final address = value?.trim() ?? '';
  return address.length <= 254 &&
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(address);
}

class _EntryDialog extends StatefulWidget {
  const _EntryDialog({required this.invitation});
  final bool invitation;
  @override
  State<_EntryDialog> createState() => _EntryDialogState();
}

class _EntryDialogState extends State<_EntryDialog> {
  final controller = TextEditingController();
  final form = GlobalKey<FormState>();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    scrollable: true,
    title: Text(widget.invitation ? 'Invite a member' : 'Create family'),
    content: Form(
      key: form,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: widget.invitation ? 'Recipient email' : 'Family name',
        ),
        keyboardType: widget.invitation
            ? TextInputType.emailAddress
            : TextInputType.text,
        maxLength: widget.invitation ? 254 : 80,
        validator: (value) => widget.invitation
            ? (_isEmail(value) ? null : 'Enter a valid email.')
            : ((value?.trim().isNotEmpty ?? false)
                  ? null
                  : 'Enter a family name.'),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () {
          if (form.currentState?.validate() == true) {
            Navigator.pop(context, controller.text.trim());
          }
        },
        child: Text(widget.invitation ? 'Create invitation' : 'Create family'),
      ),
    ],
  );
}
