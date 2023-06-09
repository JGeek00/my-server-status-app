import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:my_server_status/providers/app_config_provider.dart';

class Scale {
  final double min;
  final double max;

  const Scale({
    required this.min,
    required this.max
  });
}

class ChartData {
  final List<double> data;
  final Color color;
  final String? label;

  ChartData({
    required this.data,
    required this.color,
    this.label
  });
}

class CustomLinearChart extends StatelessWidget {
  final List<ChartData> data;
  final Scale? scale;
  final Function(double)? yScaleTextFormatter;
  final Function(double, int)? tooltipTextFormatter;
  final double? linesInterval;
  final double? labelsInterval;
  final double? reservedSizeYLabels;

  const CustomLinearChart({
    Key? key,
    required this.data,
    this.scale,
    this.yScaleTextFormatter,
    this.tooltipTextFormatter,
    this.linesInterval,
    this.labelsInterval,
    this.reservedSizeYLabels,
  }) : super(key: key);

  LineChartData mainData(Map<String, dynamic> chartData, ThemeMode selectedTheme) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: linesInterval,
        getDrawingHorizontalLine: (value) => FlLine(
          color: selectedTheme == ThemeMode.light
            ? Colors.black12
            : Colors.white12,
          strokeWidth: 1
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: reservedSizeYLabels ?? 35,
            interval: labelsInterval,
            getTitlesWidget: (value, widget) => Text(
              yScaleTextFormatter != null
                ? yScaleTextFormatter!(value)
                : value.toString(),
              style: const TextStyle(
                fontSize: 12,
              ),
            )
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          top: BorderSide(
            color: selectedTheme == ThemeMode.light
              ? Colors.black12
              : Colors.white12,
            width: 1
          ),
          bottom: BorderSide(
            color: selectedTheme == ThemeMode.light
              ? Colors.black12
              : Colors.white12,
            width: 1
          ),
        )
      ),
      minY: scale != null ? scale!.min : null,
      maxY: scale != null ? scale!.max : null,
      lineBarsData: chartData['data'],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: selectedTheme == ThemeMode.light
            ? const Color.fromRGBO(220, 220, 220, 1)
            : const Color.fromRGBO(35, 35, 35, 1),
          maxContentWidth: 150,
          getTooltipItems: (items) => items.asMap().entries.map((e) => LineTooltipItem(
            tooltipTextFormatter != null
              ? tooltipTextFormatter!(e.value.y, e.key)
              : e.value.y.toString(), 
            TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: data[e.key].color
            )
          )).toList()
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    final List<LineChartBarData> lines = [];

    double topPoint = 0;

    for (var dataSet in data) {
      final List<FlSpot> spots = [];

      for (var i = 0; i < dataSet.data.length; i++) {
        if (dataSet.data[i] > topPoint) topPoint = dataSet.data[i];
        spots.add(
          FlSpot(i.toDouble(), dataSet.data[i].toDouble())
        );
      }

      lines.add(
        LineChartBarData(
          spots: spots,
          color: dataSet.color,
          isCurved: true,
          barWidth: 2,
          preventCurveOverShooting: true,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            color: dataSet.color.withOpacity(0.2)
          ),
        )
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: LineChart(
        swapAnimationDuration: const Duration(milliseconds: 0),
        mainData(
          {
            'data': lines,
            'topPoint': topPoint,
          }, 
          appConfigProvider.selectedTheme
        )
      ),
    );
  }
}