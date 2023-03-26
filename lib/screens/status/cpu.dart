import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/models/current_status.dart';
import 'package:my_server_status/screens/status/chart.dart';
import 'package:my_server_status/widgets/section_label.dart';

enum CoreChartConfig  { load, speed, temperature }

class CpuTab extends StatefulWidget {
  final int loadStatus;
  final List<Cpu> data;

  const CpuTab({
    Key? key,
    required this.loadStatus,
    required this.data,
  }) : super(key: key);

  @override
  State<CpuTab> createState() => _CpuTabState();
}

class _CpuTabState extends State<CpuTab> {
  List<CoreChartConfig> coreChartConfig = [];

  @override
  Widget build(BuildContext context) {

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
            temp[j] = widget.data[j].cores[i].temperature.toDouble();
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
            temp.add(d.cores[i].temperature.toDouble());
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

    Map<String, Widget> generateChart(CoreChartConfig config, Map<String, dynamic> value) {
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
              data: [ChartData(data: List<double>.from(value['load'].map((e) => e.toDouble())), color: Colors.green)],
              scale: const Scale(min: 0.0, max: 100.0),
              yScaleTextFormatter: (v) => v.toStringAsFixed(0),
              tooltipTextFormatter: (v) => "${v.toStringAsFixed(2)}%",
              linesInterval: 25.0,
              labelsInterval: 50,
            ),
          };

        case CoreChartConfig.speed:
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
            "chart": CustomLinearChart(
              data: [ChartData(data: List<double>.from(value['speed'].map((e) => e.toDouble())), color: Colors.green)],
              scale: Scale(min: 0, max: widget.data[0].specs.maxSpeed),
              yScaleTextFormatter: (v) => v.toStringAsFixed(2),
              tooltipTextFormatter: (v) => "${v.toStringAsFixed(2)} GHz",
              linesInterval: widget.data[0].specs.maxSpeed/4,
              labelsInterval: widget.data[0].specs.maxSpeed/4,
            ),
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
              data: [ChartData(data: List<double>.from(value['temperature'].map((e) => e.toDouble())), color: Colors.green)],
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
        if (widget.data.isNotEmpty) {
          final formattedData = chartData();
          return ListView(
            padding: const EdgeInsets.only(top: 0),
            children: [
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.data[0].specs.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.cores}: ${widget.data[0].cores.length}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          Text(
                            "${widget.data[0].specs.minSpeed} GHz - ${widget.data[0].specs.maxSpeed} GHz",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              ...formattedData.asMap().entries.map((core) {
                final widgets = generateChart(coreChartConfig[core.key], core.value);
                final renderWidget = Column(
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
                        height: 100,
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
                          ButtonSegment(
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
                );
                return renderWidget;
              }).toList()
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