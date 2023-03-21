import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/custom_list_tile.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/functions/memory_conversion.dart';
import 'package:my_server_status/providers/servers_provider.dart';

class OsTab extends StatelessWidget {
  const OsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);

    String generateValue(String? value) {
      return value != null && value != '' && value != 'Default string' 
        ? value
        : 'N/A';
    }

    switch (serversProvider.systemSpecsInfo.loadStatus) {
      case 0:
        return SizedBox(
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 30),
                Text(
                  AppLocalizations.of(context)!.loadingHardwareInfo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )
              ],
            ),
          ),
        );
        
      case 1:
        final os = serversProvider.systemSpecsInfo.data!.osInfo;
        return ListView(
          padding: const EdgeInsets.only(top: 16),
          children: [
            CustomListTile(
              title: AppLocalizations.of(context)!.operatingSystem,
              subtitle: os.distro,
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.platform,
              subtitle: os.platform,
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.version,
              subtitle: os.release,
            ),
            CustomListTile(
              title: "Build",
              subtitle: generateValue(os.build),
            ),
            CustomListTile(
              title: "Kernel",
              subtitle: os.kernel,
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.architecture,
              subtitle: os.arch,
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.hostName,
              subtitle: os.hostname,
            ),
            CustomListTile(
              title: "UEFI",
              subtitle: os.uefi == true 
                ? AppLocalizations.of(context)!.yes
                : AppLocalizations.of(context)!.no,
            ),
            const SizedBox(height: 16)
          ],
        );

      case 2: 
        return SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.error,
                color: Colors.red,
                size: 50,
              ),
              const SizedBox(height: 30),
              Text(
                AppLocalizations.of(context)!.hardwareInfoNotLoaded,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
       
      default:
        return const SizedBox();
    }
  }
}