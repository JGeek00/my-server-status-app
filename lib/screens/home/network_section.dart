import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/models/general_info.dart';

class NetworkSectionHome extends StatefulWidget {
  final List<Network> networkInfo;

  const NetworkSectionHome({
    Key? key,
    required this.networkInfo
  }) : super(key: key);

  @override
  State<NetworkSectionHome> createState() => _NetworkSectionHomeState();
}

class _NetworkSectionHomeState extends State<NetworkSectionHome> {
  bool showAllEntries = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.network,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.networkInfo.length > 1
                      ? AppLocalizations.of(context)!.nInterfaces(widget.networkInfo.length.toString())
                      : AppLocalizations.of(context)!.oneInterface,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...widget.networkInfo.sublist(
            0, showAllEntries == true ? widget.networkInfo.length : (widget.networkInfo.length > 3 ? 3 : widget.networkInfo.length)
          ).asMap().entries.where(
            (i) => i.value.operstate != 'unknown' && i.value.type != '' && !i.value.iface.toLowerCase().contains("bluetooth")
            ).map((item) => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          item.value.type == 'wired' 
                            ? Icons.settings_ethernet_rounded 
                            : Icons.wifi_rounded,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          item.value.iface,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          item.value.operstate == 'up' 
                            ? Icons.check_rounded
                            : Icons.cancel_rounded,
                          size: 18,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.value.operstate == 'up' 
                            ? AppLocalizations.of(context)!.up
                            : AppLocalizations.of(context)!.down,
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "IPv4",
                      style: TextStyle(
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(item.value.ip4)
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Text(
                        "IPv6",
                        style: TextStyle(
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        item.value.ip6,
                        textAlign: TextAlign.end,
                      )
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "MAC",
                      style: TextStyle(
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(
                      item.value.mac,
                      textAlign: TextAlign.end,
                    )
                  ],
                ),
                if (item.key < widget.networkInfo.length-1) const SizedBox(height: 20),
              ],
            ),
          ).toList(),
          const SizedBox(height: 16),
          if (widget.networkInfo.length > 3) Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => showAllEntries = !showAllEntries), 
                child: Text(
                  showAllEntries == false
                    ? AppLocalizations.of(context)!.showMoreEntries(widget.networkInfo.length-3)
                    : AppLocalizations.of(context)!.showLessEntries
                )
              )
            ],
          )
        ],
      ),
    );
  }
}