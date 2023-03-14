// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:my_server_status/functions/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/settings/app_logs/app_logs.dart';
import 'package:my_server_status/widgets/custom_list_tile.dart';

import 'package:my_server_status/providers/app_config_provider.dart';

class AdvancedSettings extends StatelessWidget {
  const AdvancedSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);
    
    Future updateSslCheck(bool newStatus) async {
      final result = await appConfigProvider.setOverrideSslCheck(newStatus);
      if (result == true) {
        showSnacbkar(
          context: context, 
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.restartAppTakeEffect, 
          color: Colors.green
        );
      }
      else {
        showSnacbkar(
          context: context, 
          appConfigProvider: appConfigProvider, 
          label: AppLocalizations.of(context)!.cannotUpdateSettings, 
          color: Colors.red
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.advancedSettings),
      ),
      body: ListView(
        children: [
          CustomListTile(
            icon: Icons.lock,
            title: AppLocalizations.of(context)!.dontCheckCertificate,
            subtitle: AppLocalizations.of(context)!.dontCheckCertificateDescription,
            trailing: Switch(
              value: appConfigProvider.overrideSslCheck, 
              onChanged: updateSslCheck,
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            onTap: () => updateSslCheck(!appConfigProvider.overrideSslCheck),
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 20,
              right: 10
            )
          ),
          CustomListTile(
            icon: Icons.list_rounded,
            title: AppLocalizations.of(context)!.logs,
            subtitle: AppLocalizations.of(context)!.checkAppLogs,
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AppLogs()
                )
              )
            },
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 20,
              right: 10
            )
          ),
        ],
      ),
    );
  }
}