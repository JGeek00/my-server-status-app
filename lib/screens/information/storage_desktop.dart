import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/compact_data_row.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/functions/memory_conversion.dart';
import 'package:my_server_status/providers/servers_provider.dart';

class StorageDesktop extends StatelessWidget {
  const StorageDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);
    final storage = serversProvider.systemSpecsInfo.data!.storageInfo;

    final diskLayout = storage.diskLayout.where((d) => !(d.device != null && d.device!.contains("boot")));

    return FractionallySizedBox(
      widthFactor: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SectionLabel(
              label: AppLocalizations.of(context)!.storage
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.drivesInstalled, 
              value: storage.diskLayout.where((d) => !(d.device != null && d.device!.contains("boot"))).length.toString()
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.totalCapacity, 
              value: "${convertMemoryToGb(diskLayout.map((e) => e.size ?? 0).reduce((a, b) => a+b))} GB"
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.volumes, 
              value: storage.fsSize.length.toString()
            ),
          ],
        ),
      ),
    );
  }
}