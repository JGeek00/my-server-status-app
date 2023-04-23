import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/home/network_section.dart';
import 'package:my_server_status/screens/home/memory_section.dart';
import 'package:my_server_status/screens/home/cpu_section.dart';
import 'package:my_server_status/screens/home/home_appbar.dart';
import 'package:my_server_status/screens/home/storage_section.dart';

import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/services/http_requests.dart';
import 'package:my_server_status/constants/enums.dart';
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
  Timer? refreshTimer;

  bool requestInProgress = false;

  Future<bool> requestHardwareInfo() async {
    requestInProgress = true;
    final result = await getHardwareInfo(
      server: widget.serversProvider.selectedServer!,
      overrideTimeout: !widget.appConfigProvider.timeoutRequests
    );
    requestInProgress = false;
    if (result['result'] == 'success') {
      widget.serversProvider.setServerInfoData(result['data']);
      widget.serversProvider.setServerInfoLoadStatus(LoadStatus.loaded);
      widget.serversProvider.setServerConnected(true);
      return true;
    }
    else {
      widget.serversProvider.setServerConnected(false);
      widget.serversProvider.setServerInfoLoadStatus(LoadStatus.error);
      widget.appConfigProvider.addLog(result['log']);
      return false;
    }
  }

  @override
  void initState() {
    if (widget.serversProvider.selectedServer != null) {
      requestHardwareInfo();
      if (widget.appConfigProvider.autoRefreshTimeHome > 0) {
        refreshTimer = Timer.periodic(
          Duration(seconds: widget.appConfigProvider.autoRefreshTimeHome), (_) async {
            if (requestInProgress == false) {
              final result = await requestHardwareInfo();
              if (result == false) {
                refreshTimer!.cancel();
              }
            }
          }
        );
      }
    }
    super.initState();
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
    final serversProvider = Provider.of<ServersProvider>(context);

    final width = MediaQuery.of(context).size.width;

    if (serversProvider.selectedServer == null && refreshTimer != null) {
      refreshTimer!.cancel();
    }

    Widget body() {
      switch (serversProvider.serverInfo.loadStatus) {
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
          if (width > 700) {
            return ListView(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 24,
                          left: 24,
                          right: 16, 
                          bottom: 16
                        ),
                        child: CpuSectionHome(
                          cpuInfo: serversProvider.serverInfo.data!.cpu
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 24,
                          left: 16,
                          right: 24, 
                          bottom: 16
                        ),
                        child: MemorySectionHome(
                          memoryInfo: serversProvider.serverInfo.data!.memory
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 24,
                          right: 16, 
                          bottom: 25
                        ),
                        child: StorageSectionHome(
                          storageInfo: serversProvider.serverInfo.data!.storageFs
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 24, 
                          bottom: 24
                        ),
                        child: NetworkSectionHome(
                          networkInfo: serversProvider.serverInfo.data!.network.where((i) => i.operstate != 'unknown').toList()
                        ),
                      )
                    ),
                  ],
                ),
              ],
            );
          }
          else {
            return ListView(
              children: [
                CpuSectionHome(
                  cpuInfo: serversProvider.serverInfo.data!.cpu
                ),
                MemorySectionHome(
                  memoryInfo: serversProvider.serverInfo.data!.memory
                ),
                StorageSectionHome(
                  storageInfo: serversProvider.serverInfo.data!.storageFs
                ),
                NetworkSectionHome(
                  networkInfo: serversProvider.serverInfo.data!.network.where((i) => i.operstate != 'unknown').toList()
                )
              ],
            );
          }

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

    return Scaffold(
      appBar: HomeAppBar(onRefresh: requestHardwareInfo),
      body: RefreshIndicator(
        onRefresh: requestHardwareInfo,
        child: body(), 
      )
    );
  }
}