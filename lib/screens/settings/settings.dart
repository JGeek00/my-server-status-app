import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/settings/advanced_setings.dart';
import 'package:my_server_status/screens/settings/general_settings.dart';
import 'package:my_server_status/screens/settings/contact_me_modal.dart';
import 'package:my_server_status/screens/settings/customization/customization.dart';
import 'package:my_server_status/screens/servers/servers.dart';
import 'package:my_server_status/widgets/custom_list_tile.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/functions/open_url.dart';
import 'package:my_server_status/constants/strings.dart';
import 'package:my_server_status/constants/urls.dart';
import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/providers/servers_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);
    final serversProvider = Provider.of<ServersProvider>(context);

    void navigateServers() {
      Future.delayed(const Duration(milliseconds: 0), (() {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const Servers())
        );
      }));
    }

    void openContactModal() {
      showDialog(
        context: context, 
        builder: (context) => const ContactMeModal()
      );
    }

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
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => const Customization()
            ))
          ),
          CustomListTile(
            icon: Icons.storage_rounded,
            title: AppLocalizations.of(context)!.servers,
            subtitle: serversProvider.selectedServer != null && serversProvider.serverConnected != null
              ? serversProvider.serverConnected == true
                ? "${AppLocalizations.of(context)!.connectedTo} ${serversProvider.selectedServer!.name}"
                : "${AppLocalizations.of(context)!.selectedServer} ${serversProvider.selectedServer!.name}"
              : AppLocalizations.of(context)!.noServerSelected,
            onTap: navigateServers,
          ),
          CustomListTile(
            icon: Icons.settings,
            title: AppLocalizations.of(context)!.generalSettings,
            subtitle: AppLocalizations.of(context)!.generalSettingsDescription,
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const GeneralSettings()
                )
              )
            },
          ),
          CustomListTile(
            icon: Icons.build_outlined,
            title: AppLocalizations.of(context)!.advancedSettings,
            subtitle: AppLocalizations.of(context)!.advancedSetupDescription,
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AdvancedSettings()
                )
              )
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
                if (Urls.playStore != "") IconButton(
                  onPressed: () => openUrl(Urls.playStore), 
                  icon: SvgPicture.asset(
                    'assets/resources/google-play.svg',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    width: 30,
                    height: 30,
                  ),
                  tooltip: AppLocalizations.of(context)!.visitGooglePlay,
                ),
                if (Urls.gitHub !=  "") IconButton(
                  onPressed: () => openUrl(Urls.gitHub), 
                  icon: SvgPicture.asset(
                    'assets/resources/github.svg',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    width: 30,
                    height: 30,
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