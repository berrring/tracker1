import 'package:material_ui/material_ui.dart';

import '../data/demo_store.dart';
import '../data/mock_tracker_repository.dart';
import '../features/device_sos.dart';
import '../features/family_events.dart';
import '../features/hardware_setup.dart';
import '../features/map_screen.dart';
import '../l10n/generated/app_localizations.dart';
import 'brand_mark.dart';
import 'design.dart';

class SafeTrackApp extends StatefulWidget {
  const SafeTrackApp({
    super.key,
    this.repository,
    this.interactiveMaps = false,
  });
  final MockTrackerRepository? repository;
  final bool interactiveMaps;

  @override
  State<SafeTrackApp> createState() => _SafeTrackAppState();
}

class _SafeTrackAppState extends State<SafeTrackApp> {
  final store = browserDemoStore();
  late final repo = widget.repository ?? MockTrackerRepository(store: store);
  late Locale locale = switch (store.read('language')) {
    'en' => const Locale('en'),
    'ky' => const Locale('ky'),
    _ => const Locale('ru'),
  };

  @override
  void dispose() {
    if (widget.repository == null) repo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateTitle: (context) => context.strings.appName,
    debugShowCheckedModeBanner: false,
    theme: familyTheme(),
    locale: locale.languageCode == 'ky' ? const Locale('ru') : locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    routes: {'/hardware': (_) => const HardwareSetupScreen()},
    home: _Shell(
      interactiveMaps: widget.interactiveMaps,
      repo: repo,
      locale: locale,
      setLocale: (value) {
        store.write('language', value.languageCode);
        setState(() => locale = value);
      },
    ),
  );
}

class _Shell extends StatefulWidget {
  const _Shell({
    required this.repo,
    required this.interactiveMaps,
    required this.locale,
    required this.setLocale,
  });
  final MockTrackerRepository repo;
  final bool interactiveMaps;
  final Locale locale;
  final ValueChanged<Locale> setLocale;

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  int tab = 0;

  Future<void> pair() async {
    final paired = await showDialog<bool>(
      context: context,
      builder: (_) => PairingDialog(repo: widget.repo),
    );
    if (paired == true && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.strings.paired)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final repo = widget.repo;
    final labels = [s.map, s.events, s.family, s.device];
    const icons = [
      Icons.map_outlined,
      Icons.notifications_none_rounded,
      Icons.people_outline_rounded,
      SafeIcons.tracker,
    ];
    final wide =
        MediaQuery.sizeOf(context).width >= SafeLayout.desktopBreakpoint;
    final screen = ListenableBuilder(
      listenable: repo,
      builder: (context, _) => switch (tab) {
        0 => MapScreen(
          repo: repo,
          onPair: pair,
          interactiveMaps: widget.interactiveMaps,
          onOpenDevice: () => setState(() => tab = 3),
        ),
        1 => EventsScreen(repo: repo),
        2 => FamilyScreen(onPair: pair),
        _ => DeviceScreen(repo: repo, onPair: pair),
      },
    );
    final localeMenu = PopupMenuButton<Locale>(
      tooltip: s.language,
      initialValue: widget.locale,
      onSelected: widget.setLocale,
      icon: const Icon(SafeIcons.language),
      itemBuilder: (_) => [
        PopupMenuItem(value: const Locale('ru'), child: Text(s.russian)),
        PopupMenuItem(value: const Locale('en'), child: Text(s.english)),
        PopupMenuItem(value: const Locale('ky'), child: Text(s.kyrgyz)),
      ],
    );
    return PopScope(
      canPop: tab == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && tab != 0) setState(() => tab = 0);
      },
      child: Scaffold(
        appBar: wide
            ? null
            : AppBar(
                automaticallyImplyLeading: false,
                titleSpacing: SafeSpace.lg,
                excludeHeaderSemantics: true,
                title: Row(
                  children: [
                    const BrandMark(size: 34),
                    const SizedBox(width: SafeSpace.sm),
                    Expanded(
                      child: _ShellTitle(tab == 0 ? s.appName : labels[tab]),
                    ),
                  ],
                ),
                actions: [
                  localeMenu,
                  const SizedBox(width: SafeSpace.sm),
                ],
              ),
        body: wide
            ? SafeArea(
                child: Row(
                  children: [
                    SizedBox(
                      key: const ValueKey('desktop-sidebar'),
                      width: SafeLayout.sidebarWidth,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: surface,
                          border: BorderDirectional(
                            end: BorderSide(color: line),
                          ),
                        ),
                        child: ListView(
                          padding: const EdgeInsets.all(SafeSpace.lg),
                          children: [
                            const SizedBox(height: SafeSpace.sm),
                            Row(
                              children: [
                                const BrandMark(),
                                const SizedBox(width: SafeSpace.sm),
                                Expanded(child: _ShellTitle(s.appName)),
                              ],
                            ),
                            const SizedBox(height: SafeSpace.xxl),
                            for (var index = 0; index < labels.length; index++)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: SafeSpace.xs,
                                ),
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: ListTile(
                                    selected: index == tab,
                                    selectedTileColor: primaryContainer,
                                    selectedColor: primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        SafeRadius.control,
                                      ),
                                    ),
                                    leading: Icon(icons[index]),
                                    title: Text(labels[index]),
                                    onTap: () => setState(() => tab = index),
                                  ),
                                ),
                              ),
                            const Divider(height: SafeSpace.xxl),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    s.demo,
                                    style: context.type.labelMedium,
                                  ),
                                ),
                                localeMenu,
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(child: screen),
                  ],
                ),
              )
            : SafeArea(top: false, bottom: false, child: screen),
        bottomNavigationBar: wide
            ? null
            : DecoratedBox(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: line)),
                ),
                child: NavigationBar(
                  selectedIndex: tab,
                  onDestinationSelected: (value) => setState(() => tab = value),
                  destinations: [
                    for (var index = 0; index < labels.length; index++)
                      NavigationDestination(
                        icon: Icon(icons[index]),
                        label: labels[index],
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _ShellTitle extends StatelessWidget {
  const _ShellTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.type.titleLarge?.copyWith(fontWeight: FontWeight.w700),
    ),
  );
}
