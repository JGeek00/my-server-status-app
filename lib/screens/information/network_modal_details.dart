import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/custom_list_tile.dart';

import 'package:my_server_status/extensions/capitalize.dart';
import 'package:my_server_status/models/network_info.dart';

class NetworkModalDetails extends StatefulWidget {
  final NetworkInfo data;

  const NetworkModalDetails({
    Key? key,
    required this.data
  }) : super(key: key);

  @override
  State<NetworkModalDetails> createState() => _NetworkModalDetailsState();
}

class _NetworkModalDetailsState extends State<NetworkModalDetails> {
  String selectedEntry = "";

  @override
  void initState() {
    selectedEntry = widget.data.networkInterfaces[0].iface;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final iface = widget.data.networkInterfaces.firstWhere((i) => i.iface == selectedEntry);

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
              DropdownButtonFormField(
                value: selectedEntry,
                items: widget.data.networkInterfaces.map((e) => DropdownMenuItem(
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
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    CustomListTile(
                      title: AppLocalizations.of(context)!.state,
                      subtitle: iface.operstate == 'up' 
                        ? AppLocalizations.of(context)!.up
                        : AppLocalizations.of(context)!.down,
                    ),
                    CustomListTile(
                      title: AppLocalizations.of(context)!.isDefault,
                      subtitle: iface.networkInterfaceDefault == true 
                        ? AppLocalizations.of(context)!.yes
                        : AppLocalizations.of(context)!.no,
                    ),
                    CustomListTile(
                      title: AppLocalizations.of(context)!.ipv4address,
                      subtitle: generateValue(iface.ip4),
                    ),
                    CustomListTile(
                      title: AppLocalizations.of(context)!.ipv4subnet,
                      subtitle: generateValue(iface.ip4Subnet),
                    ),
                    CustomListTile(
                      title: AppLocalizations.of(context)!.ipv6address,
                      subtitle: generateValue(iface.ip6),
                    ),
                    CustomListTile(
                      title: AppLocalizations.of(context)!.ipv6subnet,
                      subtitle: generateValue(iface.ip6Subnet),
                    ),
                    CustomListTile(
                      title: AppLocalizations.of(context)!.macAddress,
                      subtitle: generateValue(iface.mac),
                    ),
                    if (iface.speed != null) CustomListTile(
                      title: AppLocalizations.of(context)!.speed,
                      subtitle: "${iface.speed.toString()} Mbps",
                    ),
                    CustomListTile(
                      title: AppLocalizations.of(context)!.internalInterface,
                      subtitle: iface.internal == true 
                        ? AppLocalizations.of(context)!.yes
                        : AppLocalizations.of(context)!.no,
                    ),
                    CustomListTile(
                      title: AppLocalizations.of(context)!.virtualInterface,
                      subtitle: iface.virtual == true 
                        ? AppLocalizations.of(context)!.yes
                        : AppLocalizations.of(context)!.no,
                    ),
                    CustomListTile(
                      title: AppLocalizations.of(context)!.interfaceType,
                      subtitle: interfaceType(iface.type)
                    ),
                    if (iface.duplex != null && iface.duplex != "") CustomListTile(
                      title: AppLocalizations.of(context)!.duplex,
                      subtitle: iface.duplex!.capitalize()
                    ),
                    if (iface.mtu != null) CustomListTile(
                      title: "MTU",
                      subtitle: iface.mtu.toString(),
                    )
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}