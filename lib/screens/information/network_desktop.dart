import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:my_server_status/widgets/compact_data_row.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/providers/servers_provider.dart';

class NetworkDesktop extends StatelessWidget {
  const NetworkDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);
    final network = serversProvider.systemSpecsInfo.data!.networkInfo;

    return FractionallySizedBox(
      widthFactor: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SectionLabel(
              label: AppLocalizations.of(context)!.network
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
          ],
        ),
      ),
    );
  }
}