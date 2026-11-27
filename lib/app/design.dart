import 'package:material_ui/material_ui.dart';

import '../data/mock_tracker_repository.dart';
import '../l10n/generated/app_localizations.dart';

import 'design_tokens.dart';

export 'design_tokens.dart';

extension LocalizedContext on BuildContext {
  AppLocalizations get strings => AppLocalizations.of(this)!;
  TextTheme get type => Theme.of(this).textTheme;
}

extension StatusCopy on TrackerStatus {
  String title(AppLocalizations s) => switch (this) {
    TrackerStatus.fresh => s.fresh,
    TrackerStatus.stale => s.stale,
    TrackerStatus.offline => s.offline,
    TrackerStatus.lowBattery => s.low,
    TrackerStatus.sos => s.sos,
    TrackerStatus.loading => s.loading,
    TrackerStatus.empty => s.empty,
    TrackerStatus.unavailable => s.unavailable,
    TrackerStatus.error => s.error,
  };

  String detail(AppLocalizations s) => switch (this) {
    TrackerStatus.fresh => s.freshDetail,
    TrackerStatus.stale => s.staleDetail,
    TrackerStatus.offline => s.offlineDetail,
    TrackerStatus.lowBattery => s.lowDetail,
    TrackerStatus.sos => s.sosDetail,
    TrackerStatus.loading => s.loadingDetail,
    TrackerStatus.empty => s.emptyDetail,
    TrackerStatus.unavailable => s.unavailableDetail,
    TrackerStatus.error => s.errorDetail,
  };

  IconData get icon => switch (this) {
    TrackerStatus.fresh => SafeIcons.success,
    TrackerStatus.stale => Icons.history,
    TrackerStatus.offline => Icons.signal_cellular_connected_no_internet_0_bar,
    TrackerStatus.lowBattery => SafeIcons.batteryAlert,
    TrackerStatus.sos => SafeIcons.sos,
    TrackerStatus.loading => Icons.hourglass_top,
    TrackerStatus.empty => SafeIcons.removeTracker,
    TrackerStatus.unavailable => Icons.location_off_outlined,
    TrackerStatus.error => Icons.error_outline,
  };

  Color get accent => switch (this) {
    TrackerStatus.fresh => success,
    TrackerStatus.sos => danger,
    TrackerStatus.lowBattery ||
    TrackerStatus.stale ||
    TrackerStatus.error => warning,
    _ => offline,
  };
}

String locationTime(AppLocalizations s, TrackerStatus status) =>
    switch (status) {
      TrackerStatus.stale => s.staleTime,
      TrackerStatus.offline => s.offlineTime,
      _ => s.todayTime,
    };

String lastContact(AppLocalizations s, MockTrackerRepository repo) {
  if (!repo.hasDeviceData) return s.unknown;
  return switch (repo.status) {
    TrackerStatus.offline => s.offlineAgo,
    TrackerStatus.stale => s.old,
    _ => s.recent,
  };
}

String networkLabel(AppLocalizations s, MockTrackerRepository repo) =>
    repo.hasDeviceData ? (repo.isOffline ? s.offline : s.online) : s.unknown;

class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(SafeSpace.lg),
  });
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(padding: padding, child: child),
  );
}

class Tag extends StatelessWidget {
  const Tag(this.label, this.icon, {super.key, this.accent = primary});
  final String label;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: accent.withValues(alpha: .10),
      borderRadius: BorderRadius.circular(SafeRadius.pill),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SafeSpace.md,
        vertical: SafeSpace.xs,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: accent),
          const SizedBox(width: SafeSpace.xs),
          Flexible(
            child: Text(
              label,
              style: context.type.labelMedium?.copyWith(color: ink),
            ),
          ),
        ],
      ),
    ),
  );
}

class StatusTag extends StatelessWidget {
  const StatusTag(this.status, {super.key});
  final TrackerStatus status;

  @override
  Widget build(BuildContext context) =>
      Tag(status.title(context.strings), status.icon, accent: status.accent);
}

class DemoNotice extends StatelessWidget {
  const DemoNotice(this.message, {super.key});
  final String message;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      color: primaryContainer,
      borderRadius: BorderRadius.all(Radius.circular(SafeRadius.control)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(SafeSpace.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(SafeIcons.demo, size: 18, color: primary),
          const SizedBox(width: SafeSpace.sm),
          Expanded(
            child: Text(
              message,
              style: context.type.bodyMedium?.copyWith(color: ink),
            ),
          ),
        ],
      ),
    ),
  );
}

class MetricGrid extends StatelessWidget {
  const MetricGrid({super.key, required this.metrics});
  final List<Metric> metrics;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final largeText = MediaQuery.textScalerOf(context).scale(14) >= 20;
      final twoColumns = constraints.maxWidth >= 272 && !largeText;
      final width = twoColumns
          ? (constraints.maxWidth - SafeSpace.md) / 2
          : constraints.maxWidth;
      return Wrap(
        spacing: SafeSpace.md,
        runSpacing: SafeSpace.md,
        children: [
          for (final metric in metrics) SizedBox(width: width, child: metric),
        ],
      );
    },
  );
}

class Metric extends StatelessWidget {
  const Metric(this.icon, this.label, this.value, {super.key});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: primary),
        const SizedBox(width: SafeSpace.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.type.bodySmall?.copyWith(color: muted),
              ),
              const SizedBox(height: 2),
              Text(value, style: context.type.labelLarge?.copyWith(color: ink)),
            ],
          ),
        ),
      ],
    ),
  );
}

class PageList extends StatelessWidget {
  const PageList({super.key, required this.children, this.storageKey});
  final List<Widget> children;
  final Key? storageKey;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: SafeLayout.contentWidth),
      child: ListView(
        key: storageKey,
        padding: const EdgeInsets.fromLTRB(
          SafeLayout.pageInset,
          SafeSpace.sm,
          SafeLayout.pageInset,
          SafeSpace.xl,
        ),
        children: children,
      ),
    ),
  );
}

class StatusPanel extends StatelessWidget {
  const StatusPanel(this.status, {super.key, this.action});
  final TrackerStatus status;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusTag(status),
          const SizedBox(height: SafeSpace.sm),
          Text(status.detail(s)),
          if (action != null) ...[
            const SizedBox(height: SafeSpace.sm),
            action!,
          ],
        ],
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, this.description, {super.key});
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Semantics(
        container: true,
        header: true,
        child: Text(title, style: context.type.headlineSmall),
      ),
      const SizedBox(height: SafeSpace.xs),
      Text(description),
      const SizedBox(height: SafeSpace.lg),
    ],
  );
}
