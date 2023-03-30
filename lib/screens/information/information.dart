import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/information/cpu.dart';
import 'package:my_server_status/screens/information/memory.dart';
import 'package:my_server_status/screens/information/os.dart';
import 'package:my_server_status/screens/information/network.dart';
import 'package:my_server_status/screens/information/system.dart';
import 'package:my_server_status/screens/information/storage.dart';

import 'package:my_server_status/services/http_requests.dart';
import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/constants/app_icons.dart';
import 'package:my_server_status/constants/enums.dart';
import 'package:my_server_status/providers/servers_provider.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    return InformationScreenWidget(
      serversProvider: serversProvider,
      appConfigProvider: appConfigProvider,
    );
  }
}

class InformationScreenWidget extends StatefulWidget {
  final ServersProvider serversProvider;
  final AppConfigProvider appConfigProvider;

  const InformationScreenWidget({
    Key? key,
    required this.serversProvider,
    required this.appConfigProvider
  }) : super(key: key);

  @override
  State<InformationScreenWidget> createState() => _InformationScreenWidgetState();
}

class _InformationScreenWidgetState extends State<InformationScreenWidget> with TickerProviderStateMixin {
  late TabController tabController;
  final ScrollController scrollController = ScrollController();
  int selectedTab = 0;
  
  Future requestHardwareInfo() async {
    final result = await getSystemInformation(
      server: widget.serversProvider.selectedServer!,
      overrideTimeout: !widget.appConfigProvider.timeoutRequests
    );
    if (result['result'] == 'success') {
      widget.serversProvider.setSystemSpecsInfoData(result['data']);
      widget.serversProvider.setSystemSpecsInfoLoadStatus(LoadStatus.loaded);
      widget.serversProvider.setServerConnected(true);
    }
    else {
      widget.serversProvider.setServerConnected(false);
      widget.serversProvider.setSystemSpecsInfoLoadStatus(LoadStatus.error);
      widget.appConfigProvider.addLog(result['log']);
    }
  }

  @override
  void initState() {
    if (widget.serversProvider.systemSpecsInfo.loadStatus != LoadStatus.loaded) {
      requestHardwareInfo();
    }
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 6,
      vsync: this,
    );
    tabController.addListener(() => setState(() => selectedTab = tabController.index));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: ((context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                title: Text(AppLocalizations.of(context)!.information),
                pinned: true,
                floating: true,
                centerTitle: false,
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  controller: tabController,
                  unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  isScrollable: true,
                  tabs: [
                    Tab(
                      icon: const Icon(Icons.desktop_windows_rounded),
                      text: AppLocalizations.of(context)!.system,
                    ),
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
                    Tab(
                      icon: const Icon(MyServerStatusIcons.software),
                      text: AppLocalizations.of(context)!.operatingSystem,
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
            SystemTab(
              onRefresh: requestHardwareInfo,
            ),
            CpuTab(
              onRefresh: requestHardwareInfo,
            ),
            MemoryTab(
              onRefresh: requestHardwareInfo,
            ),
            StorageTab(
              onRefresh: requestHardwareInfo,
            ),
            NetworkTab(
              onRefresh: requestHardwareInfo,
            ),
            OsTab(
              onRefresh: requestHardwareInfo,
            )
          ]
        ),
      )
    );
  }
}