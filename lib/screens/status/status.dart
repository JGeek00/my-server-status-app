import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_server_status/constants/enums.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/status/cpu.dart';
import 'package:my_server_status/screens/status/memory.dart';
import 'package:my_server_status/screens/status/network.dart';
import 'package:my_server_status/screens/status/storage.dart';

import 'package:my_server_status/services/http_requests.dart';
import 'package:my_server_status/models/current_status.dart';
import 'package:my_server_status/constants/app_icons.dart';
import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/providers/servers_provider.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> with TickerProviderStateMixin {
  late TabController tabController;
  final ScrollController scrollController = ScrollController();

  List<CurrentStatus> currentStatus = [];
  LoadStatus loadStatus = LoadStatus.loading;

  Timer? refreshTimer;

  bool isRefreshing = false;

  Future<bool> requestCurrentStatus() async {
    final serversProvider = Provider.of<ServersProvider>(context, listen: false);
    final appConfigProvider = Provider.of<AppConfigProvider>(context, listen: false);
    setState(() =>  isRefreshing = true);
    final result = await getCurrentStatus(
      server: serversProvider.selectedServer!,
      overrideTimeout: !appConfigProvider.timeoutRequests
    );
    if (!mounted) return false;
    setState(() =>  isRefreshing = false);
    if (result['result'] == 'success') {
      currentStatus.add(result['data']);
      if (currentStatus.length > 20) {
        currentStatus.removeAt(0);
      }
      loadStatus = LoadStatus.loaded;
      serversProvider.setServerConnected(true);
      return true;
    }
    else {
      serversProvider.setServerConnected(false);
      loadStatus = LoadStatus.error;
      appConfigProvider.addLog(result['log']);
      return false;
    }
  }

  @override
  void initState() {
    final serversProvider = Provider.of<ServersProvider>(context, listen: false);
    final appConfigProvider = Provider.of<AppConfigProvider>(context, listen: false);
    if (serversProvider.selectedServer != null) {
      requestCurrentStatus();
      setState(() => isRefreshing = false);
      if (appConfigProvider.autoRefreshTimeStatus > 0) {
        refreshTimer = Timer.periodic(
          Duration(seconds: appConfigProvider.autoRefreshTimeStatus), (_) async {
            if (isRefreshing == false) {
              final result = await requestCurrentStatus();
              if (result == false && mounted) {
                refreshTimer!.cancel();
              }
            }
          }
        );
      }
    }
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    if (refreshTimer != null) {
      refreshTimer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Cpu> getCpu() {
      return currentStatus.map((e) => e.cpu).toList();
    }

    List<Memory> getMemory() {
      return currentStatus.map((e) => e.memory).toList();
    }

    List<Storage>? getStorage() {
      if (loadStatus == LoadStatus.loaded && currentStatus[0].storage != null) {
        return currentStatus.map((e) => e.storage!).toList();
      }
      else {
        return null;
      }
    }

    List<List<Network>>? getNetwork() {
      if (loadStatus == LoadStatus.loaded && currentStatus[0].storage != null) {
        return currentStatus.map((e) => e.network!).toList();
      }
      else {
        return null;
      }
    }

    return DefaultTabController(
      length: 4,
      child: !(Platform.isAndroid || Platform.isIOS)
        ? Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.status),
              centerTitle: false,
              actions: [
                if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) ...[
                  IconButton(
                    onPressed: requestCurrentStatus, 
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: AppLocalizations.of(context)!.refresh,
                  ),
                  const SizedBox(width: 8)
                ]
              ],
              bottom: TabBar(
                controller: tabController,
                unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [
                  const Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.memory_rounded),
                        SizedBox(width: 8),
                        Text("CPU")
                      ],
                    )
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(MyServerStatusIcons.memory),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.memory)
                      ],
                    )
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(MyServerStatusIcons.storage),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.storage)
                      ],
                    )
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.settings_ethernet_rounded),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.network)
                      ],
                    )
                  ),
                ]
              )
            ),
            body: TabBarView(
              controller: tabController,
              children: [
                CpuTab(
                  loadStatus: loadStatus,
                  data: getCpu(),
                  onRefresh: requestCurrentStatus,
                ),
                MemoryTab(
                  loadStatus: loadStatus,
                  data: getMemory(),
                  onRefresh: requestCurrentStatus,
                ),
                StorageTab(
                  loadStatus: loadStatus,
                  data: getStorage(),
                  onRefresh: requestCurrentStatus,
                ),
                NetworkTab(
                  loadStatus: loadStatus,
                  data: getNetwork(),
                  onRefresh: requestCurrentStatus,
                ),
              ]
            ),
        ) : NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: ((context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  title: Text(AppLocalizations.of(context)!.status),
                  pinned: true,
                  floating: true,
                  centerTitle: false,
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    controller: tabController,
                    unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    isScrollable: true,
                    tabs: [
                      const Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.memory_rounded),
                            SizedBox(width: 8),
                            Text("CPU")
                          ],
                        )
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(MyServerStatusIcons.memory),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.memory)
                          ],
                        )
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(MyServerStatusIcons.storage),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.storage)
                          ],
                        )
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.settings_ethernet_rounded),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.network)
                          ],
                        )
                      ),
                    ]
                  )
                ),
              )
            ];
          }), 
          body: TabBarView(
            controller: tabController,
            children: [
              CpuTab(
                loadStatus: loadStatus,
                data: getCpu(),
                onRefresh: requestCurrentStatus,
              ),
              MemoryTab(
                loadStatus: loadStatus,
                data: getMemory(),
                onRefresh: requestCurrentStatus,
              ),
              StorageTab(
                loadStatus: loadStatus,
                data: getStorage(),
                onRefresh: requestCurrentStatus,
              ),
              NetworkTab(
                loadStatus: loadStatus,
                data: getNetwork(),
                onRefresh: requestCurrentStatus,
              ),
            ]
          ),
        )
    );
  }
}