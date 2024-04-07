import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/custom_list_tile.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/models/storage_info.dart';
import 'package:my_server_status/functions/memory_conversion.dart';
import 'package:my_server_status/providers/app_config_provider.dart';

class StorageModalDetails extends StatelessWidget {
  final StorageInfo data;

  const StorageModalDetails({
    Key? key,
    required this.data
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    final height = MediaQuery.of(context).size.height;

    String generateValue(String? value) {
      return value != null && value != '' && value != 'Default string' 
        ? value
        : 'N/A';
    }

    final blockDevices = appConfigProvider.hideVolumesNoMountPoint
      ? data.blockDevices.where((d) => d.mount != "")
      : data.blockDevices;

    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: height*0.8
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.storage,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context), 
                    icon: const Icon(Icons.close_rounded)
                  )
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
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
                                fontSize: 16
                              ),
                            )
                          ],
                        ),
                      ),
                      ...data.diskLayout.where(
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
                                fontSize: 16
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
                          if (device.size != null) CustomListTile(
                            title: AppLocalizations.of(context)!.size,
                            subtitle: device.size! > 104857600 
                              ? "${convertMemoryToGb(device.size!)} GB" 
                              : "${convertMemoryToMb(device.size!.toDouble())} MB" 
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
                                fontSize: 16
                              ),
                            )
                          ],
                        ),
                      ),
                      ...data.fsSize.map((fs) => Column(
                        children: [
                          SectionLabel(label: fs.fs ?? "Unknown"),
                          CustomListTile(
                            title: AppLocalizations.of(context)!.mountPoint,
                            subtitle: fs.mount,
                          ),
                          CustomListTile(
                            title: AppLocalizations.of(context)!.type,
                            subtitle: fs.type,
                          ),
                          if (fs.size != null) CustomListTile(
                            title: AppLocalizations.of(context)!.size,
                            subtitle: fs.size! > 104857600 
                              ? "${convertMemoryToGb(fs.size!)} GB" 
                              : "${convertMemoryToMb(fs.size!.toDouble())} MB" 
                          ),
                          CustomListTile(
                            title: "RW",
                            subtitle: fs.rw == true 
                              ? AppLocalizations.of(context)!.yes
                              : AppLocalizations.of(context)!.no,
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}