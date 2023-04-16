import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/config/app_screens.dart';
import 'package:my_server_status/models/app_screen.dart';
import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/providers/servers_provider.dart';

class CustomMenuBar extends StatelessWidget {
  final Widget child;

  const CustomMenuBar({
    Key? key,
    required this.child
  }) : super(key: key);

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

        default:
          return '';
      }
    }

    return PlatformMenuBar(
      menus: [
        PlatformMenu(
          label: 'My Server Status',
          menus: <PlatformMenuItem>[
            if (
              PlatformProvidedMenuItem.hasMenu(PlatformProvidedMenuItemType.about)
            ) const PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.about,
            ),
            if (
              PlatformProvidedMenuItem.hasMenu(PlatformProvidedMenuItemType.quit)
            ) const PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.quit,
            ),
          ],
        ),
        PlatformMenu(
          label: AppLocalizations.of(context)!.screens,
          menus: <PlatformMenuItem>[
            PlatformMenuItemGroup(
              members: screens.asMap().entries.map((e) => PlatformMenuItem(
                label: "${appConfigProvider.selectedScreen == e.key ? '✔' : ''} ${translatedName(e.value.name)}",
                onSelected: () => appConfigProvider.setSelectedScreen(e.key),
              )).toList()
            ),
          ],
        ),
      ],
      child: child,
    );
  }
}