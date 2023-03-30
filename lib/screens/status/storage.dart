import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/status/chart.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/functions/memory_conversion.dart';
import 'package:my_server_status/constants/enums.dart';
import 'package:my_server_status/models/current_status.dart';
import 'package:my_server_status/widgets/tab_content.dart';

class StorageTab extends StatefulWidget {
  final LoadStatus loadStatus;
  final List<Storage>? data;
  final Future<void> Function() onRefresh;

  const StorageTab({
    Key? key,
    required this.loadStatus,
    required this.data,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<StorageTab> createState() => _StorageTabState();
}

class _StorageTabState extends State<StorageTab> {
  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> chartData() {
      if (widget.data!.length < 20) {
        List<double> rx = List.filled(20, 0.0);
        List<double> wx = List.filled(20, 0.0);

        double topPoint = 0;

        for (var i = 0; i < widget.data!.length; i++) {
          rx[i] = widget.data![i].rx;
          wx[i] = widget.data![i].wx;
          if (widget.data![i].rx > topPoint) topPoint = widget.data![i].rx;
          if (widget.data![i].wx > topPoint) topPoint = widget.data![i].wx;
        }

        return {
          "rx": rx,
          "wx": wx,
          "topPoint": topPoint
        };
      }
      else {
        List<double> rx = [];
        List<double> wx = [];

        double topPoint = 0;

        for (var element in widget.data!) {
          rx.add(element.rx);
          wx.add(element.wx);
          if (element.rx > topPoint) topPoint = element.rx;
          if (element.wx > topPoint) topPoint = element.wx;
        }

        return {
          "rx": rx,
          "wx": wx,
          "topPoint": topPoint
        };
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
            AppLocalizations.of(context)!.loadingCurrentStatus,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          )
        ],
      ),
      contentGenerator: () {
        final formattedData = chartData();
        return [
          SectionLabel(label: AppLocalizations.of(context)!.storageUsage),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: CustomLinearChart(
                data: [
                  ChartData(data: formattedData["rx"]!, color: Colors.green), 
                  ChartData(data: formattedData["wx"]!, color: Colors.blue), 
                ],
                scale: Scale(min: 0.0, max: formattedData["topPoint"]),
                yScaleTextFormatter: (v) {
                  final parsed = double.parse(convertMemoryToMb(v));
                  if (parsed > 100) {
                    return parsed.toInt().toString();
                  }
                  else {
                    return parsed.toString();
                  }
                },
                tooltipTextFormatter: (v) => "${convertMemoryToMb(v)} MB/s",
                reservedSizeYLabels: 50,
                linesInterval: formattedData["topPoint"]/10 > 4
                  ? formattedData["topPoint"]/10
                  : 4,
                labelsInterval: formattedData["topPoint"]/10 > 4 
                  ? formattedData["topPoint"]/10
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
                      "${AppLocalizations.of(context)!.read}: ${convertMemoryToMb(widget.data![widget.data!.length-1].rx)} MB/s",
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
                      "${AppLocalizations.of(context)!.write}: ${convertMemoryToMb(widget.data![widget.data!.length-1].wx)} MB/s",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
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
            AppLocalizations.of(context)!.currentStatusNotLoaded,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      loadStatus: widget.loadStatus,
      onRefresh: widget.onRefresh
    );
  }
}