import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/custom_list_tile.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/functions/memory_conversion.dart';
import 'package:my_server_status/providers/servers_provider.dart';

class MemoryTab extends StatelessWidget {
  const MemoryTab({Key? key}) : super(key: key);

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
        final memory = serversProvider.systemSpecsInfo.data!.memoryInfo;

        int filledBanks = 0;
        for (var i in memory.memLayout) {
          i.type != 'Empty' ? filledBanks++ : null;
        }

        return ListView(
          padding: const EdgeInsets.only(top: 16),
          children: [
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "${AppLocalizations.of(context)!.memory}: ${convertMemoryToGb(memory.memLayout.map((e) => e.size).reduce((a, b) => a+b))} GB",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(
                      "${AppLocalizations.of(context)!.filledBanks}: $filledBanks/${memory.memLayout.length}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ...memory.memLayout.where((m) => m.type != "Empty").map((m) => Column(
              children: [
                SectionLabel(
                  label: m.bank
                ),
                CustomListTile(
                  title: AppLocalizations.of(context)!.size,
                  subtitle: "${convertMemoryToGb(m.size)} GB",
                ),
                CustomListTile(
                  title: AppLocalizations.of(context)!.type,
                  subtitle: m.type,
                ),
                CustomListTile(
                  title: AppLocalizations.of(context)!.formFactor,
                  subtitle: m.formFactor,
                ),
                CustomListTile(
                  title: "ECC",
                  subtitle: m.ecc == true 
                    ? AppLocalizations.of(context)!.yes
                    : AppLocalizations.of(context)!.no,
                ),
                CustomListTile(
                  title: AppLocalizations.of(context)!.voltage,
                  subtitle: "${m.voltageConfigured} V",
                ),
              ],
            ))
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