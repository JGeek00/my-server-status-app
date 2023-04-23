import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/information/system_modal_details.dart';

import 'package:my_server_status/widgets/compact_data_row.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/providers/servers_provider.dart';

class SystemDesktop extends StatelessWidget {
  const SystemDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);
    final system = serversProvider.systemSpecsInfo.data!.systemInfo;

    final width = MediaQuery.of(context).size.width;

    return FractionallySizedBox(
      widthFactor: width > 750 ? 0.5 : 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SectionLabel(
              label: AppLocalizations.of(context)!.system,
              padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 16
              ),
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.manufacturer, 
              value: system.system.manufacturer
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.model, 
              value: system.system.model
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.biosVendor, 
              value: system.bios.vendor
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.biosVersion, 
              value: system.bios.version
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.biosReleaseDate, 
              value: system.bios.releaseDate
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => showDialog(
                    context: context, 
                    builder: (context) => SystemModalDetails(data: system)
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