import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';

import '../app/design.dart';
import '../data/mock_tracker_repository.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({super.key, required this.repo, required this.onPair});
  final MockTrackerRepository repo;
  final VoidCallback onPair;

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final status = repo.status;
    final preferences = <Widget>[
      if (repo.hasTracker) ...[
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.preferences, style: context.type.titleLarge),
              Text(kIsWeb ? s.notifyDetailWeb : s.notifyDetail),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(s.notifyBattery),
                value: repo.notifyBattery,
                onChanged: (value) => repo.changePreferences(battery: value),
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(s.notifyNetwork),
                value: repo.notifyNetwork,
                onChanged: (value) => repo.changePreferences(network: value),
              ),
            ],
          ),
        ),
        const SizedBox(height: SafeSpace.md),
        OutlinedButton.icon(
          onPressed: () => _remove(context),
          icon: const Icon(SafeIcons.removeTracker),
          label: Text(s.remove),
        ),
      ],
    ];
    final device = <Widget>[
      if (repo.hasDeviceData) ...[
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: SafeSpace.sm,
                runSpacing: SafeSpace.xs,
                children: [StatusTag(status)],
              ),
              const SizedBox(height: SafeSpace.sm),
              Text(s.tracker, style: context.type.headlineMedium),
              const SizedBox(height: SafeSpace.xs),
              Text(status.detail(s)),
              const SizedBox(height: SafeSpace.lg),
              Metric(Icons.tag, s.id, MockTrackerRepository.trackerId),
              const Divider(height: 24),
              MetricGrid(
                metrics: [
                  Metric(
                    status == TrackerStatus.lowBattery
                        ? SafeIcons.batteryAlert
                        : SafeIcons.battery,
                    s.battery,
                    '${repo.battery}%',
                  ),
                  Metric(
                    repo.isOffline
                        ? Icons.cloud_off_outlined
                        : SafeIcons.network,
                    s.network,
                    networkLabel(s, repo),
                  ),
                  Metric(SafeIcons.time, s.lastContact, lastContact(s, repo)),
                  Metric(Icons.memory_outlined, s.firmware, s.firmwareValue),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: SafeSpace.md),
      ] else ...[
        StatusPanel(
          status,
          action: switch (status) {
            TrackerStatus.empty => FilledButton.icon(
              onPressed: onPair,
              icon: const Icon(SafeIcons.addTracker),
              label: Text(s.add),
            ),
            TrackerStatus.error => OutlinedButton(
              onPressed: () => repo.select(TrackerStatus.fresh),
              child: Text(s.retry),
            ),
            _ => null,
          },
        ),
        const SizedBox(height: SafeSpace.md),
      ],
    ];
    final physical = Panel(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.usb),
        title: Text(s.hardwareTitle),
        subtitle: Text(s.demoDeviceNotice),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.pushNamed(context, '/hardware'),
      ),
    );
    final demo = Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(s.demoControls, style: context.type.titleLarge),
          const SizedBox(height: SafeSpace.md),
          DropdownButtonFormField<TrackerStatus>(
            key: ValueKey(status),
            initialValue: status,
            isExpanded: true,
            itemHeight: null,
            borderRadius: BorderRadius.circular(SafeRadius.control),
            icon: const Icon(SafeIcons.expand),
            decoration: InputDecoration(labelText: s.state),
            items: [
              for (final item in TrackerStatus.values)
                DropdownMenuItem(
                  value: item,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: SafeLayout.touchTarget,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(item.title(s)),
                    ),
                  ),
                ),
            ],
            selectedItemBuilder: (context) => [
              for (final item in TrackerStatus.values)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(item.title(s), overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: (value) {
              if (value != null) repo.select(value);
            },
          ),
          if (repo.hasDeviceData) ...[
            const SizedBox(height: SafeSpace.md),
            FilledButton.tonalIcon(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => SosDialog(repo: repo),
              ),
              icon: const Icon(SafeIcons.sos),
              label: Text(s.sos),
            ),
          ],
        ],
      ),
    );
    final wide =
        MediaQuery.sizeOf(context).width >= SafeLayout.desktopBreakpoint;
    return PageList(
      storageKey: const PageStorageKey('device'),
      maxWidth: 1060,
      inset: wide ? SafeSpace.xl : SafeSpace.lg,
      children: [
        SectionHeading(s.deviceOverview, ''),
        if (wide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [...device, ...preferences],
                ),
              ),
              const SizedBox(width: SafeSpace.lg),
              SizedBox(
                width: 310,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    physical,
                    const SizedBox(height: SafeSpace.md),
                    demo,
                  ],
                ),
              ),
            ],
          )
        else ...[
          physical,
          const SizedBox(height: SafeSpace.md),
          demo,
          const SizedBox(height: SafeSpace.md),
          ...device,
          ...preferences,
        ],
      ],
    );
  }

  Future<void> _remove(BuildContext context) async {
    final s = context.strings;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: Text(s.remove),
        content: Text(s.removePrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(s.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(s.remove),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) repo.remove();
  }
}

class SosDialog extends StatefulWidget {
  const SosDialog({super.key, required this.repo});
  final MockTrackerRepository repo;

  @override
  State<SosDialog> createState() => _SosDialogState();
}

class _SosDialogState extends State<SosDialog> {
  SosDemoState phase = SosDemoState.ready;
  Timer? timer;

  void start() {
    setState(() => phase = widget.repo.startSos());
    if (phase != SosDemoState.preparing) return;
    timer = Timer.periodic(const Duration(milliseconds: 750), (timer) {
      setState(() => phase = widget.repo.advanceSos(phase));
      if (phase != SosDemoState.sending) timer.cancel();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final busy =
        phase == SosDemoState.preparing || phase == SosDemoState.sending;
    final disconnected = phase == SosDemoState.offline;
    return AlertDialog(
      scrollable: true,
      icon: const Icon(SafeIcons.sos, color: danger),
      title: Text(s.sos),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DemoNotice(s.sosWarning),
          if (phase != SosDemoState.ready) ...[
            const SizedBox(height: SafeSpace.lg),
            Semantics(
              liveRegion: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(switch (phase) {
                    SosDemoState.preparing => s.prepare,
                    SosDemoState.sending => s.sending,
                    SosDemoState.acknowledged => s.demoAck,
                    _ => s.offline,
                  }, style: context.type.titleLarge),
                  if (busy) ...[
                    const SizedBox(height: SafeSpace.sm),
                    const LinearProgressIndicator(),
                  ],
                  if (disconnected) ...[
                    Text(s.offlineLast),
                    Text(s.unconfirmed),
                    Text(s.noDelivery),
                  ],
                  if (phase == SosDemoState.acknowledged) ...[
                    const SizedBox(height: SafeSpace.sm),
                    Text(s.demoSuccess, style: context.type.titleLarge),
                    Text(s.demoSuccessDetail),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s.close),
        ),
        if (phase == SosDemoState.ready)
          FilledButton(
            onPressed: start,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: SafeSpace.md),
            ),
            child: Text(s.startSos, textAlign: TextAlign.center),
          ),
      ],
    );
  }
}
