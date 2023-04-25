import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_server_status/constants/app_icons.dart';

import 'package:my_server_status/screens/home/arc_chart.dart';

import 'package:my_server_status/functions/intermediate_color_generator.dart';
import 'package:my_server_status/functions/memory_conversion.dart';
import 'package:my_server_status/models/general_info.dart';

class MemorySectionHome extends StatelessWidget {
  final Memory memoryInfo;
    
  const MemorySectionHome({
    Key? key,
    required this.memoryInfo
  }) : super(key: key);

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
                    "${AppLocalizations.of(context)!.memory} (RAM)",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${convertMemoryToGb(memoryInfo.layout.map((i) => i.size).reduce((a, b) => a+b))} GB ${memoryInfo.layout[0].type}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            ArcChart(
                              percentage: (memoryInfo.info.active/memoryInfo.info.total)*100, 
                              arcWidth: 7, 
                              color: generateIntermediateColor(
                                (memoryInfo.info.active/memoryInfo.info.total)*100
                              ),
                              size: 100
                            ),
                            Icon(
                              MyServerStatusIcons.memory,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 40,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${((memoryInfo.info.active/memoryInfo.info.total)*100).toInt().toString()}%",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    height: 100,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.ramUsed,
                              style: const TextStyle(
                                fontSize: 16
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${convertMemoryToGb(memoryInfo.info.active)} GB (${((memoryInfo.info.active/memoryInfo.info.total)*100).toInt().toString()}%)",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.swapUsed,
                              style: const TextStyle(
                                fontSize: 16
                              ),
                            ),
                            Text(
                              memoryInfo.info.swaptotal > 0
                                ? "${convertMemoryToGb(memoryInfo.info.swapused)} GB (${((memoryInfo.info.swapused/memoryInfo.info.swaptotal)*100).toInt().toString()}%)"
                                : "N/A",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}