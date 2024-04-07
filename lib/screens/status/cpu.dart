import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/status/cpu_combined_chart.dart';
import 'package:my_server_status/screens/status/cpu_separated_chart.dart';
import 'package:my_server_status/widgets/tab_content.dart';

import 'package:my_server_status/providers/app_config_provider.dart';
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

    List<Map<String, dynamic>> chartData() {
      if (coreChartConfig.length != widget.data[0].cores.length) {
        for (var _ in widget.data[0].cores) {
          coreChartConfig.add(CoreChartConfig.load);
        }
      }

      if (widget.data.length < 20) {
        List<Map<String, dynamic>> cores = List.filled(widget.data[0].cores.length, {});

        for (var i = 0; i < cores.length; i++) {
          List<double>? temp = List.filled(20, 0);
          List<double> speed = List.filled(20, 0.0);
          List<double> load = List.filled(20, 0.0);

          for (var j = 0; j < widget.data.length; j++) {
            speed[j] = widget.data[j].cores[i].speed ?? 0.0;
            load[j] = widget.data[j].cores[i].load?["load"] ?? 0.0;
          }

          for (var j = 0; j < widget.data.length; j++) {
            if (widget.data[j].cores[i].temperature != null) {
              temp![j] = widget.data[j].cores[i].temperature!.toDouble();
            }
            else {
              temp = null;
              break;
            }
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
          List<double>? temp = [];
          List<double> speed = [];
          List<double> load = [];

          for (var d in widget.data) {
            speed.add(d.cores[i].speed ?? 0.0);
            load.add(d.cores[i].load?["load"] ?? 0.0);
          }

          for (var d in widget.data) {
            if (d.cores[i].temperature != null) {
              temp!.add(d.cores[i].temperature!.toDouble());
            }
            else {
              temp = null;
              break;
            }
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
          if (appConfigProvider.combinedCpuChart == true) CpuCombinedChart(
            formattedData: formattedData, 
            data: widget.data
          ),
          if (appConfigProvider.combinedCpuChart == false) CpuSeparatedChart(
            coreChartConfig: coreChartConfig, 
            formattedData: formattedData, 
            data: widget.data
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