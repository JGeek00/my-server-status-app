import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/information/storage_modal_details.dart';
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

    final width = MediaQuery.of(context).size.width;

    final diskLayout = storage.diskLayout.where((d) => !(d.device != null && d.device!.contains("boot")));

    return FractionallySizedBox(
      widthFactor: width > 750 ? 0.5 : 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SectionLabel(
              label: AppLocalizations.of(context)!.storage,
              padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 16
              ),
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => showDialog(
                    context: context, 
                    builder: (context) => StorageModalDetails(data: storage)
                  ), 
                  icon: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.showFullDetails, 
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    ],
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}