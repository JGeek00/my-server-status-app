import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/information/cpu.dart';
import 'package:my_server_status/screens/information/memory.dart';
import 'package:my_server_status/screens/information/system.dart';
import 'package:my_server_status/screens/information/storage.dart';

import 'package:my_server_status/services/http_requests.dart';
import 'package:my_server_status/providers/app_config_provider.dart';
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
    final result = await getSystemInformation(widget.serversProvider.selectedServer!);
    if (result['result'] == 'success') {
      widget.serversProvider.setSystemSpecsInfoData(result['data']);
      widget.serversProvider.setSystemSpecsInfoLoadStatus(1);
      widget.serversProvider.setServerConnected(true);
    }
    else {
      widget.serversProvider.setServerConnected(false);
      widget.serversProvider.setSystemSpecsInfoLoadStatus(2);
      widget.appConfigProvider.addLog(result['log']);
    }
  }

  @override
  void initState() {
    if (widget.serversProvider.systemSpecsInfo.loadStatus != 1) {
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
              sliver: SliverSafeArea(
                top: false,
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
                        icon: SvgPicture.asset(
                          'assets/resources/memory.svg',
                          height: 24,
                          width: 24,
                          color: selectedTab == 2
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        text: AppLocalizations.of(context)!.memory,
                      ),
                      Tab(
                        icon: SvgPicture.asset(
                          'assets/resources/storage.svg',
                          height: 24,
                          width: 24,
                          color: selectedTab == 3
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        text: AppLocalizations.of(context)!.storage,
                      ),
                      Tab(
                        icon: const Icon(Icons.settings_ethernet_rounded),
                        text: AppLocalizations.of(context)!.network,
                      ),
                      Tab(
                        icon: SvgPicture.asset(
                          'assets/resources/software.svg',
                          height: 24,
                          width: 24,
                          color: selectedTab == 5
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        text: AppLocalizations.of(context)!.software,
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
                onRefresh: requestHardwareInfo,
                child: const SystemTab(), 
              ),
              RefreshIndicator(
                onRefresh: requestHardwareInfo,
                child: const CpuTab(), 
              ),
              RefreshIndicator(
                onRefresh: requestHardwareInfo,
                child: const MemoryTab(), 
              ),
              RefreshIndicator(
                onRefresh: requestHardwareInfo,
                child: const StorageTab(), 
              ),
              
              Container(),
              Container()
            ]
          )
        ),
      )
    );
  }
}