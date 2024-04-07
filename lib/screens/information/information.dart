import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/information/cpu.dart';
import 'package:my_server_status/screens/information/memory.dart';
import 'package:my_server_status/screens/information/os.dart';
import 'package:my_server_status/screens/information/cpu_desktop.dart';
import 'package:my_server_status/screens/information/network.dart';
import 'package:my_server_status/screens/information/system_desktop.dart';
import 'package:my_server_status/screens/information/system.dart';
import 'package:my_server_status/screens/information/storage.dart';
import 'package:my_server_status/screens/information/memory_desktop.dart';
import 'package:my_server_status/screens/information/network_desktop.dart';
import 'package:my_server_status/screens/information/os_desktop.dart';
import 'package:my_server_status/screens/information/storage_desktop.dart';

import 'package:my_server_status/services/http_requests.dart';
import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/constants/app_icons.dart';
import 'package:my_server_status/constants/enums.dart';
import 'package:my_server_status/providers/servers_provider.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> with TickerProviderStateMixin {
  late TabController tabController;
  final ScrollController scrollController = ScrollController();
  int selectedTab = 0;
  
  Future requestHardwareInfo() async {
    final serversProvider = Provider.of<ServersProvider>(context, listen: false);
    final appConfigProvider = Provider.of<AppConfigProvider>(context, listen: false);
    final result = await getSystemInformation(
      server: serversProvider.selectedServer!,
      overrideTimeout: appConfigProvider.timeoutRequests
    );
    if (result['result'] == 'success') {
      serversProvider.setSystemSpecsInfoData(result['data']);
      serversProvider.setSystemSpecsInfoLoadStatus(LoadStatus.loaded);
      serversProvider.setServerConnected(true);
    }
    else {
      serversProvider.setServerConnected(false);
      serversProvider.setSystemSpecsInfoLoadStatus(LoadStatus.error);
      appConfigProvider.addLog(result['log']);
    }
  }

  @override
  void initState() {
    final serversProvider = Provider.of<ServersProvider>(context, listen: false);
    if (serversProvider.systemSpecsInfo.loadStatus != LoadStatus.loaded && serversProvider.selectedServer != null) {
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
    final serversProvider = Provider.of<ServersProvider>(context);

    PreferredSizeWidget tabBar() {
      return TabBar(
        controller: tabController,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.desktop_windows_rounded),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.system,)
              ],
            )
          ),
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
                Text(AppLocalizations.of(context)!.memory,)
              ],
            )
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(MyServerStatusIcons.storage),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.storage,)
              ],
            )
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.settings_ethernet_rounded),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.network,)
              ],
            )
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(MyServerStatusIcons.software),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.operatingSystem,)
              ],
            )
          ),
        ]
      );
    }

    Widget desktopBody() {
      switch (serversProvider.systemSpecsInfo.loadStatus) {
        case LoadStatus.loading:
          return SizedBox(
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
            ),
          );

        case LoadStatus.loaded:
          return const SingleChildScrollView(
            child: Wrap(
              children: [
                SystemDesktop(),
                CpuDesktop(),
                MemoryDesktop(),
                StorageDesktop(),
                NetworkDesktop(),
                OsDesktop()
              ],
            ),
          );

        case LoadStatus.error:
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

    if (Platform.isAndroid || Platform.isIOS) {
      return DefaultTabController(
        length: 6,
        child: !(Platform.isAndroid || Platform.isIOS)
          ? Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.information),
                centerTitle: false,
                bottom: tabBar()
              ),
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
          : NestedScrollView(
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
                      bottom: tabBar()
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
    else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(AppLocalizations.of(context)!.information),
          actions: [
            if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) ...[
              IconButton(
                onPressed: requestHardwareInfo, 
                icon: const Icon(Icons.refresh_rounded),
                tooltip: AppLocalizations.of(context)!.refresh,
              ),
              const SizedBox(width: 8)
            ]
          ],
        ),
        body: desktopBody()
      );
    }
  }
}