import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/custom_list_tile.dart';

class PowerOptionsMenu extends StatelessWidget {
  final bool isDialog;
  final void Function() onReboot;
  final void Function() onPowerOff;

  const PowerOptionsMenu({
    Key? key,
    required this.isDialog,
    required this.onReboot,
    required this.onPowerOff
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> header() {
      return [
        Icon(
          Icons.settings_power_rounded,
          size: 24,
          color: Theme.of(context).listTileTheme.iconColor
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Text(
            AppLocalizations.of(context)!.powerOptions,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ];
    }

    List<Widget> listOptions() {
      return [
        CustomListTile(
          title: AppLocalizations.of(context)!.reboot,
          subtitle: AppLocalizations.of(context)!.rebootDescription,
          icon: Icons.restart_alt_rounded,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          onTap: () {
            Navigator.pop(context);
            onReboot();
          },
        ),
        CustomListTile(
          title: AppLocalizations.of(context)!.powerOff,
          subtitle: AppLocalizations.of(context)!.powerOffDescription,
          icon: Icons.power_settings_new_rounded,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          onTap: () {
            Navigator.pop(context);
            onPowerOff();
          },
        ),
      ];
    }
    
    if (isDialog == true) {
      return AlertDialog(
        scrollable: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
        title: Column(
          children: header(),
        ),
        content: Column(
          children: listOptions(),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context), 
                child: Text(AppLocalizations.of(context)!.cancel)
              )
            ],
          )
        ],
      );
    }
    else {
      return SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28)
            )
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              ...header(),
              Wrap(
                children: listOptions(),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), 
                      child: Text(AppLocalizations.of(context)!.cancel)
                    )
                  ],
                ),
              )
            ],
          )
        ),
      );
    }
  }
}