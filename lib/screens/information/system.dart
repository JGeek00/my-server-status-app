import 'package:flutter/material.dart';
import 'package:my_server_status/functions/memory_conversion.dart';
import 'package:my_server_status/widgets/custom_list_tile.dart';
import 'package:my_server_status/widgets/section_label.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/providers/servers_provider.dart';

class SystemTab extends StatelessWidget {
  const SystemTab({Key? key}) : super(key: key);

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
        final system = serversProvider.systemSpecsInfo.data!.systemInfo;
        return ListView(
          padding: const EdgeInsets.only(top: 16),
          children: [
            SectionLabel(label: AppLocalizations.of(context)!.system),
            CustomListTile(
              title: AppLocalizations.of(context)!.manufacturer,
              subtitle: generateValue(system.system.manufacturer),
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.model,
              subtitle: generateValue(system.system.model),
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.version,
              subtitle: generateValue(system.system.version),
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.serial,
              subtitle: generateValue(system.system.serial),
            ),
            const SectionLabel(label: "BIOS"),
            CustomListTile(
              title: AppLocalizations.of(context)!.vendor,
              subtitle: generateValue(system.bios.vendor),
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.version,
              subtitle: generateValue(system.bios.version),
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.releaseDate,
              subtitle: generateValue(system.bios.releaseDate),
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.revision,
              subtitle: generateValue(system.bios.revision),
            ),
            SectionLabel(label: AppLocalizations.of(context)!.baseboard),
            CustomListTile(
              title: AppLocalizations.of(context)!.manufacturer,
              subtitle: generateValue(system.baseboard.manufacturer),
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.model,
              subtitle: generateValue(system.baseboard.model),
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.version,
              subtitle: generateValue(system.baseboard.version),
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.serial,
              subtitle: generateValue(system.baseboard.serial),
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.maxAllowedMemory,
              subtitle: "${convertMemoryToGb(system.baseboard.memMax)} GB",
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.memorySlots,
              subtitle: system.baseboard.memSlots.toString(),
            ),
            SectionLabel(label: AppLocalizations.of(context)!.chassis),
            CustomListTile(
              title: AppLocalizations.of(context)!.manufacturer,
              subtitle: generateValue(system.chassis.manufacturer),
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.model,
              subtitle: generateValue(system.chassis.model),
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.version,
              subtitle: generateValue(system.chassis.version),
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