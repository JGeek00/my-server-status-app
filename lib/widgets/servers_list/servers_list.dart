// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/add_server_modal.dart';
import 'package:my_server_status/widgets/servers_list/delete_modal.dart';

import 'package:my_server_status/models/app_log.dart';
import 'package:my_server_status/classes/process_modal.dart';
import 'package:my_server_status/constants/enums.dart';
import 'package:my_server_status/functions/snackbar.dart';
import 'package:my_server_status/models/server.dart';
import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/providers/servers_provider.dart';
import 'package:my_server_status/services/http_requests.dart';


class ServersList extends StatefulWidget {
  final BuildContext context;
  final List<ExpandableController> controllers;
  final Function(int) onChange;
  final ScrollController scrollController;

  const ServersList({
    Key? key,
    required this.context,
    required this.controllers,
    required this.onChange,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<ServersList> createState() => _ServersListState();
}

class _ServersListState extends State<ServersList> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    for (ExpandableController controller in widget.controllers) {
      controller.addListener(() async {
        await Future.delayed(const Duration(milliseconds: 200));
        if (controller.value == false) {
          animationController.animateTo(0);
        }
        else {
          animationController.animateBack(1);
        }
      });
    }

    animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )
    ..addListener(() => setState(() => {}));
    animation = Tween(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut
    ));
    
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    final width = MediaQuery.of(context).size.width;

    List<Server> servers = serversProvider.serversList;

    void showDeleteModal(Server server) async {
      await Future.delayed(const Duration(seconds: 0), () => {
        showDialog(
          context: context, 
          builder: (context) => DeleteModal(
            serverToDelete: server,
          ),
          barrierDismissible: false
        )
      });
    }

    void openAddServerBottomSheet({Server? server}) async {
      await Future.delayed(const Duration(seconds: 0), (() => {
        if (width > 700) {
          showDialog(
            context: context, 
            barrierDismissible: false,
            builder: (context) => const AddServerModal(
              window: true,
            ),
          )
        }
        else {
          Navigator.push(context, MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) => AddServerModal(
              server: server,
              window: false,
            )
          ))
        }
      }));
    }

    void connectToServer(Server server) async {
      final ProcessModal process = ProcessModal(context: context);
      process.open(AppLocalizations.of(context)!.connecting);

      final result = await login(server);

      if (result['result'] == 'success') {
        serversProvider.setSystemSpecsInfoLoadStatus(LoadStatus.loading);
        serversProvider.setSystemSpecsInfoData(null);
        
        serversProvider.setSelectedServer(server);
        serversProvider.setServerConnected(true);

        process.close();
      }
      else {
        process.close();
        appConfigProvider.addLog(result['log']);
        showSnacbkar(
          context: context, 
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.cannotConnect, 
          color: Colors.red
        );
      }
    }

    void setDefaultServer(Server server) async {
      final result = await serversProvider.setDefaultServer(server);
      if (result == null) {
        showSnacbkar(
          context: context, 
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.connectionDefaultSuccessfully, 
          color: Colors.green
        );
      }
      else {
        appConfigProvider.addLog(
          AppLog(
            type: 'set_default_server', 
            dateTime: DateTime.now(),
            message: result.toString()
          )
        );
        showSnacbkar(
          context: context, 
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.connectionDefaultFailed, 
          color: Colors.red
        );
      }
    }

    Widget leadingIcon(Server server) {
      if (server.defaultServer == true) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.storage_rounded,
              color: serversProvider.selectedServer != null && 
                serversProvider.serverConnected != null && 
                serversProvider.selectedServer?.id == server.id
                  ? serversProvider.serverConnected != null
                    ? Colors.green
                    : Colors.orange
                  : null,
            ),
            SizedBox(
              width: 25,
              height: 25,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      size: 10,
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }
      else {
        return Icon(
          Icons.storage_rounded,
          color: serversProvider.selectedServer != null && 
            serversProvider.serverConnected != null && 
            serversProvider.selectedServer?.id == server.id
              ? serversProvider.serverConnected != null
                ? Colors.green
                : Colors.orange
              : null,
        );
      }
    }

    Widget topRow(Server server, int index, bool showArrow) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: leadingIcon(servers[index]),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${server.connectionMethod}://${server.domain}${server.path ?? ""}${server.port != null ? ':${server.port}' : ""}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.onSurface
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 3),
                          Text(
                            servers[index].name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.onSurfaceVariant
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (showArrow == true) RotationTransition(
            turns: animation,
            child: const Icon(Icons.keyboard_arrow_down_rounded),
          ),
        ],
      );
    }

    Widget bottomRow(Server server, int index) {
      return Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PopupMenuButton(
                // color: Theme.of(context).dialogBackgroundColor,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    enabled: server.defaultServer == false 
                      ? true
                      : false,
                    onTap: server.defaultServer == false 
                      ? (() => setDefaultServer(server))
                      : null, 
                    child: SizedBox(
                      child: Row(
                        children: [
                          const Icon(Icons.star),
                          const SizedBox(width: 15),
                          Text(
                            server.defaultServer == true 
                              ? AppLocalizations.of(context)!.defaultConnection
                              : AppLocalizations.of(context)!.setDefault,
                          )
                        ],
                      ),
                    )
                  ),
                  PopupMenuItem(
                    onTap: (() => openAddServerBottomSheet(server: server)), 
                    child: Row(
                      children: [
                        const Icon(Icons.edit),
                        const SizedBox(width: 15),
                        Text(AppLocalizations.of(context)!.edit)
                      ],
                    )
                  ),
                  PopupMenuItem(
                    onTap: (() => showDeleteModal(server)), 
                    child: Row(
                      children: [
                        const Icon(Icons.delete),
                        const SizedBox(width: 15),
                        Text(AppLocalizations.of(context)!.delete)
                      ],
                    )
                  ),
                ]
              ),
              SizedBox(
                child: serversProvider.selectedServer != null && 
                  serversProvider.serverConnected != null && 
                  serversProvider.selectedServer?.id == servers[index].id
                    ? Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: serversProvider.serverConnected == true
                          ? Colors.green
                          : Colors.orange,
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Row(
                        children: [
                          Icon(
                            serversProvider.serverConnected == true
                              ? Icons.check
                              : Icons.warning,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            serversProvider.serverConnected == true
                              ? AppLocalizations.of(context)!.connected
                              : AppLocalizations.of(context)!.selectedDisconnected,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500
                            ),
                          )
                        ],
                        ),
                    )
                    : Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: TextButton(
                          onPressed: () => connectToServer(servers[index]),
                          child: Text(AppLocalizations.of(context)!.connect),
                        ),
                      ),
              )
            ],
          )
        ],
      );
    }

    Widget serverRow(int index) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.surfaceVariant,
              width: 1
            )
          )
        ),
        child: ExpandableNotifier(
          controller: widget.controllers[index],
          child: Column(
            children: [
              Expandable(
                collapsed: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => widget.onChange(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: topRow(servers[index], index, true),
                    ),
                  ),
                ),
                expanded: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => widget.onChange(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        children: [
                          topRow(servers[index], index, true),
                          bottomRow(servers[index], index)
                        ],
                      ),
                    ),
                  ),
                )
              ) 
            ],
          ),
        ),
      );
    }

    EdgeInsets generateMargins(int index) {
      if (index == 0) {
        return const EdgeInsets.only(top: 16, left: 16, right: 8, bottom: 8);
      }
      if (index == 1) {
        return const EdgeInsets.only(top: 16, left: 8, right: 16, bottom: 8);
      }
      else if (index == servers.length-1 && index%2 == 0) {
        return const EdgeInsets.only(top: 8, left: 8, right: 16, bottom: 16);
      }
      else if (index == servers.length-1 && index%2 == 1) {
        return const EdgeInsets.only(top: 8, left: 16, right: 8, bottom: 16);
      }
      else {
        if (index%2 == 0) {
          return const EdgeInsets.only(top: 8, left: 8, right: 16, bottom: 8);
        }
        else {
          return const EdgeInsets.only(top: 8, left: 16, right: 8, bottom: 8);
        }
      }
    }

    Widget serverTile(int index) {
      return SizedBox(
        width: (width/2)-4,
        child: Card(
          margin: generateMargins(index),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                topRow(servers[index], index, false),
                bottomRow(servers[index], index)
              ],
            ),
          ),
        ),
      );
    }

    if (servers.isNotEmpty) {
      if (width > 700) {
        return ListView(
          children: [
            Wrap(
              children: servers.asMap().entries.map((s) => serverTile(s.key)).toList(),
            ),
            const SizedBox(height: 8)
          ],
        );
      }
      else {  
        return ListView.builder(
          controller: widget.scrollController,
          itemCount: servers.length,
          itemBuilder: (context, index) => serverRow(index)
        );
      }
    }
    else {
      return SizedBox(
        height: double.maxFinite,
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.noSavedConnections,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }
  }
}