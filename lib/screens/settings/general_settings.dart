// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/settings/auto_refresh_time_modal.dart';
import 'package:my_server_status/widgets/custom_switch_list_tile.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/functions/snackbar.dart';
import 'package:my_server_status/widgets/custom_list_tile.dart';

class GeneralSettings extends StatelessWidget {
  const GeneralSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    void openAutoRefreshTimeModal(int time, String screen) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => AutoRefreshTimeModal(
          time: time, 
          screenHeight: MediaQuery.of(context).size.height,
          screen: screen,
          onChange: (value) async {
            final result = screen == "Status"
              ? await appConfigProvider.setAutoRefreshTimeStatus(value)
              : await appConfigProvider.setAutoRefreshTimeHome(value);
            if (result == true) {
              showSnacbkar(
                context: context, 
                appConfigProvider: appConfigProvider, 
                label: AppLocalizations.of(context)!.settingsSavedSuccessfully, 
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
        )
      );
    }

    Future changeSetting({
      required Function fn, 
      required bool value,
      String? customSuccessMessage,
      String? customErrorMessage
    }) async {
      final result = await fn(value);
      if (result == true) {
        showSnacbkar(
          context: context, 
          appConfigProvider: appConfigProvider, 
          label: customSuccessMessage ?? AppLocalizations.of(context)!.settingsUpdatedSuccessfully, 
          color: Colors.green
        );
      }
      else {
        showSnacbkar(
          context: context, 
          appConfigProvider: appConfigProvider, 
          label: customErrorMessage ?? AppLocalizations.of(context)!.cannotUpdateSettings, 
          color: Colors.red
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.generalSettings) ,
      ),
      body: ListView(
        children: [
          SectionLabel(label: AppLocalizations.of(context)!.home),
          CustomListTile(
            icon: Icons.refresh_rounded,
            title: AppLocalizations.of(context)!.autoRefreshTimeHome,
            subtitle: appConfigProvider.autoRefreshTimeHome == 0 
              ? AppLocalizations.of(context)!.disabled
              : AppLocalizations.of(context)!.autoRefreshValue(appConfigProvider.autoRefreshTimeHome),
            onTap: () => openAutoRefreshTimeModal(appConfigProvider.autoRefreshTimeHome, "Home"),
          ),
          SectionLabel(label: AppLocalizations.of(context)!.information),
          CustomSwitchListTile(
            icon: Icons.storage_rounded,
            title: AppLocalizations.of(context)!.hideVolumesNoMountPoint,
            subtitle: AppLocalizations.of(context)!.hideVolumesNoMountPointDescription,
            value: appConfigProvider.hideVolumesNoMountPoint,
            onChanged: (v) => changeSetting(
              fn: appConfigProvider.setHideVolumesNoMountPoint, 
              value: v
            ),
          ),
          SectionLabel(label: AppLocalizations.of(context)!.status),
          CustomListTile(
            icon: Icons.refresh_rounded,
            title: AppLocalizations.of(context)!.autoRefreshTimeStatus,
            subtitle: appConfigProvider.autoRefreshTimeStatus == 0 
              ? AppLocalizations.of(context)!.disabled
              : AppLocalizations.of(context)!.autoRefreshValue(appConfigProvider.autoRefreshTimeStatus),
            onTap: () => openAutoRefreshTimeModal(appConfigProvider.autoRefreshTimeStatus,"Status"),
          ),
          CustomSwitchListTile(
            icon: Icons.palette_rounded,
            title: AppLocalizations.of(context)!.statusColorsCharts,
            subtitle: AppLocalizations.of(context)!.statusColorsChartsDescription,
            value: appConfigProvider.statusColorsCharts,
            onChanged: (v) => changeSetting(
              fn: appConfigProvider.setStatusColorsCharts, 
              value: v
            ),
          ),
        ],
      ),
    );  
  }
}