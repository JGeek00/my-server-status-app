import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartTile {
  final String label;
  final double value;
  final Color color;

  const PieChartTile({
    required this.label,
    required this.value,
    required this.color
  });
}

class CustomPieChart extends StatelessWidget {
  final List<PieChartTile> data;

  const CustomPieChart({
    Key? key,
    required this.data,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Map<String, double> generateValues() {
      Map<String, double> v = {};
      for (var item in data) {
        v = {
          ...v,
          item.label: item.value
        };
      }
      return v;
    }
    
    return PieChart(
      dataMap: generateValues(),
      animationDuration: const Duration(milliseconds: 800),
      colorList: data.map((e) => e.color).toList(),
      initialAngleInDegree: 270,
      chartType: ChartType.ring,
      ringStrokeWidth: 16,
      legendOptions: const LegendOptions(
        showLegends: false
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValues: false,
      ),
    );
  }
}