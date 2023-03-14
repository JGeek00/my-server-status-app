import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/home/arc_chart.dart';
import 'package:my_server_status/screens/home/home_appbar.dart';

import 'package:my_server_status/functions/memory_conversion.dart';
import 'package:my_server_status/functions/intermediate_color_generator.dart';
import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/services/http_requests.dart';
import 'package:my_server_status/providers/servers_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    return HomeScreenWidget(
      serversProvider: serversProvider,
      appConfigProvider: appConfigProvider
    );
  }
}

class HomeScreenWidget extends StatefulWidget {
  final ServersProvider serversProvider;
  final AppConfigProvider appConfigProvider;

  const HomeScreenWidget({
    Key? key,
    required this.serversProvider,
    required this.appConfigProvider
  }) : super(key: key);

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {

  Future requestHardwareInfo() async {
    final result = await getHardwareInfo(widget.serversProvider.selectedServer!);
    if (result['result'] == 'success') {
      widget.serversProvider.setServerInfoData(result['data']);
      widget.serversProvider.setServerInfoLoadStatus(1);
      widget.serversProvider.setServerConnected(true);
    }
    else {
      widget.serversProvider.setServerConnected(false);
      widget.serversProvider.setServerInfoLoadStatus(2);
      widget.appConfigProvider.addLog(result['log']);
    }
  }

  @override
  void initState() {
    if (widget.serversProvider.selectedServer != null) {
      requestHardwareInfo();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);

    Widget body() {
      switch (serversProvider.serverInfo.loadStatus) {
        case 0:
          return SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 30),
                Text(
                  AppLocalizations.of(context)!.loadingHardwareInfo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )
              ],
            ),
          );
        case 1: 
          final cpuTemp = serversProvider.serverInfo.data!.cpu.cpuTemperature.main <= 100 
            ? serversProvider.serverInfo.data!.cpu.cpuTemperature.main
            : 100;

          final memoryInfo = serversProvider.serverInfo.data!.memory;

          return ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "CPU",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${serversProvider.serverInfo.data!.cpu.cpu.manufacturer} ${serversProvider.serverInfo.data!.cpu.cpu.brand}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                        Text(
                          "${serversProvider.serverInfo.data!.cpu.cpuCurrentSpeed.avg} GHz",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      ArcChart(
                                        percentage: serversProvider.serverInfo.data!.cpu.cpuCurrentLoad.currentLoad.toDouble(), 
                                        arcWidth: 7, 
                                        color: generateIntermediateColor(
                                          serversProvider.serverInfo.data!.cpu.cpuCurrentLoad.currentLoad.toDouble()
                                        ),
                                        size: 100
                                      ),
                                      SvgPicture.asset(
                                        'assets/resources/cpu.svg',
                                        color: Theme.of(context).colorScheme.onSurface,
                                        width: 40,
                                        height: 40,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${serversProvider.serverInfo.data!.cpu.cpuCurrentLoad.currentLoad.toInt().toString()}%",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      ArcChart(
                                        percentage: cpuTemp.toDouble(), 
                                        arcWidth: 7, 
                                        color: generateIntermediateColor(cpuTemp.toDouble()),
                                        size: 100
                                      ),
                                      const Icon(
                                        Icons.thermostat,
                                        size: 40,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${serversProvider.serverInfo.data!.cpu.cpuTemperature.main.toString()}ºC",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.memory} (RAM)",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${convertMemoryToGb(memoryInfo.memLayout.map((i) => i.size).reduce((a, b) => a+b))} GB ${memoryInfo.memLayout[0].type}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      ArcChart(
                                        percentage: (memoryInfo.mem.active/memoryInfo.mem.total)*100, 
                                        arcWidth: 7, 
                                        color: generateIntermediateColor(
                                          (memoryInfo.mem.active/memoryInfo.mem.total)*100
                                        ),
                                        size: 100
                                      ),
                                      const Icon(
                                        Icons.memory_rounded,
                                        size: 40,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${((memoryInfo.mem.active/memoryInfo.mem.total)*100).toInt().toString()}%",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: SizedBox(
                              height: 100,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.ramUsed,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700
                                        ),
                                      ),
                                      Text("${convertMemoryToGb(memoryInfo.mem.active)} GB (${((memoryInfo.mem.active/memoryInfo.mem.total)*100).toInt().toString()}%)")
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.swapUsed,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700
                                        ),
                                      ),
                                      Text("${convertMemoryToGb(memoryInfo.mem.swapused)} GB (${((memoryInfo.mem.swapused/memoryInfo.mem.swaptotal)*100).toInt().toString()}%)")
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              
            ],
          );

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
                  AppLocalizations.of(context)!.hardwareInfoNotLoaded,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 30),
                TextButton.icon(
                  onPressed: requestHardwareInfo, 
                  icon: const Icon(Icons.refresh_rounded), 
                  label: Text(AppLocalizations.of(context)!.refresh)
                )
              ],
            ),
          );

        default:
          return const SizedBox();
      }
    }

    return Scaffold(
      appBar: const HomeAppBar(),
      body: RefreshIndicator(
        onRefresh: requestHardwareInfo,
        child: body(), 
      )
    );
  }
}