import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:my_server_status/widgets/compact_data_row.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/providers/servers_provider.dart';
import 'package:my_server_status/functions/memory_conversion.dart';

class MemoryDesktop extends StatelessWidget {
  const MemoryDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);
    final memory = serversProvider.systemSpecsInfo.data!.memoryInfo;

    int filledBanks = 0;
    for (var i in memory.memLayout) {
      i.type != 'Empty' ? filledBanks++ : null;
    }

    return FractionallySizedBox(
      widthFactor: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SectionLabel(
              label: AppLocalizations.of(context)!.memory
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.installedMemory, 
              value: "${convertMemoryToGb(memory.memLayout.map((e) => e.size).reduce((a, b) => a+b))} GB",
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.filledBanks, 
              value: "$filledBanks / ${memory.memLayout.length}"
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.type, 
              value: memory.memLayout[0].type
            ),
          ],
        ),
      ),
    );
  }
}