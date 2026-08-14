import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:waste_up/config/env_config.dart';
import 'package:waste_up/config/pwa_manifest.dart';
import 'package:waste_up/l10n/app_localizations.dart';
import 'package:waste_up/pages/home_screen.dart';
import 'package:waste_up/theme/app_colors.dart';

void main() {
  configurePwaManifest();
  runApp(const WasteUpApp());
}

class WasteUpApp extends StatefulWidget {
  const WasteUpApp({super.key, this.locale});

  final Locale? locale;

  @override
  State<WasteUpApp> createState() => _WasteUpAppState();
}

class _WasteUpAppState extends State<WasteUpApp> {
  late Locale selectedLocale;

  @override
  void initState() {
    super.initState();
    selectedLocale = widget.locale ?? const Locale('zh', 'TW');
  }

  @override
  void didUpdateWidget(covariant WasteUpApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.locale != oldWidget.locale && widget.locale != null) {
      selectedLocale = widget.locale!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: selectedLocale,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale != null) {
          for (final supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          for (final supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
        }
        return const Locale('zh', 'TW');
      },
      debugShowCheckedModeBanner: EnvConfig.debugShowCheckedModeBanner,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: page,
        colorScheme: ColorScheme.fromSeed(
          seedColor: yellow,
          primary: yellow,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: page,
          foregroundColor: ink,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Color(0xFFDDE0DA)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Color(0xFFDDE0DA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: ink, width: 1.5),
          ),
        ),
        popupMenuTheme: const PopupMenuThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      home: HomeScreen(
        locale: selectedLocale,
        onLocaleChanged: (locale) => setState(() => selectedLocale = locale),
      ),
    );
  }
}
