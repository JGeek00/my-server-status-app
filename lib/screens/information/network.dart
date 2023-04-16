import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/custom_list_tile.dart';
import 'package:my_server_status/widgets/section_label.dart';
import 'package:my_server_status/widgets/tab_content.dart';

import 'package:my_server_status/extensions/capitalize.dart';
import 'package:my_server_status/providers/servers_provider.dart';

class NetworkTab extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const NetworkTab({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);

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
        return [
            ...network.networkInterfaces.map((i) => Column(
            children: [
              SectionLabel(label: i.iface),
              Wrap(
                children: [
                  listTile(
                    CustomListTile(
                      title: AppLocalizations.of(context)!.state,
                      subtitle: i.operstate == 'up' 
                        ? AppLocalizations.of(context)!.up
                        : AppLocalizations.of(context)!.down,
                    ),
                  ),
                  listTile(
                    CustomListTile(
                      title: AppLocalizations.of(context)!.isDefault,
                      subtitle: i.networkInterfaceDefault == true 
                        ? AppLocalizations.of(context)!.yes
                        : AppLocalizations.of(context)!.no,
                    ),
                  ),
                  listTile(
                    CustomListTile(
                      title: AppLocalizations.of(context)!.ipv4address,
                      subtitle: generateValue(i.ip4),
                    ),
                  ),
                  listTile(
                    CustomListTile(
                      title: AppLocalizations.of(context)!.ipv4subnet,
                      subtitle: generateValue(i.ip4Subnet),
                    ),
                  ),
                  listTile(
                    CustomListTile(
                      title: AppLocalizations.of(context)!.ipv6address,
                      subtitle: generateValue(i.ip6),
                    ),
                  ),
                  listTile(
                    CustomListTile(
                      title: AppLocalizations.of(context)!.ipv6subnet,
                      subtitle: generateValue(i.ip6Subnet),
                    ),
                  ),
                  listTile(
                    CustomListTile(
                      title: AppLocalizations.of(context)!.macAddress,
                      subtitle: generateValue(i.mac),
                    ),
                  ),
                  if (i.speed != null) listTile(
                    CustomListTile(
                      title: AppLocalizations.of(context)!.speed,
                      subtitle: "${i.speed.toString()} Mbps",
                    ),
                  ),
                  listTile(
                    CustomListTile(
                      title: AppLocalizations.of(context)!.internalInterface,
                      subtitle: i.internal == true 
                        ? AppLocalizations.of(context)!.yes
                        : AppLocalizations.of(context)!.no,
                    ),
                  ),
                  listTile(
                    CustomListTile(
                      title: AppLocalizations.of(context)!.virtualInterface,
                      subtitle: i.virtual == true 
                        ? AppLocalizations.of(context)!.yes
                        : AppLocalizations.of(context)!.no,
                    ),
                  ),
                  listTile(
                    CustomListTile(
                      title: AppLocalizations.of(context)!.interfaceType,
                      subtitle: interfaceType(i.type)
                    ),
                  ),
                  if (i.duplex != null && i.duplex != "") listTile(
                    CustomListTile(
                      title: AppLocalizations.of(context)!.duplex,
                      subtitle: i.duplex!.capitalize()
                    ),
                  ),
                  if (i.mtu != null) listTile(
                      CustomListTile(
                      title: "MTU",
                      subtitle: i.mtu.toString(),
                    )
                  )
                ],
              )
            ],
          )),
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
      onRefresh: onRefresh
    );
  }
}