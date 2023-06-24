import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/config/app_screens.dart';
import 'package:my_server_status/providers/servers_provider.dart';
import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/models/app_screen.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    List<AppScreen> screens = serversProvider.selectedServer != null
      ? screensServerConnected
      : screensSelectServer;

    String translatedName(String key) {
      switch (key) {
        case 'connect':
          return AppLocalizations.of(context)!.connect;

        case 'home':
          return AppLocalizations.of(context)!.home;

        case 'settings':
          return AppLocalizations.of(context)!.settings;

        case 'information':
          return AppLocalizations.of(context)!.information;

        case 'status':
          return AppLocalizations.of(context)!.status;

        case 'docker':
          return "Docker";

        default:
          return '';
      }
    }

    return NavigationBar(
      selectedIndex: appConfigProvider.selectedScreen,
      destinations: screens.map((screen) => NavigationDestination(
        icon: Icon(
          screen.icon,
          color: screens[appConfigProvider.selectedScreen] == screen
            ? Theme.of(context).colorScheme.onSecondaryContainer
            : Theme.of(context).colorScheme.onSurfaceVariant,
          size: screen.name == 'docker'
            ? 20 : 24,
        ), 
        label: translatedName(screen.name)
      )).toList(),
      onDestinationSelected: (value) {
        appConfigProvider.setSelectedScreen(value);
      },
    );
  }
}