import 'package:material_ui/material_ui.dart';

import '../app/design.dart';
import '../hardware/tracker_session.dart';
import '../hardware/tracker_usb.dart';
import '../l10n/generated/app_localizations.dart';

class HardwareSetupScreen extends StatefulWidget {
  const HardwareSetupScreen({super.key, this.transport});
  final TrackerUsb? transport;

  @override
  State<HardwareSetupScreen> createState() => _HardwareSetupScreenState();
}

class _HardwareSetupScreenState extends State<HardwareSetupScreen> {
  late final session = TrackerSession(widget.transport ?? createTrackerUsb());
  final name = TextEditingController();
  final phone = TextEditingController();
  final form = GlobalKey<FormState>();
  int step = 0;

  @override
  void initState() {
    super.initState();
    session.addListener(refresh);
  }

  void refresh() {
    setState(() {
      if (session.device == null) {
        step = 0;
        phone.clear();
        name.clear();
      }
    });
  }

  @override
  void dispose() {
    session.removeListener(refresh);
    session.dispose();
    name.dispose();
    phone.dispose();
    super.dispose();
  }

  Future<void> run(String action, [String arguments = '']) async {
    await session.run(action, arguments);
    if (!mounted) return;
    if (action == 'CONNECT' || action == 'CLEAR') {
      name.text = session.device?.name ?? '';
    }
    if (action == 'SET') phone.clear();
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
        mounted &&
        session.ready) {
      await run('SET', '$number|$trackerName');
    }
  }

  Future<void> test() async {
    final s = context.strings;
    final instruction = session.device?.testInput == 'slide'
        ? s.setupSlide
        : s.setupBoot;
    if (await confirm(
          s.hardwareTestTitle,
          '${s.hardwareTestCopy}\n\n$instruction',
        ) &&
        mounted &&
        session.ready &&
        session.device?.configured == true) {
      await run('TEST');
    }
  }

  String? message(AppLocalizations s, String? code) => switch (code) {
    null || 'status' => null,
    'saved' => s.hardwareConfigured,
    'cleared' => s.hardwareCleared,
    'sms_accepted' => s.hardwareAccepted,
    'sms_rejected' => s.hardwareRejected,
    'sms_unknown' => s.hardwareUnknownSms,
    'not_registered' => s.hardwareNoNetwork,
    'sim_unready' => s.setupSimUnready,
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
    'sim_locked' => s.setupSimLocked,
    'fix' => s.hardwareFix,
    'no_fix' => s.hardwareNoFix,
    'unavailable' => s.hardwareUnavailable,
    _ => s.hardwareNotChecked,
  };

  String contactStatus(AppLocalizations s, TrackerDevice device) =>
      device.configured ? s.hardwareConfigured : s.hardwareUnconfigured;

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final device = session.device;
    final busy = session.pending != null;
    final stateMessage = busy
        ? switch (session.pending) {
            'TEST' => device?.testInput == 'slide' ? s.setupSlide : s.setupBoot,
            'SET' || 'CLEAR' => s.hardwarePending,
            _ => s.hardwareBusy,
          }
        : message(s, session.result);
    final titles = [
      s.setupConnect,
      s.setupIdentify,
      s.setupCellular,
      s.setupContact,
      s.setupGnss,
      s.setupBattery,
      s.setupSos,
      s.setupFinish,
    ];
    final canAdvance =
        !busy && device != null && (step != 3 || device.configured);
    return Scaffold(
      appBar: AppBar(title: Text(s.hardwareTitle)),
      body: SafeArea(
        child: PageList(
          storageKey: ValueKey(step),
          children: [
            SectionHeading(s.hardwareOpen, s.hardwareIntro),
            Wrap(
              spacing: SafeSpace.sm,
              runSpacing: SafeSpace.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Tag(s.setupStep(step + 1), Icons.checklist),
                Tag(
                  device == null ? s.hardwareDisconnected : s.hardwareConnected,
                  Icons.usb,
                  accent: device == null ? offline : success,
                ),
              ],
            ),
            const SizedBox(height: SafeSpace.sm),
            LinearProgressIndicator(value: (step + 1) / titles.length),
            const SizedBox(height: SafeSpace.lg),
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    header: true,
                    child: Text(titles[step], style: context.type.titleLarge),
                  ),
                  const SizedBox(height: SafeSpace.md),
                  if (step == 0) ...[
                    Text(
                      session.usb.supported
                          ? s.hardwareSteps
                          : s.hardwareUnsupported,
                    ),
                    const SizedBox(height: SafeSpace.md),
                    if (session.usb.supported)
                      FilledButton.icon(
                        onPressed: busy
                            ? null
                            : device == null
                            ? () => run('CONNECT')
                            : session.disconnect,
                        icon: const Icon(Icons.usb),
                        label: Text(
                          device == null
                              ? s.hardwareConnect
                              : s.hardwareDisconnect,
                        ),
                      ),
                  ] else if (device != null)
                    ..._details(s, device),
                  if (stateMessage != null) ...[
                    const SizedBox(height: SafeSpace.md),
                    Semantics(liveRegion: true, child: Text(stateMessage)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: SafeSpace.md),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: SafeSpace.sm,
              runSpacing: SafeSpace.sm,
              children: [
                if (step > 0)
                  OutlinedButton(
                    onPressed: busy ? null : () => setState(() => step -= 1),
                    child: Text(s.setupPrevious),
                  ),
                if (step < titles.length - 1)
                  FilledButton(
                    onPressed: canAdvance
                        ? () => setState(() => step += 1)
                        : null,
                    child: Text(s.setupContinue),
                  )
                else
                  FilledButton(
                    onPressed: busy ? null : () => Navigator.pop(context),
                    child: Text(s.setupDone),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _details(AppLocalizations s, TrackerDevice device) {
    final diagnostics = OutlinedButton(
      onPressed: session.ready ? () => run('DIAG') : null,
      child: Text(s.hardwareDiagnostics),
    );
    final percent = device.batteryPercent;
    final millivolts = device.batteryMillivolts;
    return switch (step) {
      1 => [
        MetricGrid(
          metrics: [
            Metric(SafeIcons.tracker, s.hardwareBoard, trackerBoard),
            Metric(Icons.memory, s.firmware, device.firmware),
          ],
        ),
        if (!device.profileEnabled) ...[
          const SizedBox(height: SafeSpace.md),
          Text(s.hardwareLocked),
        ],
      ],
      2 => [
        MetricGrid(
          metrics: [
            Metric(
              Icons.settings_input_component_outlined,
              s.hardwareModem,
              diagnostic(s, device.modem),
            ),
            Metric(
              Icons.sim_card_outlined,
              s.setupSim,
              diagnostic(s, device.sim),
            ),
            Metric(SafeIcons.network, s.network, diagnostic(s, device.network)),
          ],
        ),
        const SizedBox(height: SafeSpace.md),
        diagnostics,
      ],
      3 => [
        Metric(
          Icons.contact_phone_outlined,
          s.hardwareConfig,
          contactStatus(s, device),
        ),
        const SizedBox(height: SafeSpace.md),
        Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                enabled: session.ready,
                controller: name,
                autofillHints: null,
                decoration: InputDecoration(labelText: s.hardwareName),
                validator: (value) => isTrackerName(value?.trim() ?? '')
                    ? null
                    : s.hardwareNameInvalid,
              ),
              const SizedBox(height: SafeSpace.md),
              TextFormField(
                enabled: session.ready,
                controller: phone,
                autofillHints: null,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: s.hardwarePhone),
                validator: (value) => isInternationalPhone(value?.trim() ?? '')
                    ? null
                    : s.hardwarePhoneInvalid,
              ),
              const SizedBox(height: SafeSpace.sm),
              Text(s.hardwarePhoneHint),
              const SizedBox(height: SafeSpace.sm),
              Text(s.hardwarePrivate),
              const SizedBox(height: SafeSpace.md),
              FilledButton(
                onPressed: session.ready ? save : null,
                child: Text(s.hardwareSave),
              ),
              if (device.configured)
                OutlinedButton(
                  onPressed: session.ready
                      ? () async {
                          if (await confirm(
                                s.hardwareClear,
                                s.hardwareClearCopy,
                              ) &&
                              mounted &&
                              session.ready) {
                            await run('CLEAR');
                          }
                        }
                      : null,
                  child: Text(s.hardwareClear),
                ),
            ],
          ),
        ),
      ],
      4 => [
        Metric(SafeIcons.accuracy, s.hardwareGnss, diagnostic(s, device.gnss)),
        const SizedBox(height: SafeSpace.md),
        Text(s.setupGnssPrivacy),
        diagnostics,
      ],
      5 => [
        Metric(
          SafeIcons.battery,
          s.battery,
          percent == null ? s.hardwareUnavailable : '$percent%',
        ),
        if (millivolts != null)
          Metric(
            Icons.bolt_outlined,
            s.setupVoltage,
            s.setupMillivolts(millivolts),
          ),
        const SizedBox(height: SafeSpace.md),
        Text(s.setupBatteryHelp),
        diagnostics,
      ],
      6 => [
        Text(device.testInput == 'slide' ? s.setupSlide : s.setupBoot),
        const SizedBox(height: SafeSpace.md),
        FilledButton.tonal(
          onPressed: session.ready && device.configured ? test : null,
          child: Text(s.hardwareTest),
        ),
      ],
      _ => [
        Metric(
          Icons.contact_phone_outlined,
          s.hardwareConfig,
          contactStatus(s, device),
        ),
        const SizedBox(height: SafeSpace.md),
        Metric(
          SafeIcons.sos,
          s.setupSos,
          message(s, session.testResult) ?? s.hardwareNotChecked,
        ),
        const SizedBox(height: SafeSpace.md),
        Text(s.setupFinishHelp),
      ],
    };
  }
}
