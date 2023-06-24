import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/docker/custom_pie_chart.dart';
import 'package:my_server_status/widgets/section_label.dart';
import 'package:my_server_status/widgets/tab_content.dart';

import 'package:my_server_status/functions/memory_conversion.dart';
import 'package:my_server_status/constants/docker_icons.dart';
import 'package:my_server_status/constants/enums.dart';
import 'package:my_server_status/models/docker_information.dart';
import 'package:my_server_status/providers/servers_provider.dart';
import 'package:my_server_status/services/http_requests.dart';

class InformationTab extends StatefulWidget {
  const InformationTab({Key? key}) : super(key: key);

  @override
  State<InformationTab> createState() => _InformationTabState();
}

class _InformationTabState extends State<InformationTab> {
  LoadStatus loadStatus = LoadStatus.loading;
  DockerInformation? data;

  Future loadData() async {
    final server = Provider.of<ServersProvider>(context, listen: false).selectedServer;
    final result = await getDockerInfo(server: server!);
    if (result['result'] == 'success') {
      setState(() {
        data = result['data'];
        loadStatus = LoadStatus.loaded;
      });
    }
    else {
      setState(() => loadStatus = LoadStatus.error);
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget legendTile(String label, Color color, String value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16)
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500
                ),
              ),
            ],
          ),
          Text(value)
        ],
      );
    }

    return CustomTabContent(
      loadingGenerator: () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 30),
          Text(
            AppLocalizations.of(context)!.loadingDockerInformation,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          )
        ],
      ), 
      contentGenerator: () {
        if (data!.containers != null || data!.images != null) {
          return [
            const SizedBox(height: 16),
            SectionLabel(label: AppLocalizations.of(context)!.dockerStatus),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Icon(
                        DockerIcons.cd,
                        size: 40,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.images,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data!.images.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        DockerIcons.drive,
                        size: 40,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.containers,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data!.containers.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SectionLabel(label: AppLocalizations.of(context)!.containersStatus),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 0
              ),
              child: Row(
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width-32)*0.5,
                    height: (MediaQuery.of(context).size.width-32)*0.5,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Stack(
                      children: [
                        CustomPieChart(
                          data: [
                            PieChartTile(
                              label: "running", 
                              value: data!.containersRunning!.toDouble(), 
                              color: Colors.green
                            ),
                            PieChartTile(
                              label: "paused", 
                              value: data!.containersPaused!.toDouble(), 
                              color: Colors.orange
                            ),
                            PieChartTile(
                              label: "stopped", 
                              value: data!.containersStopped!.toDouble(), 
                              color: Colors.red
                            ),
                          ]
                        ),
                        Center(
                          child: Icon(
                            DockerIcons.drive,
                            size: 36,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: (MediaQuery.of(context).size.width-32)*0.5,
                    child: Column(
                      children: [
                        legendTile(
                          AppLocalizations.of(context)!.running, 
                          Colors.green, 
                          data!.containersRunning!.toString()
                        ),
                        const SizedBox(height: 16),
                        legendTile(
                          AppLocalizations.of(context)!.paused, 
                          Colors.orange, 
                          data!.containersPaused!.toString()
                        ),
                        const SizedBox(height: 16),
                        legendTile(
                          AppLocalizations.of(context)!.stopped, 
                          Colors.red, 
                          data!.containersStopped!.toString()
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SectionLabel(label: AppLocalizations.of(context)!.hardwareResources),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.memory_rounded,
                        size: 40,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.cpuCores,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data!.ncpu.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        DockerIcons.drive,
                        size: 40,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.memory,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${convertMemoryToGb(data!.memTotal!)} GB",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ];
        }
        else {
          return [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: MediaQuery.of(context).size.height-140,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    DockerIcons.docker,
                    size: 50,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    AppLocalizations.of(context)!.dockerNotAvailable,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          ];
        }
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
            AppLocalizations.of(context)!.dockerInformationNotLoaded,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ), 
      loadStatus: loadStatus, 
      onRefresh: loadData,
    );
  }
}