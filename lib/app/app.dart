import 'package:material_ui/material_ui.dart';

import '../data/mock_tracker_repository.dart';
import '../features/device_sos.dart';
import '../features/family_events.dart';
import '../features/map_screen.dart';
import '../l10n/generated/app_localizations.dart';
import 'design.dart';

class SafeTrackApp extends StatefulWidget {
  const SafeTrackApp({super.key, this.repository});
  final MockTrackerRepository? repository;

  @override
  State<SafeTrackApp> createState() => _SafeTrackAppState();
}

class _SafeTrackAppState extends State<SafeTrackApp> {
  late final repo = widget.repository ?? MockTrackerRepository();
  Locale locale = const Locale('ru');

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
    home: _Shell(
      repo: repo,
      locale: locale,
      setLocale: (value) => setState(() => locale = value),
    ),
  );
}

class _Shell extends StatefulWidget {
  const _Shell({
    required this.repo,
    required this.locale,
    required this.setLocale,
  });
  final MockTrackerRepository repo;
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
    return PopScope(
      canPop: tab == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && tab != 0) setState(() => tab = 0);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          excludeHeaderSemantics: true,
          title: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: SafeLayout.contentWidth,
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: SafeLayout.pageInset,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(SafeRadius.small),
                      ),
                      child: const Icon(
                        SafeIcons.brand,
                        color: onPrimary,
                        size: 23,
                      ),
                    ),
                    const SizedBox(width: SafeSpace.sm),
                    Expanded(
                      child: Semantics(
                        header: true,
                        container: true,
                        child: Text(
                          tab == 0 ? s.appName : labels[tab],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.type.headlineSmall?.copyWith(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: SafeSpace.xs),
                    Tag(s.demo, SafeIcons.demo),
                    PopupMenuButton<Locale>(
                      tooltip: s.language,
                      initialValue: widget.locale,
                      onSelected: widget.setLocale,
                      icon: const Icon(SafeIcons.language),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: const Locale('ru'),
                          child: Text(s.russian),
                        ),
                        PopupMenuItem(
                          value: const Locale('en'),
                          child: Text(s.english),
                        ),
                        PopupMenuItem(
                          value: const Locale('ky'),
                          child: Text(s.kyrgyz),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: ListenableBuilder(
            listenable: repo,
            builder: (context, _) => switch (tab) {
              0 => MapScreen(repo: repo, onPair: pair),
              1 => EventsScreen(repo: repo),
              2 => FamilyScreen(onPair: pair),
              _ => DeviceScreen(repo: repo, onPair: pair),
            },
          ),
        ),
        bottomNavigationBar: ColoredBox(
          color: surface,
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: SafeLayout.contentWidth,
              ),
              child: NavigationBar(
                selectedIndex: tab,
                onDestinationSelected: (value) => setState(() => tab = value),
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.map_outlined),
                    selectedIcon: const Icon(Icons.map),
                    label: labels[0],
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.notifications_none),
                    selectedIcon: const Icon(Icons.notifications),
                    label: labels[1],
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.people_outline),
                    selectedIcon: const Icon(Icons.people),
                    label: labels[2],
                  ),
                  NavigationDestination(
                    icon: const Icon(SafeIcons.tracker),
                    selectedIcon: const Icon(Icons.watch),
                    label: labels[3],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
