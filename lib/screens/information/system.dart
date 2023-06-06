import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/tab_content.dart';
import 'package:my_server_status/widgets/custom_list_tile.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/functions/memory_conversion.dart';
import 'package:my_server_status/providers/servers_provider.dart';

class SystemTab extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const SystemTab({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);

    final width = MediaQuery.of(context).size.width;

    String generateValue(String? value) {
      return value != null && value != '' && value != 'Default string' 
        ? value
        : 'N/A';
    }

    Widget listTile(Widget widget) {
      return SizedBox(
        width: width > 700
          ? width > 900 
            ? width > 1300 
              ? (width-91)/3
              : (width-91)/2 
            : width/2
          : width,
        child: widget,
      );
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
        final system = serversProvider.systemSpecsInfo.data!.systemInfo;
        return [
          const SizedBox(height: 16),
          SectionLabel(label: AppLocalizations.of(context)!.system),
          Wrap(
            children: [
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.manufacturer,
                  subtitle: generateValue(system.system.manufacturer),
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.model,
                  subtitle: generateValue(system.system.model),
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.version,
                  subtitle: generateValue(system.system.version),
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.serial,
                  subtitle: generateValue(system.system.serial),
                ),
              )
            ],
          ),
          const SectionLabel(label: "BIOS"),
          Wrap(
            children: [
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.vendor,
                  subtitle: generateValue(system.bios.vendor),
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.version,
                  subtitle: generateValue(system.bios.version),
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.releaseDate,
                  subtitle: generateValue(system.bios.releaseDate),
                )
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.revision,
                  subtitle: generateValue(system.bios.revision),
                ),
              ),
            ],
          ),
          SectionLabel(label: AppLocalizations.of(context)!.baseboard),
          Wrap(
            children: [
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.manufacturer,
                  subtitle: generateValue(system.baseboard.manufacturer),
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.model,
                  subtitle: generateValue(system.baseboard.model),
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.version,
                  subtitle: generateValue(system.baseboard.version),
                )
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.serial,
                  subtitle: generateValue(system.baseboard.serial),
                )
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.maxAllowedMemory,
                  subtitle: system.baseboard.memMax != null
                    ? "${convertMemoryToGb(system.baseboard.memMax!)} GB"
                    : "N/A",
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.memorySlots,
                  subtitle: system.baseboard.memSlots.toString(),
                )
              ),
            ],
          ),
          SectionLabel(label: AppLocalizations.of(context)!.chassis),
          Wrap(
            children: [
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.manufacturer,
                  subtitle: generateValue(system.chassis.manufacturer),
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.model,
                  subtitle: generateValue(system.chassis.model),
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.version,
                  subtitle: generateValue(system.chassis.version),
                ),
              ),
            ],
          ),
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