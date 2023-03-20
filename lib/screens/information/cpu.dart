import 'package:flutter/material.dart';
import 'package:my_server_status/functions/memory_conversion.dart';
import 'package:my_server_status/widgets/custom_list_tile.dart';
import 'package:my_server_status/widgets/section_label.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/providers/servers_provider.dart';

class CpuTab extends StatelessWidget {
  const CpuTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);

    String generateValue(String? value) {
      return value != null && value != '' && value != 'Default string' 
        ? value
        : 'N/A';
    }

    Widget manufacturerLogo(String manufacturer) {
      switch (manufacturer) {
        case 'Intel':
          return Image.asset(
            'assets/resources/intel.png',
            height: 80,
          );
          
        case 'AMD':
          return Image.asset(
            'assets/resources/amd.png',
            height: 90,
          );

        case 'apple':
          return Image.asset(
            'assets/resources/apple-silicon.png',
            height: 90,
          );

        default:
          return const SizedBox();
      }
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
        final cpu = serversProvider.systemSpecsInfo.data!.cpuInfo;
        return ListView(
          padding: const EdgeInsets.only(top: 0),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: manufacturerLogo(cpu.cpu.manufacturer)
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          cpu.cpu.manufacturer,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        Text(
                          cpu.cpu.brand,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SectionLabel(label: AppLocalizations.of(context)!.cores),
            CustomListTile(
              title: AppLocalizations.of(context)!.physicalCores,
              subtitle: cpu.cpu.physicalCores.toString(),
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.threads,
              subtitle: cpu.cpu.cores.toString(),
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.performanceCores,
              subtitle: cpu.cpu.performanceCores.toString(),
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.efficiencyCores,
              subtitle: cpu.cpu.efficiencyCores.toString(),
            ),
            SectionLabel(label: AppLocalizations.of(context)!.speed),
            CustomListTile(
              title: AppLocalizations.of(context)!.baseFrequency,
              subtitle: "${cpu.cpu.speed} GHz",
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.minFrequency,
              subtitle: "${cpu.cpu.speedMin} GHz",
            ),
            CustomListTile(
              title: AppLocalizations.of(context)!.maxFrequency,
              subtitle: "${cpu.cpu.speedMax} GHz",
            ),
            SectionLabel(label: AppLocalizations.of(context)!.cache),
            CustomListTile(
              title: "L1",
              subtitle: cpu.cpu.cache.l1d != null || cpu.cpu.cache.l1i != null
                ? "${convertMemoryToKb((cpu.cpu.cache.l1d ?? 0) + (cpu.cpu.cache.l1i ?? 0))} KB"
                : "N/A",
            ),
            CustomListTile(
              title: "L2",
              subtitle: cpu.cpu.cache.l2 != null ? "${convertMemoryToMb(cpu.cpu.cache.l2!)} MB" : 'N/A',
            ),
            CustomListTile(
              title: "L3",
              subtitle: cpu.cpu.cache.l3 != null ? "${convertMemoryToMb(cpu.cpu.cache.l3!)} MB" : 'N/A',
            ),
            SectionLabel(label: AppLocalizations.of(context)!.other),
            CustomListTile(
              title: AppLocalizations.of(context)!.socket,
              subtitle: generateValue(cpu.cpu.socket),
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