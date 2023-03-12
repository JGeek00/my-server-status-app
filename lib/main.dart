import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/base.dart';
import 'package:my_server_status/config/theme.dart';
import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/providers/servers_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final appConfigProvider = AppConfigProvider();
  final serversProvider = ServersProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => serversProvider)
        ),
        ChangeNotifierProvider(
          create: ((context) => appConfigProvider)
        ),
      ],
      child: const Main(),
    )
  );
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  List<DisplayMode> modes = <DisplayMode>[];
  DisplayMode? active;
  DisplayMode? preferred;

  Future<void> displayMode() async {
    try {
      modes = await FlutterDisplayMode.supported;
      preferred = await FlutterDisplayMode.preferred;
      active = await FlutterDisplayMode.active;
      await FlutterDisplayMode.setHighRefreshRate();
      setState(() {});
    } catch (_) {
      // ---- //
    }
  }

  @override
  void initState() {
    displayMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MaterialApp(
        title: 'AdGuard Home Manager',
        theme: lightTheme(lightDynamic),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('es', '')
        ],
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        home: Base(appConfigProvider: appConfigProvider),
      ),
    );
  }
}

