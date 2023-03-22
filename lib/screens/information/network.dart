import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/custom_list_tile.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/extensions/capitalize.dart';
import 'package:my_server_status/providers/servers_provider.dart';

class NetworkTab extends StatelessWidget {
  const NetworkTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);

    String generateValue(String? value) {
      return value != null && value != '' && value != 'Default string' 
        ? value
        : 'N/A';
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

    switch (serversProvider.systemSpecsInfo.loadStatus) {
      case 0:
        return SizedBox(
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
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
          ),
        );
        
      case 1:
        final network = serversProvider.systemSpecsInfo.data!.networkInfo;
        return ListView(
          padding: const EdgeInsets.only(top: 16),
          children: [
            ...network.networkInterfaces.map((i) => Column(
              children: [
                SectionLabel(label: i.iface),
                CustomListTile(
                  title: AppLocalizations.of(context)!.state,
                  subtitle: i.operstate == 'up' 
                    ? AppLocalizations.of(context)!.up
                    : AppLocalizations.of(context)!.down,
                ),
                CustomListTile(
                  title: AppLocalizations.of(context)!.isDefault,
                  subtitle: i.networkInterfaceDefault == true 
                    ? AppLocalizations.of(context)!.yes
                    : AppLocalizations.of(context)!.no,
                ),
                CustomListTile(
                  title: AppLocalizations.of(context)!.ipv4address,
                  subtitle: generateValue(i.ip4),
                ),
                CustomListTile(
                  title: AppLocalizations.of(context)!.ipv4subnet,
                  subtitle: generateValue(i.ip4Subnet),
                ),
                CustomListTile(
                  title: AppLocalizations.of(context)!.ipv6address,
                  subtitle: generateValue(i.ip6),
                ),
                CustomListTile(
                  title: AppLocalizations.of(context)!.ipv6subnet,
                  subtitle: generateValue(i.ip6Subnet),
                ),
                CustomListTile(
                  title: AppLocalizations.of(context)!.macAddress,
                  subtitle: generateValue(i.mac),
                ),
                CustomListTile(
                  title: AppLocalizations.of(context)!.macAddress,
                  subtitle: generateValue(i.mac),
                ),
                if (i.speed != null) CustomListTile(
                  title: AppLocalizations.of(context)!.speed,
                  subtitle: "${i.speed.toString()} Mbps",
                ),
                CustomListTile(
                  title: AppLocalizations.of(context)!.internalInterface,
                  subtitle: i.internal == true 
                    ? AppLocalizations.of(context)!.yes
                    : AppLocalizations.of(context)!.no,
                ),
                CustomListTile(
                  title: AppLocalizations.of(context)!.virtualInterface,
                  subtitle: i.virtual == true 
                    ? AppLocalizations.of(context)!.yes
                    : AppLocalizations.of(context)!.no,
                ),
                CustomListTile(
                  title: AppLocalizations.of(context)!.interfaceType,
                  subtitle: interfaceType(i.type)
                ),
                if (i.duplex != null && i.duplex != "") CustomListTile(
                  title: AppLocalizations.of(context)!.duplex,
                  subtitle: i.duplex!.capitalize()
                ),
                if (i.mtu != null) CustomListTile(
                  title: "MTU",
                  subtitle: i.mtu.toString(),
                )
              ],
            )),
            const SizedBox(height: 16)
          ],
        );

      case 2: 
        return SizedBox(
          width: double.maxFinite,
          child: Column(
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
        );
       
      default:
        return const SizedBox();
    }
  }
}