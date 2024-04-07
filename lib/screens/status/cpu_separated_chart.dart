import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/status/chart.dart';
import 'package:my_server_status/screens/status/cpu.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/functions/intermediate_color_generator.dart';
import 'package:my_server_status/models/current_status.dart';
import 'package:my_server_status/providers/app_config_provider.dart';

class CpuSeparatedChart extends StatefulWidget {
  final List<CoreChartConfig> coreChartConfig;
  final List<Map<String, dynamic>> formattedData;
  final List<Cpu> data;

  const CpuSeparatedChart({
    Key? key,
    required this.coreChartConfig,
    required this.formattedData,
    required this.data
  }) : super(key: key);

  @override
  State<CpuSeparatedChart> createState() => _CpuSeparatedChartState();
}

class _CpuSeparatedChartState extends State<CpuSeparatedChart> {
  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    final width = MediaQuery.of(context).size.width;

    Map<String, Widget> generateChart(CoreChartConfig config, Map<String, dynamic> value, int nCore) {
      switch (config) {
        case CoreChartConfig.load:
          return {
            "header": Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${AppLocalizations.of(context)!.load} (%)",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  "${value['load'][widget.data.length-1].toStringAsFixed(2)}%",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
            "chart": CustomLinearChart(
              data: [
                ChartData(
                  data: List<double>.from(value['load'].map((e) => e.toDouble())), 
                  color: appConfigProvider.statusColorsCharts
                    ? generateIntermediateColor(widget.data[widget.data.length-1].cores[nCore].load?['load'] ?? 0)
                    : Theme.of(context).colorScheme.primary
                )
              ],
              scale: const Scale(min: 0.0, max: 100.0),
              yScaleTextFormatter: (v) => v.toStringAsFixed(0),
              tooltipTextFormatter: (v, i) => "${v.toStringAsFixed(2)}%",
              linesInterval: 25.0,
              labelsInterval: 50,
            ),
          };

        case CoreChartConfig.speed:
          final values = List<double>.from(value['speed'].map((e) => e.toDouble()));
          final maxValue = values.reduce(max);
          return {
            "header": Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${AppLocalizations.of(context)!.speed} (GHz)",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  "${value['speed'][widget.data.length-1].toStringAsFixed(2)} GHz",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
            "chart":  widget.data[0].specs != null
              ? CustomLinearChart(
                  data: [
                    ChartData(
                      data: values,
                      color: appConfigProvider.statusColorsCharts 
                        ? generateIntermediateColor(
                            (widget.data[widget.data.length-1].cores[nCore].speed ?? 0.0/(widget.data[0].specs!.maxSpeed != null ? widget.data[0].specs!.maxSpeed! : maxValue))*100 > 100
                              ? 100
                              : (widget.data[widget.data.length-1].cores[nCore].speed ?? 0.0/(widget.data[0].specs!.maxSpeed != null ? widget.data[0].specs!.maxSpeed! : maxValue))*100
                          )
                        : Theme.of(context).colorScheme.primary
                    )
                  ],
                  scale: Scale(
                    min: 0, 
                    max: widget.data[0].specs!.maxSpeed != null
                      ? maxValue > widget.data[0].specs!.maxSpeed!
                        ? maxValue
                        : widget.data[0].specs!.maxSpeed!
                      : maxValue
                  ),
                  yScaleTextFormatter: (v) => v.toStringAsFixed(2),
                  tooltipTextFormatter: (v, i) => "${v.toStringAsFixed(2)} GHz",
                  linesInterval: widget.data[0].specs!.maxSpeed != null
                    ? widget.data[0].specs!.maxSpeed!/4
                    : maxValue/4,
                  labelsInterval: widget.data[0].specs!.maxSpeed != null
                    ? widget.data[0].specs!.maxSpeed!/4
                    : maxValue/4,
                )
              : Center(
                  child: Text(
                    AppLocalizations.of(context)!.noDataAvailable,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurfaceVariant
                    ),
                  ),
                )
          };

        case CoreChartConfig.temperature:
          if (value['temperature'] != null) {
            return {
              "header": Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.temperature} (ºC)",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  Text(
                    "${value['temperature'][widget.data.length-1].toStringAsFixed(0)}ºC",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
              "chart": CustomLinearChart(
                data: [
                  ChartData(
                    data: List<double>.from(value['temperature'].map((e) => e.toDouble())), 
                    color: appConfigProvider.statusColorsCharts && widget.data[widget.data.length-1].cores[nCore].temperature != null
                      ? generateIntermediateColor(
                          widget.data[widget.data.length-1].cores[nCore].temperature! < 100 
                            ? widget.data[widget.data.length-1].cores[nCore].temperature!.toDouble()
                            : 100.00
                        )
                      : Theme.of(context).colorScheme.primary
                  )
                ],
                scale: const Scale(min: 0.0, max: 100.0),
                yScaleTextFormatter: (v) => v.toStringAsFixed(0),
                tooltipTextFormatter: (v, i) => "${v.toStringAsFixed(0)}ºC",
                linesInterval: 25.0,
                labelsInterval: 50,
              ),
            };
          }
          else {
            return {
              "header": Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.load} (%)",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  const Text(
                    "---",
                    style: TextStyle(
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
              "chart": Center(
                child: Text(
                  AppLocalizations.of(context)!.noDataAvailable,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant
                  ),
                ),
              )
            };
          }

        default:
          return {
            "header": const SizedBox(),
            "chart": const SizedBox()
          };
      }
    }

    return Wrap(
      children: widget.formattedData.asMap().entries.map((core) {
        final widgets = generateChart(widget.coreChartConfig[core.key], core.value, core.key);
        final renderWidget = Container(
          width: width > 600 
            ? width > 900 ? (width-91)/2 : width/2
            : null,
          padding: width > 600 ? const EdgeInsets.all(8) : null,
          child: Column(
            children: [
              SectionLabel(
                label: AppLocalizations.of(context)!.core(core.key),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: widgets["header"]
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.maxFinite,
                  height: width > 600 ? 150 : 100,
                  child: widgets["chart"]
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                      child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilterChip(
                      label: Text(AppLocalizations.of(context)!.load), 
                      tooltip: AppLocalizations.of(context)!.load,
                      selected: widget.coreChartConfig[core.key] == CoreChartConfig.load,
                      onSelected: (_) => setState(() => widget.coreChartConfig[core.key] = CoreChartConfig.load)
                    ),
                    if (widget.data[0].specs != null) FilterChip(
                      label: Text(AppLocalizations.of(context)!.speed), 
                      tooltip: AppLocalizations.of(context)!.speed,
                      selected: widget.coreChartConfig[core.key] == CoreChartConfig.speed,
                      onSelected: (_) => setState(() => widget.coreChartConfig[core.key] = CoreChartConfig.speed)
                    ),
                    if (core.value['temperature'] != null) FilterChip(
                      label: Text(AppLocalizations.of(context)!.temperature),
                      tooltip: AppLocalizations.of(context)!.temperature, 
                      selected: widget.coreChartConfig[core.key] == CoreChartConfig.temperature,
                      onSelected: (_) => setState(() => widget.coreChartConfig[core.key] = CoreChartConfig.temperature)
                    ),
                  ],
                )
              )
            ],
          ),
        );
        return renderWidget;
      }).toList()
    );
  }
}