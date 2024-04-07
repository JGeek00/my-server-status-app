import 'dart:io';

import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_size/window_size.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/base.dart';
import 'package:my_server_status/config/theme.dart';
import 'package:my_server_status/classes/http_override.dart';
import 'package:my_server_status/services/database/database.dart';
import 'package:my_server_status/config/globals.dart';
import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/constants/colors.dart';
import 'package:my_server_status/providers/servers_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowMinSize(const Size(500, 500));
  }

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await dotenv.load(fileName: '.env');

  final appConfigProvider = AppConfigProvider();
  final serversProvider = ServersProvider();

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    appConfigProvider.setAndroidInfo(androidInfo);
  }
  if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    appConfigProvider.setIosInfo(iosInfo);
  }

  final dbData = await loadDb(appConfigProvider.androidDeviceInfo != null && appConfigProvider.androidDeviceInfo!.version.sdkInt >= 31);

  if (dbData['appConfig']['overrideSslCheck'] == 1) {
    HttpOverrides.global = MyHttpOverrides();
  }

  serversProvider.setDbInstance(dbData['dbInstance']);
  appConfigProvider.saveFromDb(dbData['dbInstance'], dbData['appConfig']);
  serversProvider.saveFromDb(dbData['servers']);

  PackageInfo appInfo = await PackageInfo.fromPlatform();
  appConfigProvider.setAppInfo(appInfo);

  if (
    (
      kReleaseMode &&
      (dotenv.env['SENTRY_DSN'] != null && dotenv.env['SENTRY_DSN'] != "")
    ) || (
      dotenv.env['ENABLE_SENTRY'] == "true" &&
      (dotenv.env['SENTRY_DSN'] != null && dotenv.env['SENTRY_DSN'] != "")
    )
  ) {
    SentryFlutter.init(
      (options) {
        options.dsn = dotenv.env['SENTRY_DSN'];
        options.sendDefaultPii = false;
      },
      appRunner: () => runApp(
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
      )
    );
  }
  else {
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
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MaterialApp(
        title: 'My Server Status',
        theme: appConfigProvider.androidDeviceInfo != null && appConfigProvider.androidDeviceInfo!.version.sdkInt >= 31
          ? appConfigProvider.useDynamicColor == true
            ? lightTheme(lightDynamic)
            : lightThemeOldVersions(colors[appConfigProvider.staticColor])
          : lightThemeOldVersions(colors[appConfigProvider.staticColor]),
        darkTheme: appConfigProvider.androidDeviceInfo != null && appConfigProvider.androidDeviceInfo!.version.sdkInt >= 31
          ? appConfigProvider.useDynamicColor == true
            ? darkTheme(darkDynamic)
            : darkThemeOldVersions(colors[appConfigProvider.staticColor])
          : darkThemeOldVersions(colors[appConfigProvider.staticColor]),
        themeMode: appConfigProvider.selectedTheme,
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
        scaffoldMessengerKey: scaffoldMessengerKey,
        home: Base(appConfigProvider: appConfigProvider),
      ),
    );
  }
}

