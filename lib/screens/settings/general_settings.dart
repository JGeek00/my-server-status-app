// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/providers/app_config_provider.dart';
import 'package:my_server_status/widgets/custom_list_tile.dart';


class GeneralSettings extends StatelessWidget {
  const GeneralSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);


    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.generalSettings) ,
      ),
      body: ListView(
        children: [

        ],
      ),
    );  
  }
}