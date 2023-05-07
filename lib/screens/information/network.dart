import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/custom_list_tile.dart';
import 'package:my_server_status/widgets/section_label.dart';
import 'package:my_server_status/widgets/tab_content.dart';

import 'package:my_server_status/extensions/capitalize.dart';
import 'package:my_server_status/providers/servers_provider.dart';

class NetworkTab extends StatefulWidget {
  final Future<void> Function() onRefresh;

  const NetworkTab({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<NetworkTab> createState() => _NetworkTabState();
}

class _NetworkTabState extends State<NetworkTab> {
  String selectedEntry = "";

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);

    if (selectedEntry == "" && serversProvider.serverInfo.data != null) {
      setState(() => selectedEntry = serversProvider.serverInfo.data!.network[0].iface);
    }

    final width = MediaQuery.of(context).size.width;

    String generateValue(String? value) {
      return value != null && value != '' && value != 'Default string' 
        ? value
        : 'N/A';
    }

    Widget listTile(Widget widget) {
      return SizedBox(
         width: width > 700
          ? width > 900 
            ? width > 1300 
              ? (width-91)/3
              : (width-91)/2 
            : width/2
          : width,
        child: widget,
      );
    }

    String interfaceType(String? type) {
      if (type == 'wired') {
        return AppLocalizations.of(context)!.wired;
      } else if (type == 'wireless') {
        return AppLocalizations.of(context)!.wireless;
      } else if (type == 'virtual') {
        return AppLocalizations.of(context)!.virtual;
      } else {
        return "N/A";
      }
    }

    return CustomTabContent(
      loadingGenerator: () => Column(
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
      contentGenerator: () {
        final network = serversProvider.systemSpecsInfo.data!.networkInfo;
        final selectedInterface = network.networkInterfaces.firstWhere((i) => i.iface == selectedEntry);
        return [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField(
              value: selectedEntry,
              items: network.networkInterfaces.map((e) => DropdownMenuItem(
                value: e.iface,
                child: Text(e.iface),
              )).toList(), 
              onChanged: (value) => setState(() => selectedEntry = value.toString()),
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                label: Text(AppLocalizations.of(context)!.interfaces),                 
              ),
              alignment: AlignmentDirectional.centerStart,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Column(
            children: [
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.state,
                  subtitle: selectedInterface.operstate == 'up' 
                    ? AppLocalizations.of(context)!.up
                    : AppLocalizations.of(context)!.down,
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.isDefault,
                  subtitle: selectedInterface.networkInterfaceDefault == true 
                    ? AppLocalizations.of(context)!.yes
                    : AppLocalizations.of(context)!.no,
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.ipv4address,
                  subtitle: generateValue(selectedInterface.ip4),
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.ipv4subnet,
                  subtitle: generateValue(selectedInterface.ip4Subnet),
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.ipv6address,
                  subtitle: generateValue(selectedInterface.ip6),
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.ipv6subnet,
                  subtitle: generateValue(selectedInterface.ip6Subnet),
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.macAddress,
                  subtitle: generateValue(selectedInterface.mac),
                ),
              ),
              if (selectedInterface.speed != null) listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.speed,
                  subtitle: "${selectedInterface.speed.toString()} Mbps",
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.internalInterface,
                  subtitle: selectedInterface.internal == true 
                    ? AppLocalizations.of(context)!.yes
                    : AppLocalizations.of(context)!.no,
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.virtualInterface,
                  subtitle: selectedInterface.virtual == true 
                    ? AppLocalizations.of(context)!.yes
                    : AppLocalizations.of(context)!.no,
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.interfaceType,
                  subtitle: interfaceType(selectedInterface.type)
                ),
              ),
              if (selectedInterface.duplex != null && selectedInterface.duplex != "") listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.duplex,
                  subtitle: selectedInterface.duplex!.capitalize()
                ),
              ),
              if (selectedInterface.mtu != null) listTile(
                  CustomListTile(
                  title: "MTU",
                  subtitle: selectedInterface.mtu.toString(),
                )
              )
            ],
          ),
          const SizedBox(height: 16)
        ];
      }, 
      errorGenerator: () => Column(
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
      loadStatus: serversProvider.systemSpecsInfo.loadStatus,
      onRefresh: widget.onRefresh
    );
  }
}