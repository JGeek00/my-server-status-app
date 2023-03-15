import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/constants/urls.dart';
import 'package:my_server_status/functions/open_url.dart';

class ApiAnnouncementModal extends StatelessWidget {
  final void Function() onConfirm;

  const ApiAnnouncementModal({
    Key? key,
    required this.onConfirm
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Column(
        children: [
          Icon(
            Icons.info_rounded,
            size: 24,
            color: Theme.of(context).listTileTheme.iconColor,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.importantAnnouncement, 
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).colorScheme.onSurface
            ),
          )
        ],
      ),
      content: Column(
        children: [
          Text(AppLocalizations.of(context)!.importantAnnouncementDescription),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: SvgPicture.asset(
              'assets/resources/github.svg',
              color: Theme.of(context).colorScheme.primary,
              width: 20,
              height: 20,
            ),
            label: Text(AppLocalizations.of(context)!.installationInstructions),
            onPressed: () => openUrl(Urls.apiInstallationInstructions),
          )
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              }, 
              child: Text(AppLocalizations.of(context)!.confirm)
            ),
          ],
        )
      ],
    );
  }
}