import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_server_status/functions/memory_conversion.dart';

import 'package:my_server_status/models/current_status.dart';
import 'package:my_server_status/screens/status/chart.dart';
import 'package:my_server_status/widgets/section_label.dart';

class NetworkTab extends StatefulWidget {
  final int loadStatus;
  final List<List<Network>>? data;

  const NetworkTab({
    Key? key,
    required this.loadStatus,
    required this.data,
  }) : super(key: key);

  @override
  State<NetworkTab> createState() => _NetworkTabState();
}

class _NetworkTabState extends State<NetworkTab> {
  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> chartData() {
      if (widget.data!.length < 20) {
        List<Map<String, dynamic>> interfaces = List.filled(widget.data![0].length, {});

        for (var i = 0; i < interfaces.length; i++) {
          List<double> tx = List.filled(20, 0);
          List<double> rx = List.filled(20, 0);

          double topPoint = 0;

          for (var j = 0; j < widget.data!.length; j++) {
            tx[j] = widget.data![j][i].tx;
            rx[j] = widget.data![j][i].rx;
            if (widget.data![j][i].tx > topPoint) topPoint = widget.data![j][i].tx;
            if (widget.data![j][i].rx > topPoint) topPoint = widget.data![j][i].rx;
          }

          interfaces[i] = {
            "iface": widget.data![0][i].iface,
            "tx": tx,
            "rx": rx,
            "topPoint": topPoint
          };
        }

        return interfaces;
      }
      else {
        List<Map<String, dynamic>> interfaces = List.filled(widget.data![0].length, {});
        
        for (var i = 0; i < interfaces.length; i++) {
          double topPoint = 0;

          List<double> tx = [];
          List<double> rx = [];

          for (var j = 0; j < widget.data!.length; j++) {
            tx.add(widget.data![j][i].tx);
            rx.add(widget.data![j][i].rx);
            if (widget.data![j][i].tx > topPoint) topPoint = widget.data![j][i].tx;
            if (widget.data![j][i].rx > topPoint) topPoint = widget.data![j][i].rx;
          }

          interfaces[i] = {
            "iface": widget.data![0][i].iface,
            "tx": tx,
            "rx": rx,
            "topPoint": topPoint
          };
        }

        return interfaces;
      }
    }

    switch (widget.loadStatus) {
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
                  AppLocalizations.of(context)!.loadingCurrentStatus,
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
        if (widget.data != null && widget.data!.isNotEmpty) {
          final formattedData = chartData();
          return ListView(
            padding: const EdgeInsets.only(top: 8),
            children: [
              ...formattedData.asMap().entries.map((intfz) => Column(
                children: [
                  SectionLabel(label: intfz.value["iface"]),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.dataTransfer} (${intfz.value["topPoint"] > 1048576 ? 'MB/s' : 'KB/s'})",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.maxFinite,
                      height: 400,
                      child: CustomLinearChart(
                        data: [
                          ChartData(data: intfz.value["tx"]!, color: Colors.green), 
                          ChartData(data: intfz.value["rx"]!, color: Colors.blue), 
                        ],
                        scale: Scale(min: 0.0, max: intfz.value["topPoint"]),
                        yScaleTextFormatter: (v) {
                          final parsed = intfz.value["topPoint"] > 1048576
                            ? double.parse(convertMemoryToMb(v))
                            : double.parse(convertMemoryToKb(v));
                          if (parsed > 100) {
                            return parsed.toInt().toString();
                          }
                          else {
                            return parsed.toString();
                          }
                        },
                        tooltipTextFormatter: (v) => v > 1048576
                          ? "${convertMemoryToMb(v)} MB/s"
                          : "${convertMemoryToKb(v)} KB/s",
                        reservedSizeYLabels: 50,
                        linesInterval: intfz.value["topPoint"]/10 > 4
                          ? intfz.value["topPoint"]/10
                          : 4,
                        labelsInterval: intfz.value["topPoint"]/10 > 4
                          ? intfz.value["topPoint"]/10
                          : 4,
                      )
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.green
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.data![widget.data!.length-1][intfz.key].rx > 1048576
                                ? "Tx: ${convertMemoryToMb(widget.data![widget.data!.length-1][intfz.key].tx)} MB/s"
                                : "Tx: ${convertMemoryToKb(widget.data![widget.data!.length-1][intfz.key].tx)} KB/s",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.data![widget.data!.length-1][intfz.key].rx > 1048576
                                ? "Rx: ${convertMemoryToMb(widget.data![widget.data!.length-1][intfz.key].rx)} MB/s"
                                : "Rx: ${convertMemoryToKb(widget.data![widget.data!.length-1][intfz.key].rx)} KB/s",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ))
            ],
          );
        }
        else {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.noDataDisplayHere,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }

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
                AppLocalizations.of(context)!.currentStatusNotLoaded,
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