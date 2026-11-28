import 'package:material_ui/material_ui.dart';

import '../app/design.dart';
import '../data/mock_tracker_repository.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key, required this.onPair, this.onAccount});
  final VoidCallback onPair;
  final VoidCallback? onAccount;

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final members = [
      (s.aigul, s.owner, s.ownerAccess, FamilyRole.owner, 'А'),
      (s.timur, s.adult, s.adultAccess, FamilyRole.adult, 'Т'),
      (s.ayan, s.wearer, s.wearerAccess, FamilyRole.wearer, 'А'),
    ];
    return PageList(
      maxWidth: 780,
      storageKey: const PageStorageKey('family'),
      children: [
        SectionHeading(s.access, s.accessIntro),
        Panel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (final (index, member) in members.indexed) ...[
                if (index != 0)
                  const Divider(height: 1, indent: 64, endIndent: 16),
                Builder(
                  builder: (context) {
                    final (name, role, summary, kind, initial) = member;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: SafeSpace.lg,
                        vertical: SafeSpace.sm,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: kind == FamilyRole.adult
                            ? surfaceVariant
                            : primaryContainer,
                        foregroundColor: primary,
                        child: Text(initial),
                      ),
                      title: Text(name, style: context.type.titleLarge),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(role),
                          if (kind == FamilyRole.adult)
                            Text(s.invited, style: context.type.labelMedium),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => showModalBottomSheet<void>(
                        context: context,
                        useSafeArea: true,
                        showDragHandle: true,
                        isScrollControlled: true,
                        builder: (context) => SafeArea(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SectionHeading(name, role),
                                Text(
                                  s.profileAccess,
                                  style: context.type.titleLarge,
                                ),
                                const SizedBox(height: SafeSpace.sm),
                                Text(summary, style: context.type.bodyLarge),
                                const SizedBox(height: SafeSpace.md),
                                Text(
                                  kind == FamilyRole.adult
                                      ? s.invited
                                      : s.active,
                                ),
                                const SizedBox(height: SafeSpace.md),
                                OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(s.close),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: SafeSpace.md),
        Text(s.demoFamilyNote),
        const SizedBox(height: SafeSpace.lg),
        if (onAccount != null)
          Padding(
            padding: const EdgeInsets.only(bottom: SafeSpace.md),
            child: OutlinedButton.icon(
              onPressed: onAccount,
              icon: const Icon(Icons.account_circle_outlined),
              label: Text(
                Localizations.localeOf(context).languageCode == 'en'
                    ? 'Family account'
                    : 'Семейный аккаунт',
              ),
            ),
          ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: FilledButton.icon(
            onPressed: onPair,
            icon: const Icon(SafeIcons.addTracker),
            label: Text(s.add),
          ),
        ),
      ],
    );
  }
}

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key, required this.repo});
  final MockTrackerRepository repo;

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final items = [
      (
        SafetyEvent.update,
        '14:32',
        s.updated,
        s.updatedDetail,
        Icons.location_on_outlined,
        primary,
      ),
      (
        SafetyEvent.lost,
        '13:58',
        s.lost,
        s.lostDetail,
        Icons.cloud_off_outlined,
        warning,
      ),
      (
        SafetyEvent.restored,
        '13:51',
        s.restored,
        s.restoredDetail,
        SafeIcons.network,
        success,
      ),
      (
        SafetyEvent.battery,
        '08:14',
        s.chargeEvent,
        s.chargeDetail,
        SafeIcons.batteryAlert,
        warning,
      ),
      (
        SafetyEvent.sos,
        '18:44',
        s.sosEvent,
        s.sosEventDetail,
        SafeIcons.sos,
        danger,
      ),
    ];
    final status = repo.status;
    final showSaved =
        status != TrackerStatus.empty && status != TrackerStatus.loading;
    return PageList(
      storageKey: const PageStorageKey('events'),
      maxWidth: 820,
      children: [
        SectionHeading(s.feed, s.feedIntro),
        if (status == TrackerStatus.empty ||
            status == TrackerStatus.loading ||
            status == TrackerStatus.error ||
            repo.isOffline) ...[
          StatusPanel(
            status,
            action: status == TrackerStatus.error || repo.isOffline
                ? Text(s.savedEvents)
                : null,
          ),
          const SizedBox(height: SafeSpace.lg),
        ],
        if (showSaved) ...[
          Text(s.today, style: context.type.titleLarge),
          const SizedBox(height: SafeSpace.sm),
          Panel(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                if (repo.sosAcknowledged) ...[
                  _EventCard(
                    s.demoEventTime,
                    s.demoSuccess,
                    s.sosEventDetail,
                    SafeIcons.sos,
                    danger,
                    isSos: true,
                  ),
                  const Divider(height: 1, indent: 62),
                ],
                for (final (index, item) in items.indexed)
                  if (item.$1 != SafetyEvent.sos) ...[
                    if (index > 0) const Divider(height: 1, indent: 62),
                    _EventCard(item.$2, item.$3, item.$4, item.$5, item.$6),
                  ],
              ],
            ),
          ),
          const SizedBox(height: SafeSpace.lg),
          Text(s.yesterday, style: context.type.titleLarge),
          const SizedBox(height: SafeSpace.sm),
          Panel(
            padding: EdgeInsets.zero,
            child: _EventCard(
              items.last.$2,
              items.last.$3,
              items.last.$4,
              items.last.$5,
              items.last.$6,
              isSos: true,
            ),
          ),
        ],
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard(
    this.time,
    this.title,
    this.detail,
    this.icon,
    this.color, {
    this.isSos = false,
  });
  final String time;
  final String title;
  final String detail;
  final IconData icon;
  final Color color;
  final bool isSos;

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: SafeSpace.lg,
        vertical: SafeSpace.xs,
      ),
      leading: CircleAvatar(
        radius: 17,
        backgroundColor: color.withValues(alpha: .10),
        foregroundColor: color,
        child: Icon(icon, size: 19),
      ),
      title: Text(
        title,
        style: context.type.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(detail),
      trailing: isSos
          ? const Icon(Icons.chevron_right_rounded)
          : Text(time, style: context.type.labelMedium?.copyWith(color: muted)),
      onTap: isSos
          ? () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              useSafeArea: true,
              isScrollControlled: true,
              builder: (context) => SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SectionHeading(s.timelineSos, time),
                      Text(title, style: context.type.titleLarge),
                      const SizedBox(height: SafeSpace.sm),
                      Text(detail),
                      const SizedBox(height: SafeSpace.lg),
                      DemoNotice(s.sosWarning),
                      const SizedBox(height: SafeSpace.md),
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(s.close),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class PairingDialog extends StatefulWidget {
  const PairingDialog({super.key, required this.repo});
  final MockTrackerRepository repo;

  @override
  State<PairingDialog> createState() => _PairingDialogState();
}

class _PairingDialogState extends State<PairingDialog> {
  final code = TextEditingController();
  bool reviewing = false;
  bool invalid = false;

  @override
  void dispose() {
    code.dispose();
    super.dispose();
  }

  void review() {
    final valid = widget.repo.isPairingCodeValid(code.text);
    if (valid) FocusScope.of(context).unfocus();
    setState(() {
      invalid = !valid;
      reviewing = valid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    return AlertDialog(
      scrollable: true,
      title: Text(reviewing ? s.pairReview : s.add),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (reviewing) ...[
            Text(s.tracker, style: context.type.titleLarge),
            const SizedBox(height: SafeSpace.sm),
            Text(s.pairAccess),
          ] else ...[
            if (widget.repo.hasTracker) ...[
              Text(s.pairAlready),
              const SizedBox(height: SafeSpace.md),
            ],
            Text(s.pairCode),
            SelectionArea(
              child: Text(
                MockTrackerRepository.pairingCode,
                style: context.type.headlineSmall,
              ),
            ),
            const SizedBox(height: SafeSpace.sm),
            Text(s.pairInstructions),
            const SizedBox(height: SafeSpace.md),
            TextField(
              controller: code,
              textCapitalization: TextCapitalization.characters,
              autocorrect: false,
              enableSuggestions: false,
              autofillHints: null,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => review(),
              decoration: InputDecoration(
                labelText: s.codeField,
                errorText: invalid ? s.badCode : null,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(s.cancel),
        ),
        FilledButton(
          onPressed: reviewing
              ? () {
                  if (widget.repo.pair(code.text)) Navigator.pop(context, true);
                }
              : review,
          child: Text(reviewing ? s.confirmPair : s.next),
        ),
      ],
    );
  }
}
