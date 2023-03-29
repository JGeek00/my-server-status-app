import 'package:flutter/material.dart';

import 'package:my_server_status/screens/home/arc_chart.dart';

import 'package:my_server_status/functions/intermediate_color_generator.dart';
import 'package:my_server_status/models/general_info.dart';

class CpuSectionHome extends StatelessWidget {
  final Cpu cpuInfo;

  const CpuSectionHome({
    Key? key,
    required this.cpuInfo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cpuTemp = cpuInfo.temp.main != null
      ? cpuInfo.temp.main! <= 100 
        ? cpuInfo.temp.main
        : 100
      : null;

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
                  const Text(
                    "CPU",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${cpuInfo.info.manufacturer} ${cpuInfo.info.brand}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
              Text(
                "${cpuInfo.speed.avg} GHz",
                style: const TextStyle(
                  fontWeight: FontWeight.w500
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 24),
            child: Row(
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
                              percentage: cpuInfo.load.currentLoad.toDouble(), 
                              arcWidth: 7, 
                              color: generateIntermediateColor(
                                cpuInfo.load.currentLoad.toDouble()
                              ),
                              size: 100
                            ),
                            const Icon(
                              Icons.memory_rounded,
                              size: 40,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${cpuInfo.load.currentLoad.toInt().toString()}%",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500
                        ),
                      )
                    ],
                  ),
                ),
                if (cpuTemp != null) Expanded(
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
                              percentage: cpuTemp.toDouble(), 
                              arcWidth: 7, 
                              color: generateIntermediateColor(cpuTemp.toDouble()),
                              size: 100
                            ),
                            const Icon(
                              Icons.thermostat,
                              size: 40,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${cpuInfo.temp!.main.toString()}ºC",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}