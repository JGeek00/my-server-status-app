import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/custom_list_tile.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/extensions/capitalize.dart';
import 'package:my_server_status/models/network_info.dart';
import 'package:my_server_status/providers/app_config_provider.dart';

class NetworkModalDetails extends StatelessWidget {
  final NetworkInfo data;

  const NetworkModalDetails({
    Key? key,
    required this.data
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    final height = MediaQuery.of(context).size.height;

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


    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: height*0.8
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.network,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context), 
                    icon: const Icon(Icons.close_rounded)
                  )
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    children: [
                      ...data.networkInterfaces.map((i) => Column(
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
                      )
                    ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}