import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/status/chart.dart';

import 'package:my_server_status/constants/chart_colors.dart';
import 'package:my_server_status/models/current_status.dart';
import 'package:my_server_status/screens/status/cpu.dart';

class CpuCombinedChart extends StatefulWidget {
  final List<Map<String, dynamic>> formattedData;
  final List<Cpu> data;

  const CpuCombinedChart({
    Key? key,
    required this.formattedData,
    required this.data
  }) : super(key: key);

  @override
  State<CpuCombinedChart> createState() => _CpuCombinedChartState();
}

class _CpuCombinedChartState extends State<CpuCombinedChart> {
  CoreChartConfig coreChartConfig = CoreChartConfig.load;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    String configUnit(int core) {
      switch (coreChartConfig) {
        case CoreChartConfig.load:
          return "${widget.data[widget.data.length-1].cores[core].load['load']!.toStringAsFixed(0)}%";

        case CoreChartConfig.speed:
          return "${widget.data[widget.data.length-1].cores[core].speed.toStringAsFixed(2)} GHz";

        case CoreChartConfig.temperature:
          final value = widget.data[widget.data.length-1].cores[core].temperature;
          if (value != null) {
            return "${value.toStringAsFixed(0)}ºC";
          }
          else {
            return "N/A";
          }

        default:
          return "";
      }
    }

    double getMaxValueDouble() {
      List<double> allValues = [];
      for (var item in widget.formattedData) {
        allValues = [...allValues, ...item[coreChartConfig.name]];
      }
      return allValues.reduce(max);
    }

    double generateMaxScale() {
      switch (coreChartConfig) {
        case CoreChartConfig.load:
          return 100.0;

        case CoreChartConfig.speed:
          final maxValue = getMaxValueDouble();
          if (maxValue > widget.data[0].specs!.maxSpeed) {
            return maxValue;
          }
          else {
            return widget.data[0].specs!.maxSpeed;
          }

        case CoreChartConfig.temperature:
          final maxValue = getMaxValueDouble();
          if (maxValue > 100) {
            return maxValue;
          }
          else {
            return 100;
          }

        default:
          return 100.0;
      }
    }

    Widget chart() {
      return Container(
        height: width > 900
          ? height-190
          : 500,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomLinearChart(
          data: List<ChartData>.from(widget.formattedData.asMap().entries.map(
            (core) => ChartData(
              data: List<double>.from(core.value[coreChartConfig.name].map((e) => e.toDouble())), 
              color: chartColors[core.key]
            ))
          ),
          scale: Scale(
            min: 0.0, 
            max: generateMaxScale()
          ),
          yScaleTextFormatter: (v) => v.toStringAsFixed(0),
          tooltipTextFormatter: (v, i) => "${AppLocalizations.of(context)!.core(i)}: ${configUnit(i)}",
          linesInterval: coreChartConfig == CoreChartConfig.speed
            ? widget.data[0].specs!.maxSpeed/4
            : 10.0,
          labelsInterval: coreChartConfig == CoreChartConfig.speed
            ? widget.data[0].specs!.maxSpeed/4
            : 10,
        ),
      );
    }

    Widget legend() {
      return Wrap(
        children: widget.formattedData.asMap().entries.map(
          (core) => FractionallySizedBox(
            widthFactor: width > 900
              ? 1
              : 0.5,
            child: Padding(
              padding: width > 900
                ? const EdgeInsets.all(16)
                : const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: chartColors[core.key]
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    AppLocalizations.of(context)!.core(core.key),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "(${configUnit(core.key)})",
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          )
        ).toList()
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilterChip(
                label: Text(AppLocalizations.of(context)!.load), 
                tooltip: AppLocalizations.of(context)!.load,
                selected: coreChartConfig == CoreChartConfig.load,
                onSelected: (_) => setState(() => coreChartConfig = CoreChartConfig.load)
              ),
              FilterChip(
                label: Text(AppLocalizations.of(context)!.speed), 
                tooltip: AppLocalizations.of(context)!.speed,
                selected: coreChartConfig == CoreChartConfig.speed,
                onSelected: (_) => setState(() => coreChartConfig = CoreChartConfig.speed)
              ),
              FilterChip(
                label: Text(AppLocalizations.of(context)!.temperature),
                tooltip: AppLocalizations.of(context)!.temperature, 
                selected: coreChartConfig == CoreChartConfig.temperature,
                onSelected: (_) => setState(() => coreChartConfig = CoreChartConfig.temperature)
              ),
            ],
          )
        ),
        if (width > 900) SizedBox(
          height: width > 900
            ? height-190
            : null,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: chart(),
              ),
              Expanded(
                flex: 1,
                child: legend()
              )
            ],
          ),
        ),
        if (width <= 900) ...[
          chart(),  
          const SizedBox(height: 16),
          legend(),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}