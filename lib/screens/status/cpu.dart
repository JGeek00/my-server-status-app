import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/status/chart.dart';
import 'package:my_server_status/widgets/section_label.dart';
import 'package:my_server_status/widgets/tab_content.dart';

import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/functions/intermediate_color_generator.dart';
import 'package:my_server_status/models/current_status.dart';
import 'package:my_server_status/constants/enums.dart';

enum CoreChartConfig  { load, speed, temperature }

class CpuTab extends StatefulWidget {
  final LoadStatus loadStatus;
  final List<Cpu> data;
  final Future<void> Function() onRefresh;

  const CpuTab({
    Key? key,
    required this.loadStatus,
    required this.data,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<CpuTab> createState() => _CpuTabState();
}

class _CpuTabState extends State<CpuTab> {
  List<CoreChartConfig> coreChartConfig = [];

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    final width = MediaQuery.of(context).size.width;

    List<Map<String, dynamic>> chartData() {
      if (coreChartConfig.length != widget.data[0].cores.length) {
        for (var _ in widget.data[0].cores) {
          coreChartConfig.add(CoreChartConfig.load);
        }
      }

      if (widget.data.length < 20) {
        List<Map<String, dynamic>> cores = List.filled(widget.data[0].cores.length, {});

        for (var i = 0; i < cores.length; i++) {
          List<double> temp = List.filled(20, 0);
          List<double> speed = List.filled(20, 0.0);
          List<double> load = List.filled(20, 0.0);

          for (var j = 0; j < widget.data.length; j++) {
            if (widget.data[j].cores[i].temperature != null) {
              temp[j] = widget.data[j].cores[i].temperature!.toDouble();
            }
            else if (widget.data[j].average.temperature != null) {
              temp[j] = widget.data[j].average.temperature!.toDouble();
            }
            else {
              temp[j] = 0.0;
            }
            speed[j] = widget.data[j].cores[i].speed;
            load[j] = widget.data[j].cores[i].load["load"] ?? 0.0;
          }

          cores[i] = {
            "temperature": temp,
            "speed": speed,
            "load": load
          };
        }

        return cores;
        
      }
      else {
        List<Map<String, dynamic>> cores = List.filled(widget.data[0].cores.length, {});

        for (var i = 0; i < cores.length; i++) {
          List<double> temp = [];
          List<double> speed = [];
          List<double> load = [];

          for (var d in widget.data) {
            if (d.cores[i].temperature != null) {
              temp.add(d.cores[i].temperature!.toDouble());
            }
            else if (d.average.temperature != null) {
              temp.add(d.average.temperature!.toDouble());
            }
            else {
              temp.add(0.0);
            }
            speed.add(d.cores[i].speed);
            load.add(d.cores[i].load["load"] ?? 0.0);
          }

          cores[i] = {
            "temperature": temp,
            "speed": speed,
            "load": load
          };
        }

        return cores;
      }
    }

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
                    ? generateIntermediateColor(widget.data[widget.data.length-1].cores[nCore].load['load'] ?? 0)
                    : Theme.of(context).colorScheme.primary
                )
              ],
              scale: const Scale(min: 0.0, max: 100.0),
              yScaleTextFormatter: (v) => v.toStringAsFixed(0),
              tooltipTextFormatter: (v) => "${v.toStringAsFixed(2)}%",
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
                            (widget.data[widget.data.length-1].cores[nCore].speed/widget.data[0].specs!.maxSpeed)*100 > 100
                              ? 100
                              : (widget.data[widget.data.length-1].cores[nCore].speed/widget.data[0].specs!.maxSpeed)*100
                          )
                        : Theme.of(context).colorScheme.primary
                    )
                  ],
                  scale: Scale(
                    min: 0, 
                    max: maxValue > widget.data[0].specs!.maxSpeed
                      ? maxValue
                      : widget.data[0].specs!.maxSpeed
                  ),
                  yScaleTextFormatter: (v) => v.toStringAsFixed(2),
                  tooltipTextFormatter: (v) => "${v.toStringAsFixed(2)} GHz",
                  linesInterval: widget.data[0].specs!.maxSpeed/4,
                  labelsInterval: widget.data[0].specs!.maxSpeed/4,
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
              tooltipTextFormatter: (v) => "${v.toStringAsFixed(0)}ºC",
              linesInterval: 25.0,
              labelsInterval: 50,
            ),
          };

        default:
          return {
            "header": const SizedBox(),
            "chart": const SizedBox()
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
          Wrap(
            children: formattedData.asMap().entries.map((core) {
              final widgets = generateChart(coreChartConfig[core.key], core.value, core.key);
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
                      child: SegmentedButton<CoreChartConfig>(
                        segments: [
                          ButtonSegment(
                            value: CoreChartConfig.load,
                            label: Text(AppLocalizations.of(context)!.load)
                          ),
                          if (widget.data[0].specs != null) ButtonSegment(
                            value: CoreChartConfig.speed,
                            label: Text(AppLocalizations.of(context)!.speed)
                          ),
                          ButtonSegment(
                            value: CoreChartConfig.temperature,
                            label: Text(AppLocalizations.of(context)!.temp)
                          ),
                        ], 
                        selected: <CoreChartConfig>{coreChartConfig[core.key]},
                        onSelectionChanged: (value) => setState(() => coreChartConfig[core.key] = value.first),
                      ),
                    )
                  ],
                ),
              );
              return renderWidget;
            }).toList()
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