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
    final result = await getHardwareInfo(widget.serversProvider.selectedServer!);
    requestInProgress = false;
    if (result['result'] == 'success') {
      widget.serversProvider.setServerInfoData(result['data']);
      widget.serversProvider.setServerInfoLoadStatus(1);
      widget.serversProvider.setServerConnected(true);
      return true;
    }
    else {
      widget.serversProvider.setServerConnected(false);
      widget.serversProvider.setServerInfoLoadStatus(2);
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

    if (serversProvider.selectedServer == null && refreshTimer != null) {
      refreshTimer!.cancel();
    }

    Widget body() {
      switch (serversProvider.serverInfo.loadStatus) {
        case 0:
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
        case 1: 
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