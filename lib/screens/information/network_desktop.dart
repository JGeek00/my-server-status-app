import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:my_server_status/screens/information/network_modal_details.dart';
import 'package:my_server_status/widgets/compact_data_row.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/providers/servers_provider.dart';

class NetworkDesktop extends StatelessWidget {
  const NetworkDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);
    final network = serversProvider.systemSpecsInfo.data!.networkInfo;

    final width = MediaQuery.of(context).size.width;

    return FractionallySizedBox(
      widthFactor: width > 750 ? 0.5 : 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SectionLabel(
              label: AppLocalizations.of(context)!.network,
              padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 16
              ),
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.interfaces, 
              value: network.networkInterfaces.length.toString()
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.onService, 
              value: network.networkInterfaces.where((i) => i.operstate == "up").length.toString()
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.ipv4address, 
              value: network.networkInterfaces.where((i) => i.networkInterfaceDefault == true).toList()[0].ip4
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.ipv6address, 
              value: network.networkInterfaces.where((i) => i.networkInterfaceDefault == true).toList()[0].ip6
            ),
            CompactDataRow(
              label: AppLocalizations.of(context)!.speed, 
              value: "${network.networkInterfaces.where((i) => i.networkInterfaceDefault == true).toList()[0].speed.toString()} Mbps"
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => showDialog(
                    context: context, 
                    builder: (context) => NetworkModalDetails(data: network)
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