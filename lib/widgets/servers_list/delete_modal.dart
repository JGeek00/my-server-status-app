// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/functions/snackbar.dart';
import 'package:my_server_status/models/server.dart';
import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/providers/servers_provider.dart';


class DeleteModal extends StatelessWidget {
  final Server serverToDelete;

  const DeleteModal({
    Key? key,
    required this.serverToDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    void removeServer() async {
      final deleted = await serversProvider.removeServer(serverToDelete);
      Navigator.pop(context);
      if (deleted == true) {
        showSnacbkar(
          context: context, 
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.connectionRemoved, 
          color: Colors.green
        );
      }
      else {
        showSnacbkar(
          context: context, 
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.connectionCannotBeRemoved, 
          color: Colors.red
        );
      }
    }

    return AlertDialog(
      title: Column(
        children: [
          Icon(
            Icons.delete,
            size: 24,
            color: Theme.of(context).listTileTheme.iconColor
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              AppLocalizations.of(context)!.remove,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurface
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                AppLocalizations.of(context)!.removeWarning,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "${serverToDelete.connectionMethod}://${serverToDelete.domain}${serverToDelete.path ?? ""}${serverToDelete.port != null ? ':${serverToDelete.port}' : ""}",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.onSurfaceVariant
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => {
            Navigator.pop(context)
          }, 
          child: Text(AppLocalizations.of(context)!.cancel)
        ),
        TextButton(
          onPressed: removeServer,
          child: Text(AppLocalizations.of(context)!.remove),
        ),
      ],
    );
  }
}