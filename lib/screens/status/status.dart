import 'dart:async';

import 'package:flutter/material.dart';
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

class StatusScreen extends StatelessWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    return CurrentStatusWidget(
      serversProvider: serversProvider,
      appConfigProvider: appConfigProvider,
    );
  }
}

class CurrentStatusWidget extends StatefulWidget {
  final ServersProvider serversProvider;
  final AppConfigProvider appConfigProvider;

  const CurrentStatusWidget({
    Key? key,
    required this.serversProvider,
    required this.appConfigProvider,
  }) : super(key: key);

  @override
  State<CurrentStatusWidget> createState() => _CurrentStatusWidgetState();
}

class _CurrentStatusWidgetState extends State<CurrentStatusWidget> with TickerProviderStateMixin {
  late TabController tabController;
  final ScrollController scrollController = ScrollController();

  List<CurrentStatus> currentStatus = [];
  int loadStatus = 0;

  Timer? refreshTimer;

  Future requestCurrentStatus() async {
    final result = await getCurrentStatus(widget.serversProvider.selectedServer!);
    if (result['result'] == 'success') {
      currentStatus.add(result['data']);
      if (currentStatus.length > 20) {
        currentStatus.removeAt(0);
      }
      loadStatus = 1;
      widget.serversProvider.setServerConnected(true);
    }
    else {
      widget.serversProvider.setServerConnected(false);
      loadStatus = 2;
      widget.appConfigProvider.addLog(result['log']);
    }
  }

  @override
  void initState() {
    if (widget.serversProvider.selectedServer != null) {
      requestCurrentStatus();
      if (widget.appConfigProvider.autoRefreshTimeHome > 0) {
        refreshTimer = Timer.periodic(
          Duration(seconds: widget.appConfigProvider.autoRefreshTimeHome), (_) => requestCurrentStatus()
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
      if (loadStatus == 1 && currentStatus[0].storage != null) {
        return currentStatus.map((e) => e.storage!).toList();
      }
      else {
        return null;
      }
    }

    List<List<Network>>? getNetwork() {
      if (loadStatus == 1 && currentStatus[0].storage != null) {
        return currentStatus.map((e) => e.network!).toList();
      }
      else {
        return null;
      }
    }

    return DefaultTabController(
      length: 4,
      child: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: ((context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                top: false,
                sliver: SliverAppBar(
                  title: Text(AppLocalizations.of(context)!.status),
                  pinned: true,
                  floating: true,
                  centerTitle: false,
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    controller: tabController,
                    unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    isScrollable: false,
                    tabs: [
                      const Tab(
                        icon: Icon(Icons.memory_rounded),
                        text: "CPU",
                      ),
                      Tab(
                        icon: const Icon(MyServerStatusIcons.memory),
                        text: AppLocalizations.of(context)!.memory,
                      ),
                      Tab(
                        icon: const Icon(MyServerStatusIcons.storage),
                        text: AppLocalizations.of(context)!.storage,
                      ),
                      Tab(
                        icon: const Icon(Icons.settings_ethernet_rounded),
                        text: AppLocalizations.of(context)!.network,
                      ),
                    ]
                  )
                ),
              ),
            )
          ];
        }), 
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)
              )
            )
          ),
          child: TabBarView(
            controller: tabController,
            children: [
              RefreshIndicator(
                onRefresh: requestCurrentStatus,
                child: CpuTab(
                  loadStatus: loadStatus,
                  data: getCpu(),
                ), 
              ),
              RefreshIndicator(
                onRefresh: requestCurrentStatus,
                child: MemoryTab(
                  loadStatus: loadStatus,
                  data: getMemory(),
                ), 
              ),
              RefreshIndicator(
                onRefresh: requestCurrentStatus,
                child: StorageTab(
                  loadStatus: loadStatus,
                  data: getStorage()
                ), 
              ),
              RefreshIndicator(
                onRefresh: requestCurrentStatus,
                child: NetworkTab(
                  loadStatus: loadStatus,
                  data: getNetwork()
                ), 
              ),
            ]
          )
        ),
      )
    );
  }
}