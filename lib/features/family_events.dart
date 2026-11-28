import 'package:material_ui/material_ui.dart';

import '../app/design.dart';
import '../data/mock_tracker_repository.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key, required this.onPair});
  final VoidCallback onPair;

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final members = [
      (s.aigul, s.owner, s.ownerAccess, FamilyRole.owner),
      (s.timur, s.adult, s.adultAccess, FamilyRole.adult),
      (s.ayan, s.wearer, s.wearerAccess, FamilyRole.wearer),
    ];
    return PageList(
      storageKey: const PageStorageKey('family'),
      children: [
        SectionHeading(s.access, s.accessIntro),
        Text(s.demoFamilyNote),
        const SizedBox(height: SafeSpace.md),
        for (final (name, role, summary, kind) in members) ...[
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: primaryContainer,
                      foregroundColor: primary,
                      child: Icon(switch (kind) {
                        FamilyRole.owner => Icons.admin_panel_settings_outlined,
                        FamilyRole.adult => SafeIcons.person,
                        FamilyRole.wearer => SafeIcons.tracker,
                      }),
                    ),
                    const SizedBox(width: SafeSpace.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: context.type.titleLarge),
                          Text(role),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SafeSpace.md),
                Text(summary, style: context.type.bodyLarge),
                const SizedBox(height: SafeSpace.sm),
                Tag(
                  kind == FamilyRole.adult ? s.invited : s.active,
                  kind == FamilyRole.adult
                      ? Icons.mail_outline
                      : SafeIcons.success,
                ),
              ],
            ),
          ),
          const SizedBox(height: SafeSpace.md),
        ],
        FilledButton.icon(
          onPressed: onPair,
          icon: const Icon(SafeIcons.addTracker),
          label: Text(s.add),
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
        s.info,
        primary,
      ),
      (
        SafetyEvent.lost,
        '13:58',
        s.lost,
        s.lostDetail,
        Icons.cloud_off_outlined,
        s.attention,
        warning,
      ),
      (
        SafetyEvent.restored,
        '13:51',
        s.restored,
        s.restoredDetail,
        SafeIcons.network,
        s.ok,
        success,
      ),
      (
        SafetyEvent.battery,
        '08:14',
        s.chargeEvent,
        s.chargeDetail,
        SafeIcons.batteryAlert,
        s.attention,
        warning,
      ),
      (
        SafetyEvent.sos,
        '18:44',
        s.sosEvent,
        s.sosEventDetail,
        SafeIcons.sos,
        s.demo,
        danger,
      ),
    ];
    final status = repo.status;
    final showSaved =
        status != TrackerStatus.empty && status != TrackerStatus.loading;
    return PageList(
      storageKey: const PageStorageKey('events'),
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
          if (repo.sosAcknowledged) ...[
            _EventCard(
              s.demoEventTime,
              s.demoSuccess,
              s.sosEventDetail,
              SafeIcons.sos,
              s.demo,
              danger,
            ),
            const SizedBox(height: SafeSpace.sm),
          ],
          for (final (event, time, title, detail, icon, severity, color)
              in items) ...[
            if (event == SafetyEvent.sos) ...[
              const SizedBox(height: SafeSpace.sm),
              Text(s.yesterday, style: context.type.titleLarge),
              const SizedBox(height: SafeSpace.sm),
            ],
            _EventCard(time, title, detail, icon, severity, color),
            const SizedBox(height: SafeSpace.sm),
          ],
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
    this.severity,
    this.color,
  );
  final String time;
  final String title;
  final String detail;
  final IconData icon;
  final String severity;
  final Color color;

  @override
  Widget build(BuildContext context) => Panel(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: color.withValues(alpha: .10),
          foregroundColor: color,
          child: Icon(icon, size: 20),
        ),
        const SizedBox(width: SafeSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: context.type.labelMedium?.copyWith(color: muted),
              ),
              Text(title, style: context.type.titleLarge),
              const SizedBox(height: SafeSpace.xs),
              Text(detail),
              const SizedBox(height: SafeSpace.sm),
              Tag(severity, icon, accent: color),
            ],
          ),
        ),
      ],
    ),
  );
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
