// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_server_status/functions/compare_versions.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/home/power_options_menu.dart';
import 'package:my_server_status/screens/servers/servers.dart';

import 'package:my_server_status/constants/enums.dart';
import 'package:my_server_status/classes/process_modal.dart';
import 'package:my_server_status/functions/snackbar.dart';
import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/services/http_requests.dart';
import 'package:my_server_status/providers/servers_provider.dart';

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  final Future<bool> Function() onRefresh;

  const HomeAppBar({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);

  @override
  PreferredSizeWidget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    final server = serversProvider.selectedServer;

    final width = MediaQuery.of(context).size.width;

    void rebootServer() async {
      ProcessModal process = ProcessModal(context: context);
      process.open(AppLocalizations.of(context)!.rebooting);

      final result = await requestReboot(server: serversProvider.selectedServer!);

      process.close();

      if (result == true) {
        showSnacbkar(
          context: context, 
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.serverRebooted, 
          color: Colors.green,
          labelColor: Colors.white
        );

        serversProvider.setSelectedServer(null);
        serversProvider.setServerConnected(null);
        serversProvider.setServerInfoLoadStatus(LoadStatus.loading);
        serversProvider.setSystemSpecsInfoLoadStatus(LoadStatus.loading);
      }
      else {
        showSnacbkar(
          context: context, 
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.serverRebootFailed, 
          color: Colors.red,
          labelColor: Colors.white
        );
      }
    }

    void powerOffServer() async {
      ProcessModal process = ProcessModal(context: context);
      process.open(AppLocalizations.of(context)!.turningOff);

      final result = await requestPowerOff(server: serversProvider.selectedServer!);

      process.close();

      if (result == true) {
        showSnacbkar(
          context: context, 
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.serverPoweredOff, 
          color: Colors.green,
          labelColor: Colors.white
        );
        
        serversProvider.setSelectedServer(null);
        serversProvider.setServerConnected(null);
        serversProvider.setServerInfoLoadStatus(LoadStatus.loading);
        serversProvider.setSystemSpecsInfoLoadStatus(LoadStatus.loading);
      }
      else {
        showSnacbkar(
          context: context, 
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.serverPoweredOffFailed, 
          color: Colors.red,
          labelColor: Colors.white
        );
      }
    }

    return AppBar(
      toolbarHeight: 70,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 48),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (serversProvider.selectedServer != null) ...[
                  Text(
                    server!.name,
                    style: const TextStyle(
                      fontSize: 24
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${server.connectionMethod}://${server.domain}${server.path ?? ""}${server.port != null ? ':${server.port}' : ""}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).listTileTheme.textColor
                    ),
                  )
                ],
                if (serversProvider.selectedServer == null) Text(
                  AppLocalizations.of(context)!.noServerSelected,
                  style: const TextStyle(
                    fontSize: 20
                  ),
                ),
              ],
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () => Future.delayed(const Duration(seconds: 0), () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const Servers()
                    ));
                  }),
                  child: Row(
                    children: [
                      const Icon(Icons.storage_rounded),
                      const SizedBox(width: 10),
                      Text(AppLocalizations.of(context)!.servers)
                    ],
                  ),
                ),
                if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) PopupMenuItem(
                  onTap: () => Future.delayed(const Duration(seconds: 0), () => onRefresh()),
                  child: Row(
                    children: [
                      const Icon(Icons.refresh_rounded),
                      const SizedBox(width: 10),
                      Text(AppLocalizations.of(context)!.refresh)
                    ],
                  ),
                ),
                if (
                  serversProvider.selectedServer!.apiVersion != null &&
                  serverVersionIsAhead(
                    currentVersion: serversProvider.selectedServer!.apiVersion!,
                    referenceVersion: '1.1.0'
                  )
                ) PopupMenuItem(
                  onTap: () => Future.delayed(const Duration(seconds: 0), () {
                    if (width > 700) {
                      showDialog(
                        context: context, 
                        builder: (context) => PowerOptionsMenu(
                          isDialog: true,
                          onPowerOff: powerOffServer,
                          onReboot: rebootServer,
                        )
                      );
                    }
                    else {
                      showModalBottomSheet(
                        isScrollControlled: true,  
                        context: context, 
                        builder: (context) => PowerOptionsMenu(
                          isDialog: false,
                          onPowerOff: powerOffServer,
                          onReboot: rebootServer,
                        )
                      );
                    }
                  }),
                  child: Row(
                    children: [
                      const Icon(Icons.settings_power_rounded),
                      const SizedBox(width: 10),
                      Text(AppLocalizations.of(context)!.powerOptions)
                    ],
                  ),
                ),
              ]
            )
          ],
        ),
      ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(74);
}