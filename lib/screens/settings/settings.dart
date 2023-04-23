import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_server_status/models/server.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/settings/advanced_setings.dart';
import 'package:my_server_status/screens/settings/general_settings.dart';
import 'package:my_server_status/screens/settings/contact_me_modal.dart';
import 'package:my_server_status/screens/settings/customization/customization.dart';
import 'package:my_server_status/screens/servers/servers.dart';
import 'package:my_server_status/widgets/custom_list_tile.dart';
import 'package:my_server_status/widgets/section_label.dart';
import 'package:my_server_status/widgets/custom_settings_tile.dart';

import 'package:my_server_status/functions/open_url.dart';
import 'package:my_server_status/constants/strings.dart';
import 'package:my_server_status/constants/urls.dart';
import 'package:my_server_status/constants/app_icons.dart';
import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/providers/servers_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int? selectedItem;

  final customizationKey = GlobalKey<NavigatorState>();
  final serversKey = GlobalKey<NavigatorState>();
  final generalSettingsKey = GlobalKey<NavigatorState>();
  final advancedSettingsKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);
    final serversProvider = Provider.of<ServersProvider>(context);

    final width = MediaQuery.of(context).size.width;

    void openContactModal() {
      showDialog(
        context: context, 
        builder: (context) => const ContactMeModal()
      );
    }

    void onScreenChange(int val, BuildContext context) {
      if (selectedItem == val) {
        switch (val) {
          case 0:
            customizationKey.currentState!.popUntil((route) => route.isFirst);
            break;

          case 1:
            serversKey.currentState!.popUntil((route) => route.isFirst);
            break;

          case 2:
            generalSettingsKey.currentState!.popUntil((route) => route.isFirst);
            break;

          case 3:
            advancedSettingsKey.currentState!.popUntil((route) => route.isFirst);
            break;

          default:
            break;
        }
      } else {
        if (mounted) {
          setState(() {
            selectedItem = val;
          });
        }
      }
    }

    if (width > 900) {
      return Material(
        color: Colors.transparent,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Scaffold(
                appBar:  AppBar(
                  title: Text(AppLocalizations.of(context)!.settings),
                  centerTitle: false,
                ),
                body: ListView(
                  children: [
                    CustomSettingsTile(
                      title: AppLocalizations.of(context)!.customization,
                      icon: Icons.palette_rounded,
                      subtitle: AppLocalizations.of(context)!.customizationDescription,
                      thisItem: 0, 
                      selectedItem: selectedItem,
                      onTap: () => setState(() => selectedItem = 0),
                    ),
                    CustomSettingsTile(
                      selectedItem: selectedItem,
                      thisItem: 1,
                      icon: Icons.storage_rounded,
                      title: AppLocalizations.of(context)!.servers,
                      subtitle: serversProvider.selectedServer != null && serversProvider.serverConnected != null
                        ? serversProvider.serverConnected == true
                          ? "${AppLocalizations.of(context)!.connectedTo} ${serversProvider.selectedServer!.name}"
                          : "${AppLocalizations.of(context)!.selectedServer} ${serversProvider.selectedServer!.name}"
                        : AppLocalizations.of(context)!.noServerSelected,
                      onTap: () => setState(() => selectedItem = 1),
                    ),
                    CustomSettingsTile(
                      selectedItem: selectedItem,
                      thisItem: 2,
                      icon: Icons.settings,
                      title: AppLocalizations.of(context)!.generalSettings,
                      subtitle: AppLocalizations.of(context)!.generalSettingsDescription,
                      onTap: () => setState(() => selectedItem = 2)
                    ),
                    CustomSettingsTile(
                      selectedItem: selectedItem,
                      thisItem: 3,
                      icon: Icons.build_outlined,
                      title: AppLocalizations.of(context)!.advancedSettings,
                      subtitle: AppLocalizations.of(context)!.advancedSetupDescription,
                      onTap: () => setState(() => selectedItem = 3),
                    ),
                    SectionLabel(
                      label: AppLocalizations.of(context)!.aboutApp,
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 28
                      ),
                    ),
                    CustomSettingsTile(
                      selectedItem: selectedItem,
                      thisItem: 4,
                      title: AppLocalizations.of(context)!.apiRepo, 
                      subtitle: AppLocalizations.of(context)!.apiRepoDescription, 
                      trailing: Icon(
                        Icons.open_in_new_rounded,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onTap: () => openUrl(Urls.apiRepo),
                    ),
                    CustomSettingsTile(
                      selectedItem: selectedItem,
                      thisItem: 5,
                      title: AppLocalizations.of(context)!.contactDeveloper, 
                      subtitle: AppLocalizations.of(context)!.issuesSuggestions, 
                      onTap: openContactModal,
                    ),
                    CustomSettingsTile(
                      selectedItem: selectedItem,
                      thisItem: 6,
                      title: AppLocalizations.of(context)!.appVersion, 
                      subtitle: appConfigProvider.getAppInfo!.version,
                    ),
                    CustomSettingsTile(
                      selectedItem: selectedItem,
                      thisItem: 7,
                      title: AppLocalizations.of(context)!.createdBy, 
                      subtitle: Strings.createdBy,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (Platform.isAndroid && Urls.playStore != "") IconButton(
                            onPressed: () => openUrl(Urls.playStore), 
                            icon: const Icon(
                              MyServerStatusIcons.googlePlay,
                              size: 30,
                            ),
                            tooltip: AppLocalizations.of(context)!.visitGooglePlay,
                          ),
                          if (Urls.gitHub !=  "") IconButton(
                            onPressed: () => openUrl(Urls.gitHub), 
                            icon: const Icon(
                              MyServerStatusIcons.github,
                              size: 30,
                            ),
                            tooltip: AppLocalizations.of(context)!.gitHub,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ),
            Expanded(
              flex: 2,
              child: IndexedStack(
                index: selectedItem,
                children: [
                  Navigator(
                    key: customizationKey,
                    onGenerateRoute: (route) => MaterialPageRoute(
                      settings: route,
                      builder: (context) => const Customization(),
                    ),
                  ),
                  Navigator(
                    key: serversKey,
                    onGenerateRoute: (route) => MaterialPageRoute(
                      settings: route,
                      builder: (context) => const Servers(),
                    ),
                  ),
                  Navigator(
                    key: generalSettingsKey,
                    onGenerateRoute: (route) => MaterialPageRoute(
                      settings: route,
                      builder: (context) => const GeneralSettings(),
                    ),
                  ),
                  Navigator(
                    key: advancedSettingsKey,
                    onGenerateRoute: (route) => MaterialPageRoute(
                      settings: route,
                      builder: (context) => const AdvancedSettings(),
                    ),
                  ),
                ],
              )
            )
          ],
        ),
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settings),
        ),
        body: ListView(
          children: [
            CustomListTile(
              icon: Icons.palette_rounded,
              title: AppLocalizations.of(context)!.customization, 
              subtitle: AppLocalizations.of(context)!.customizationDescription,
              onTap: () {
                if (width > 900) {
                  onScreenChange(0, context);
                }
                else {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const Customization()
                  ));
                }
              },
            ),
            CustomListTile(
              icon: Icons.storage_rounded,
              title: AppLocalizations.of(context)!.servers,
              subtitle: serversProvider.selectedServer != null && serversProvider.serverConnected != null
                ? serversProvider.serverConnected == true
                  ? "${AppLocalizations.of(context)!.connectedTo} ${serversProvider.selectedServer!.name}"
                  : "${AppLocalizations.of(context)!.selectedServer} ${serversProvider.selectedServer!.name}"
                : AppLocalizations.of(context)!.noServerSelected,
              onTap: () {
                if (width > 900) {
                  onScreenChange(1, context);
                }
                else {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const Servers()
                  ));
                }
              },
            ),
            CustomListTile(
              icon: Icons.settings,
              title: AppLocalizations.of(context)!.generalSettings,
              subtitle: AppLocalizations.of(context)!.generalSettingsDescription,
              onTap: () {
                if (width > 900) {
                  onScreenChange(2, context);
                }
                else {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const GeneralSettings()
                  ));
                }
              },
            ),
            CustomListTile(
              icon: Icons.build_outlined,
              title: AppLocalizations.of(context)!.advancedSettings,
              subtitle: AppLocalizations.of(context)!.advancedSetupDescription,
              onTap: () {
                if (width > 900) {
                  onScreenChange(3, context);
                }
                else {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const AdvancedSettings()
                  ));
                }
              },
            ),
            SectionLabel(label: AppLocalizations.of(context)!.aboutApp),
            CustomListTile(
              title: AppLocalizations.of(context)!.apiRepo, 
              subtitle: AppLocalizations.of(context)!.apiRepoDescription, 
              trailing: Icon(
                Icons.open_in_new_rounded,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onTap: () => openUrl(Urls.apiRepo),
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.contactDeveloper, 
              subtitle: AppLocalizations.of(context)!.issuesSuggestions, 
              onTap: openContactModal,
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.appVersion, 
              subtitle: appConfigProvider.getAppInfo!.version,
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.createdBy, 
              subtitle: Strings.createdBy,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (Platform.isAndroid && Urls.playStore != "") IconButton(
                    onPressed: () => openUrl(Urls.playStore), 
                    icon: const Icon(
                      MyServerStatusIcons.googlePlay,
                      size: 30,
                    ),
                    tooltip: AppLocalizations.of(context)!.visitGooglePlay,
                  ),
                  if (Urls.gitHub !=  "") IconButton(
                    onPressed: () => openUrl(Urls.gitHub), 
                    icon: const Icon(
                      MyServerStatusIcons.github,
                      size: 30,
                    ),
                    tooltip: AppLocalizations.of(context)!.gitHub,
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }
  }
}