import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/status/chart.dart';
import 'package:my_server_status/widgets/section_label.dart';
import 'package:my_server_status/widgets/tab_content.dart';

import 'package:my_server_status/models/current_status.dart';
import 'package:my_server_status/functions/intermediate_color_generator.dart';
import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/functions/memory_conversion.dart';
import 'package:my_server_status/constants/enums.dart';

class MemoryTab extends StatelessWidget {
  final LoadStatus loadStatus;
  final List<Memory> data;
  final Future<void> Function() onRefresh;

  const MemoryTab({
    Key? key,
    required this.loadStatus,
    required this.data,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    List<double> chartData() {
      if (data.length < 20) {
        List<double> v = List.filled(20, 0);
        for (var i = 0; i < data.length; i++) {
          v[i] = data[i].active.toDouble();
        }
        return v;
      }
      else {
        return data.map((e) => e.active.toDouble()).toList();
      }
    }

    String memorySize() {
      if (data[0].specs.capacity != data[0].total) {
        return "${convertMemoryToGb(data[0].specs.capacity)} GB ${AppLocalizations.of(context)!.installed}, ${convertMemoryToGb(data[0].total)} GB ${AppLocalizations.of(context)!.available}";
      }
      else {
        return "${convertMemoryToGb(data[0].specs.capacity)} GB";
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
        return [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "${memorySize()} ${data[0].specs.type}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500
                ),
              )
            ),
          ),
          SectionLabel(
            label: AppLocalizations.of(context)!.memoryUsage,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${AppLocalizations.of(context)!.usage} (GB)",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  "${convertMemoryToGb(data[data.length-1].active)} GB",
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
              height: 300,
              child: CustomLinearChart(
                data: [
                  ChartData(
                    data: chartData(), 
                    color: appConfigProvider.statusColorsCharts
                      ? generateIntermediateColor((data[data.length-1].active/data[data.length-1].total)*100)
                      : Theme.of(context).colorScheme.primary
                  )
                ],
                scale: Scale(min: 0.0, max: data[0].total.toDouble()),
                yScaleTextFormatter: (v) => convertMemoryToGb(v.toInt()),
                tooltipTextFormatter: (v) => "${convertMemoryToGb(v.toInt())} GB",
                labelsInterval: data[0].total/6,
                linesInterval: data[0].total/6,
              )
            ),
          ),
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
      loadStatus: loadStatus, 
      onRefresh: onRefresh
    );
  }
}