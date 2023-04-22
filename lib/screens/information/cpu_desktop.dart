import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:my_server_status/widgets/compact_data_row.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/functions/memory_conversion.dart';
import 'package:my_server_status/providers/servers_provider.dart';

class CpuDesktop extends StatelessWidget {
  const CpuDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);
    final cpu = serversProvider.systemSpecsInfo.data!.cpuInfo;

    return FractionallySizedBox(
      widthFactor: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SectionLabel(
              label: "CPU"
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.model, 
              value: "${cpu.cpu.manufacturer} ${cpu.cpu.brand}",
            ),
            CompactDataRow(
              label: "${AppLocalizations.of(context)!.cores} / ${AppLocalizations.of(context)!.threads}", 
              value: "${cpu.cpu.physicalCores.toString()} / ${cpu.cpu.cores.toString()}",
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.baseFrequency, 
              value: "${cpu.cpu.speed.toString()} GHz",
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.maxFrequency, 
              value: "${cpu.cpu.speedMax.toString()} GHz",
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.cache, 
              value: "${convertMemoryToMb(
                ((cpu.cpu.cache.l1d ?? 0) +
                (cpu.cpu.cache.l1i ?? 0) + 
                (cpu.cpu.cache.l2 ?? 0) + 
                (cpu.cpu.cache.l3 ?? 0)).toDouble()
              )} MB",
            ),
          ],
        ),
      ),
    );
  }
}