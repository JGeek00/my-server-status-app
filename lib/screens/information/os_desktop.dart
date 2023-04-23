import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:my_server_status/screens/information/os_modal_details.dart';
import 'package:my_server_status/widgets/compact_data_row.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/providers/servers_provider.dart';

class OsDesktop extends StatelessWidget {
  const OsDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);
    final os = serversProvider.systemSpecsInfo.data!.osInfo;
    
    final width = MediaQuery.of(context).size.width;

    return FractionallySizedBox(
      widthFactor: width > 750 ? 0.5 : 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SectionLabel(
              label: AppLocalizations.of(context)!.operatingSystem,
              padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 16
              ),
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.platform, 
              value: os.platform
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.operatingSystem, 
              value: os.distro
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.version, 
              value: os.release
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.architecture, 
              value: os.arch
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.hostName, 
              value: os.hostname
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => showDialog(
                    context: context, 
                    builder: (context) => OsModalDetails(data: os)
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