import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/custom_list_tile.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/functions/memory_conversion.dart';
import 'package:my_server_status/providers/servers_provider.dart';

class StorageTab extends StatelessWidget {
  const StorageTab({Key? key}) : super(key: key);

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
        final storage = serversProvider.systemSpecsInfo.data!.storageInfo;
        int drivesIndex = 0;
        return ListView(
          padding: const EdgeInsets.only(top: 16),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.storageDevices,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                    ),
                  )
                ],
              ),
            ),
            ...storage.diskLayout.where((d) => !(d.device != null && d.device!.contains("boot"))).map((disk) {
              drivesIndex++;
              return Column(
                children: [
                  SectionLabel(
                    label: disk.name  != "" || disk.device != "" 
                      ? (disk.name != "" ? disk.name : disk.device)!
                      : "${AppLocalizations.of(context)!.storageDevice} $drivesIndex"
                  ),
                  CustomListTile(
                    title: AppLocalizations.of(context)!.size,
                    subtitle: disk.size != null 
                      ? disk.size! > 104857600 
                        ? "${convertMemoryToGb(disk.size!)} GB" 
                        : "${convertMemoryToMb(disk.size!.toDouble())} MB" 
                      : "N/A",
                  ),
                  CustomListTile(
                    title: AppLocalizations.of(context)!.type,
                    subtitle: disk.type,
                  ),
                  CustomListTile(
                    title: AppLocalizations.of(context)!.vendor,
                    subtitle: generateValue(disk.vendor),
                  ),
                ],
              );
            }),
            Padding(
              padding: const EdgeInsets.only(
                top: 24,
                bottom: 8
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.volumes,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                    ),
                  )
                ],
              ),
            ),
            ...storage.blockDevices.where((d) => d.type == "part" || d.type == "lvm").map((device) => Column(
              children: [
                SectionLabel(label: device.name),
                if (device.device != null) CustomListTile(
                  title: AppLocalizations.of(context)!.storageDevice,
                  subtitle: device.device,
                ),
                CustomListTile(
                  title: AppLocalizations.of(context)!.type,
                  subtitle: device.type,
                ),
                CustomListTile(
                  title: AppLocalizations.of(context)!.size,
                  subtitle: device.size > 104857600 
                    ? "${convertMemoryToGb(device.size)} GB" 
                    : "${convertMemoryToMb(device.size.toDouble())} MB" 
                ),
                if (device.mount != "") CustomListTile(
                  title: AppLocalizations.of(context)!.mountPoint,
                  subtitle: device.mount,
                )
              ],
            )),
            Padding(
              padding: const EdgeInsets.only(
                top: 24,
                bottom: 8
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.filesSystem,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                    ),
                  )
                ],
              ),
            ),
            ...storage.fsSize.map((fs) => Column(
              children: [
                SectionLabel(label: fs.fs),
                CustomListTile(
                  title: AppLocalizations.of(context)!.mountPoint,
                  subtitle: fs.mount,
                ),
                CustomListTile(
                  title: AppLocalizations.of(context)!.type,
                  subtitle: fs.type,
                ),
                CustomListTile(
                  title: AppLocalizations.of(context)!.size,
                  subtitle: fs.size > 104857600 
                    ? "${convertMemoryToGb(fs.size)} GB" 
                    : "${convertMemoryToMb(fs.size.toDouble())} MB" 
                ),
                CustomListTile(
                  title: "RW",
                  subtitle: fs.rw == true 
                    ? AppLocalizations.of(context)!.yes
                    : AppLocalizations.of(context)!.no,
                ),
              ],
            )),
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