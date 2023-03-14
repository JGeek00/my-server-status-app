// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/settings/auto_refresh_time_modal.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/functions/snackbar.dart';
import 'package:my_server_status/widgets/custom_list_tile.dart';

class GeneralSettings extends StatelessWidget {
  const GeneralSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    void openAutoRefreshTimeModal() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => AutoRefreshTimeModal(
          time: appConfigProvider.autoRefreshTime, 
          screenHeight: MediaQuery.of(context).size.height,
          onChange: (value) async {
            final result = await appConfigProvider.setAutoRefreshTime(value);
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

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.generalSettings) ,
      ),
      body: ListView(
        children: [
          SectionLabel(label: AppLocalizations.of(context)!.home),
          CustomListTile(
            icon: Icons.refresh_rounded,
            title: AppLocalizations.of(context)!.autoRefreshTime,
            subtitle: appConfigProvider.autoRefreshTime == 0 
              ? AppLocalizations.of(context)!.disabled
              : AppLocalizations.of(context)!.autoRefreshValue(appConfigProvider.autoRefreshTime),
            onTap: openAutoRefreshTimeModal,
          )
        ],
      ),
    );  
  }
}