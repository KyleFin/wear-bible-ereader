import 'package:android_companion_for_wear_os_ereader/counter/counter.dart';
import 'package:android_companion_for_wear_os_ereader/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({required this.flutterWearOsConnectivity, super.key});

  final FlutterWearOsConnectivity flutterWearOsConnectivity;

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: flutterWearOsConnectivity,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const CounterPage(),
    );
  }
}
