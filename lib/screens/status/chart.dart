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

class CustomLinearChart extends StatelessWidget {
  final List<int> data;
  final Scale? scale;
  final Function(double)? yScaleTextFormatter;
  final Function(double)? tooltipTextFormatter;
  final Color color;

  const CustomLinearChart({
    Key? key,
    required this.data,
    this.scale,
    this.yScaleTextFormatter,
    this.tooltipTextFormatter,
    required this.color
  }) : super(key: key);

  LineChartData mainData(Map<String, dynamic> data, ThemeMode selectedTheme) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
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
            reservedSize: 35,
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
      lineBarsData: data['data'],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: selectedTheme == ThemeMode.light
            ? const Color.fromRGBO(220, 220, 220, 1)
            : const Color.fromRGBO(35, 35, 35, 1),
          maxContentWidth: 150,
          getTooltipItems: (items) => items.map((e) => LineTooltipItem(
            tooltipTextFormatter != null
              ? tooltipTextFormatter!(e.y)
              : e.y.toString(), 
            TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: color
            )
          )).toList()
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    final List<FlSpot> spots = [];

    int topPoint = 0;

    for (var i = 0; i < data.length; i++) {
      if (data[i] > topPoint) topPoint = data[i];
      spots.add(
        FlSpot(i.toDouble(), data[i].toDouble())
      );
    }

    final LineChartBarData line = LineChartBarData(
      spots: spots,
      color:  color,
      isCurved: true,
      barWidth: 2,
      preventCurveOverShooting: true,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.2)
      ),
    );
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: LineChart(
        swapAnimationDuration: const Duration(milliseconds: 0),
        mainData(
          {
            'data': [line],
            'topPoint': topPoint,
          }, 
          appConfigProvider.selectedTheme
        )
      ),
    );
  }
}