import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/servers/servers.dart';

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

    final server = serversProvider.selectedServer;

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