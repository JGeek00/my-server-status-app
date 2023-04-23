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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final paddingTop = MediaQuery.of(context).viewPadding.top;
    final paddingBottom = MediaQuery.of(context).viewPadding.bottom;

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${AppLocalizations.of(context)!.dataTransfer} (${formattedData["topPoint"] > 1048576 ? 'MB/s' : 'KB/s'})",
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
              height: width > 900 
                ? (height-paddingTop-paddingBottom)-240 
                : (height-paddingTop-paddingBottom)-310,
              child: CustomLinearChart(
                data: [
                  ChartData(
                    data: formattedData["rx"]!, 
                    color: Theme.of(context).colorScheme.primary
                  ), 
                  ChartData(
                    data: formattedData["wx"]!, 
                    color: Theme.of(context).colorScheme.inversePrimary
                  ), 
                ],
                scale: Scale(min: 0.0, max: formattedData["topPoint"]),
                yScaleTextFormatter: (v) {
                  final parsed = v > 1048576
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
                        color: Theme.of(context).colorScheme.primary
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.data![widget.data!.length-1].rx > 1048576
                        ? "${AppLocalizations.of(context)!.read}: ${convertMemoryToMb(widget.data![widget.data!.length-1].rx)} MB/s"
                        : "${AppLocalizations.of(context)!.read}: ${convertMemoryToKb(widget.data![widget.data!.length-1].rx)} KB/s",
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
                        color: Theme.of(context).colorScheme.inversePrimary
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.data![widget.data!.length-1].wx > 1048576
                        ? "${AppLocalizations.of(context)!.write}: ${convertMemoryToMb(widget.data![widget.data!.length-1].wx)} KB/s"
                        : "${AppLocalizations.of(context)!.write}: ${convertMemoryToKb(widget.data![widget.data!.length-1].wx)} KB/s",
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