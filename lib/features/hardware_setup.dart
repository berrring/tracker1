import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../app/design.dart';
import '../hardware/tracker_usb.dart';
import '../l10n/generated/app_localizations.dart';

class HardwareSetupScreen extends StatefulWidget {
  const HardwareSetupScreen({super.key, this.transport});
  final TrackerUsb? transport;

  @override
  State<HardwareSetupScreen> createState() => _HardwareSetupScreenState();
}

class _HardwareSetupScreenState extends State<HardwareSetupScreen> {
  late final usb = widget.transport ?? createTrackerUsb();
  final name = TextEditingController();
  final phone = TextEditingController();
  final form = GlobalKey<FormState>();
  TrackerDevice? device;
  String? result;
  String? pending;
  Timer? connectionCheck;

  bool get ready => device?.profileEnabled == true && pending == null;

  @override
  void initState() {
    super.initState();
    connectionCheck = Timer.periodic(const Duration(seconds: 1), (_) {
      if (device != null && !usb.connected) {
        setState(() {
          device = null;
          phone.clear();
          result = pending == 'TEST' ? 'sms_unknown' : 'disconnected';
        });
      }
    });
  }

  @override
  void dispose() {
    connectionCheck?.cancel();
    unawaited(usb.disconnect());
    name.dispose();
    phone.dispose();
    super.dispose();
  }

  Future<void> run(String action, [String arguments = '']) async {
    if (pending != null) return;
    setState(() {
      pending = action;
      result = null;
    });
    final reply = action == 'CONNECT'
        ? await usb.connect()
        : await usb.request(action, arguments);
    if (!mounted) return;
    setState(() {
      pending = null;
      result =
          action == 'TEST' &&
              {
                'disconnected',
                'serial_error',
                'wrong_device',
              }.contains(reply.code)
          ? 'sms_unknown'
          : reply.code;
      if (reply.device case final updated?) {
        device = updated;
        if (action != 'DIAG') name.text = updated.name;
      } else if (!usb.connected) {
        device = null;
      }
      if (action == 'SET' || !usb.connected) phone.clear();
    });
    if (const {'SET', 'CLEAR', 'TEST'}.contains(action)) {
      final notice = message(context.strings);
      if (notice != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(notice)));
      }
    }
  }

  Future<void> disconnect() async {
    await usb.disconnect();
    if (!mounted) return;
    setState(() {
      device = null;
      pending = null;
      result = null;
      name.clear();
      phone.clear();
    });
  }

  Future<bool> confirm(
    String title,
    String body, {
    bool requireConsent = false,
  }) async {
    var accepted = false;
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            final s = context.strings;
            return StatefulBuilder(
              builder: (context, update) => AlertDialog(
                scrollable: true,
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(body),
                    if (requireConsent)
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(s.hardwareConsent),
                        value: accepted,
                        onChanged: (value) =>
                            update(() => accepted = value == true),
                      ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(s.cancel),
                  ),
                  FilledButton(
                    onPressed: !requireConsent || accepted
                        ? () => Navigator.pop(context, true)
                        : null,
                    child: Text(title),
                  ),
                ],
              ),
            );
          },
        ) ??
        false;
  }

  Future<void> save() async {
    if (form.currentState?.validate() != true) return;
    final s = context.strings;
    final number = phone.text.trim();
    final trackerName = name.text.trim();
    if (await confirm(
          s.hardwareConfirm,
          '$number\n\n${s.hardwarePrivate}',
          requireConsent: true,
        ) &&
        mounted) {
      await run('SET', '$number|$trackerName');
    }
  }

  String? message(AppLocalizations s) => switch (result) {
    null || 'status' => null,
    'saved' => s.hardwareConfigured,
    'cleared' => s.hardwareCleared,
    'sms_accepted' => s.hardwareAccepted,
    'sms_rejected' => s.hardwareRejected,
    'sms_unknown' => s.hardwareUnknownSms,
    'not_registered' => s.hardwareNoNetwork,
    'no_modem' => s.hardwareNoModem,
    'timeout' || 'confirm_timeout' => s.hardwareTimeout,
    'cancelled' => s.hardwareSelectionCancelled,
    'wrong_device' => s.hardwareWrong,
    'disconnected' => s.hardwareDisconnected,
    'unsupported' => s.hardwareUnsupported,
    'storage_error' => s.hardwareStorage,
    'not_configured' => s.hardwareUnconfigured,
    'profile_locked' => s.hardwareLocked,
    _ => s.hardwarePortError,
  };

  String diagnostic(AppLocalizations s, String value) => switch (value) {
    'ready' => s.hardwareReady,
    'registered' => s.hardwareRegistered,
    'not_registered' => s.hardwareNotRegistered,
    'fix' => s.hardwareFix,
    'no_fix' => s.hardwareNoFix,
    'unavailable' => s.hardwareUnavailable,
    _ => s.hardwareNotChecked,
  };

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final current = device;
    final statusText = message(s);
    return Scaffold(
      appBar: AppBar(title: Text(s.hardwareTitle)),
      body: SafeArea(
        child: PageList(
          children: [
            SectionHeading(s.hardwareOpen, s.hardwareIntro),
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Metric(SafeIcons.tracker, s.hardwareBoard, trackerBoard),
                  const SizedBox(height: SafeSpace.md),
                  Tag(
                    current == null
                        ? s.hardwareDisconnected
                        : s.hardwareConnected,
                    Icons.usb,
                    accent: current == null ? offline : success,
                  ),
                  const SizedBox(height: SafeSpace.md),
                  Text(usb.supported ? s.hardwareSteps : s.hardwareUnsupported),
                  if (usb.supported) ...[
                    const SizedBox(height: SafeSpace.md),
                    if (current == null)
                      FilledButton.icon(
                        onPressed: pending == null
                            ? () => run('CONNECT')
                            : null,
                        icon: const Icon(Icons.usb),
                        label: Text(s.hardwareConnect),
                      )
                    else
                      OutlinedButton(
                        onPressed: pending == null ? disconnect : null,
                        child: Text(s.hardwareDisconnect),
                      ),
                  ],
                ],
              ),
            ),
            if (pending != null || statusText != null) ...[
              const SizedBox(height: SafeSpace.md),
              Semantics(
                liveRegion: true,
                child: Panel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pending == null
                            ? statusText!
                            : {'SET', 'CLEAR', 'TEST'}.contains(pending)
                            ? s.hardwarePending
                            : s.hardwareBusy,
                      ),
                      if (pending != null) ...[
                        const SizedBox(height: SafeSpace.sm),
                        const LinearProgressIndicator(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
            if (current != null) ...[
              const SizedBox(height: SafeSpace.md),
              Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MetricGrid(
                      metrics: [
                        Metric(Icons.memory, s.firmware, current.firmware),
                        Metric(
                          Icons.contact_phone_outlined,
                          s.hardwareConfig,
                          current.configured
                              ? s.hardwareConfigured
                              : s.hardwareUnconfigured,
                        ),
                        Metric(
                          Icons.settings_input_component_outlined,
                          s.hardwareModem,
                          diagnostic(s, current.modem),
                        ),
                        Metric(
                          SafeIcons.network,
                          s.network,
                          diagnostic(s, current.network),
                        ),
                        Metric(
                          SafeIcons.accuracy,
                          s.hardwareGnss,
                          diagnostic(s, current.gnss),
                        ),
                      ],
                    ),
                    const SizedBox(height: SafeSpace.md),
                    if (!current.profileEnabled) Text(s.hardwareLocked),
                    OutlinedButton(
                      onPressed: ready ? () => run('DIAG') : null,
                      child: Text(s.hardwareDiagnostics),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SafeSpace.md),
              Panel(
                child: Form(
                  key: form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        enabled: ready,
                        controller: name,
                        autofillHints: null,
                        decoration: InputDecoration(labelText: s.hardwareName),
                        validator: (value) => isTrackerName(value?.trim() ?? '')
                            ? null
                            : s.hardwareNameInvalid,
                      ),
                      const SizedBox(height: SafeSpace.md),
                      TextFormField(
                        enabled: ready,
                        controller: phone,
                        autofillHints: null,
                        autocorrect: false,
                        enableSuggestions: false,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(labelText: s.hardwarePhone),
                        validator: (value) =>
                            isInternationalPhone(value?.trim() ?? '')
                            ? null
                            : s.hardwarePhoneInvalid,
                      ),
                      const SizedBox(height: SafeSpace.sm),
                      Text(s.hardwarePhoneHint),
                      const SizedBox(height: SafeSpace.sm),
                      Text(s.hardwarePrivate),
                      const SizedBox(height: SafeSpace.md),
                      FilledButton(
                        onPressed: ready ? save : null,
                        child: Text(s.hardwareSave),
                      ),
                      if (current.configured) ...[
                        const SizedBox(height: SafeSpace.sm),
                        FilledButton.tonal(
                          onPressed: ready
                              ? () async {
                                  if (await confirm(
                                        s.hardwareTestTitle,
                                        s.hardwareTestCopy,
                                      ) &&
                                      mounted) {
                                    await run('TEST');
                                  }
                                }
                              : null,
                          child: Text(s.hardwareTest),
                        ),
                        OutlinedButton(
                          onPressed: ready
                              ? () async {
                                  if (await confirm(
                                        s.hardwareClear,
                                        s.hardwareClearCopy,
                                      ) &&
                                      mounted) {
                                    await run('CLEAR');
                                  }
                                }
                              : null,
                          child: Text(s.hardwareClear),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
