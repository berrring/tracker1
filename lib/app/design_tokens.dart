import 'package:material_ui/material_ui.dart';

const primary = Color(0xff315c50);
const primaryContainer = Color(0xffdcebe5);
const onPrimary = Color(0xffffffff);
const ink = Color(0xff18201d);
const muted = Color(0xff66716c);
const background = Color(0xfff7f9f8);
const surface = Color(0xffffffff);
const surfaceVariant = Color(0xffeef2f0);
const line = Color(0xffd9e0dd);
const success = Color(0xff287a55);
const warning = Color(0xffb56c12);
const danger = Color(0xffc83c3c);
const offline = Color(0xff6e7371);

abstract final class SafeSpace {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 40.0;
}

abstract final class SafeRadius {
  static const small = 12.0;
  static const control = 16.0;
  static const card = 20.0;
  static const map = 24.0;
  static const sheet = 28.0;
  static const pill = 100.0;
}

abstract final class SafeLayout {
  static const contentWidth = 560.0;
  static const pageInset = SafeSpace.lg;
  static const touchTarget = 48.0;
}

abstract final class SafeIcons {
  static const brand = Icons.shield_outlined;
  static const demo = Icons.science_outlined;
  static const language = Icons.language;
  static const person = Icons.person_outline;
  static const tracker = Icons.watch_outlined;
  static const battery = Icons.battery_5_bar;
  static const batteryAlert = Icons.battery_alert_outlined;
  static const network = Icons.cell_tower;
  static const time = Icons.schedule;
  static const accuracy = Icons.gps_fixed;
  static const center = Icons.my_location;
  static const sos = Icons.sos;
  static const addTracker = Icons.add_link;
  static const removeTracker = Icons.link_off;
  static const expand = Icons.expand_more;
  static const success = Icons.check_circle_outline;
}

ThemeData familyTheme() {
  const controlShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(SafeRadius.control)),
  );
  const minimum = Size.square(SafeLayout.touchTarget);
  final base = ThemeData(
    useMaterial3: true,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    visualDensity: VisualDensity.standard,
    colorScheme: ColorScheme.fromSeed(seedColor: primary).copyWith(
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: primary,
      surface: surface,
      onSurface: ink,
      onSurfaceVariant: muted,
      surfaceContainerHighest: surfaceVariant,
      outlineVariant: line,
      error: danger,
    ),
    scaffoldBackgroundColor: background,
    dividerColor: line,
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      scrolledUnderElevation: 0,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: surface,
      indicatorColor: primaryContainer,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(SafeRadius.card)),
        side: BorderSide(color: line),
      ),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(SafeRadius.sheet)),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SafeRadius.sheet),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(minimumSize: minimum, shape: controlShape),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: minimum,
        shape: controlShape,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(minimumSize: minimum, shape: controlShape),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(minimumSize: minimum),
    ),
    inputDecorationTheme: const InputDecorationThemeData(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(SafeRadius.control)),
      ),
    ),
  );
  final type = base.textTheme;
  return base.copyWith(
    textTheme: type.copyWith(
      headlineMedium: type.headlineMedium?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      headlineSmall: type.headlineSmall?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      titleLarge: type.titleLarge?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      bodyLarge: type.bodyLarge?.copyWith(
        fontSize: 16,
        height: 1.4,
        color: ink,
      ),
      bodyMedium: type.bodyMedium?.copyWith(
        fontSize: 14,
        height: 1.4,
        color: muted,
      ),
      bodySmall: type.bodySmall?.copyWith(color: muted),
      labelMedium: type.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
