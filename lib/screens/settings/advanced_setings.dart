// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/settings/app_logs/app_logs.dart';
import 'package:my_server_status/widgets/custom_list_tile.dart';
import 'package:my_server_status/widgets/custom_switch_list_tile.dart';

import 'package:my_server_status/functions/snackbar.dart';
import 'package:my_server_status/providers/app_config_provider.dart';

class AdvancedSettings extends StatelessWidget {
  const AdvancedSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    Future changeSetting({
      required Function fn, 
      required bool value,
      String? customSuccessMessage,
      String? customErrorMessage
    }) async {
      final result = await fn(value);
      if (result == true) {
        showSnackbar(
          appConfigProvider: appConfigProvider, 
          label: customSuccessMessage ?? AppLocalizations.of(context)!.settingsUpdatedSuccessfully, 
          color: Colors.green
        );
      }
      else {
        showSnackbar(
          appConfigProvider: appConfigProvider, 
          label: customErrorMessage ?? AppLocalizations.of(context)!.cannotUpdateSettings, 
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
          CustomSwitchListTile(
            icon: Icons.lock,
            title: AppLocalizations.of(context)!.dontCheckCertificate,
            subtitle: AppLocalizations.of(context)!.dontCheckCertificateDescription,
            value: appConfigProvider.overrideSslCheck,
            onChanged: (v) => changeSetting(
              fn: appConfigProvider.setOverrideSslCheck, 
              value: v,
              customSuccessMessage: AppLocalizations.of(context)!.restartAppTakeEffect,
            ),
          ),
          CustomSwitchListTile(
            icon: Icons.timer_rounded,
            title: AppLocalizations.of(context)!.enableTimeoutOnRequests,
            subtitle: AppLocalizations.of(context)!.enableTimeoutOnRequestsDescription,
            value: appConfigProvider.timeoutRequests,
            onChanged: (v) => changeSetting(
              fn: appConfigProvider.setTimeoutRequests, 
              value: v
            ),
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