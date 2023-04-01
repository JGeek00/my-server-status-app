import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/custom_list_tile.dart';
import 'package:my_server_status/widgets/section_label.dart';
import 'package:my_server_status/widgets/tab_content.dart';

import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/functions/memory_conversion.dart';
import 'package:my_server_status/providers/servers_provider.dart';

class StorageTab extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const StorageTab({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    String generateValue(String? value) {
      return value != null && value != '' && value != 'Default string' 
        ? value
        : 'N/A';
    }

    return CustomTabContent(
      loadingGenerator: () => Column(
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
      contentGenerator: () {
        final storage = serversProvider.systemSpecsInfo.data!.storageInfo;
        final blockDevices = appConfigProvider.hideVolumesNoMountPoint
          ? storage.blockDevices.where((d) => d.mount != "")
          : storage.blockDevices;
        return [
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
          ...storage.diskLayout.where(
            (d) => !(d.device != null && d.device!.contains("boot"))
          ).toList().asMap().entries.map((disk) => Column(
            children: [
              SectionLabel(
                label: disk.value.name  != "" || disk.value.device != "" 
                  ? (disk.value.name != "" ? disk.value.name : disk.value.device)!
                  : "${AppLocalizations.of(context)!.storageDevice} ${disk.key}"
              ),
              CustomListTile(
                title: AppLocalizations.of(context)!.size,
                subtitle: disk.value.size != null 
                  ? disk.value.size! > 104857600 
                    ? "${convertMemoryToGb(disk.value.size!)} GB" 
                    : "${convertMemoryToMb(disk.value.size!.toDouble())} MB" 
                  : "N/A",
              ),
              CustomListTile(
                title: AppLocalizations.of(context)!.type,
                subtitle: disk.value.type,
              ),
              CustomListTile(
                title: AppLocalizations.of(context)!.vendor,
                subtitle: generateValue(disk.value.vendor),
              ),
            ],
          )),
          if (blockDevices.isNotEmpty) Padding(
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
          ...blockDevices.map((device) => Column(
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
        ];
      }, 
      errorGenerator: () => Column(
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
      loadStatus: serversProvider.systemSpecsInfo.loadStatus,
      onRefresh: onRefresh
    );
  }
}