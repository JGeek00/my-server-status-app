import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/models/general_info.dart';

class NetworkSectionHome extends StatelessWidget {
  final List<Network> networkInfo;

  const NetworkSectionHome({
    Key? key,
    required this.networkInfo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentIndexNetwork = 0;   // To know current index on network map

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
                    networkInfo.length > 1
                      ? AppLocalizations.of(context)!.nInterfaces(networkInfo.length.toString())
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
          ...networkInfo.where((i) => i.operstate != 'unknown').map(
            (item) {
              currentIndexNetwork++;
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            item.type == 'wired' 
                              ? Icons.settings_ethernet_rounded 
                              : Icons.wifi_rounded,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            item.iface,
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
                            item.operstate == 'up' 
                              ? Icons.check_rounded
                              : Icons.cancel_rounded,
                            size: 18,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.operstate == 'up' 
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
                      Text(item.ip4)
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
                        child: Text(item.ip6)
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
                      Text(item.mac)
                    ],
                  ),
                  if (currentIndexNetwork < networkInfo.length) const SizedBox(height: 20),
                ],
              );
            }
          ).toList()
        ],
      ),
    );
  }
}