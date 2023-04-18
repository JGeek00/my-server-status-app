import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/custom_list_tile.dart';
import 'package:my_server_status/widgets/tab_content.dart';

import 'package:my_server_status/extensions/capitalize.dart';
import 'package:my_server_status/providers/servers_provider.dart';

class OsTab extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const OsTab({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);

    final width = MediaQuery.of(context).size.width;

    String generateValue(String? value) {
      return value != null && value != '' && value != 'Default string' 
        ? value
        : 'N/A';
    }

    Widget listTile(Widget widget) {
      return SizedBox(
         width: width > 700
          ? width > 900 
            ? width > 1300 
              ? (width-91)/3
              : (width-91)/2 
            : width/2
          : width,
        child: widget,
      );
    }

    return CustomTabContent(
      loadingGenerator: () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 30),
          Text(
            AppLocalizations.of(context)!.loadingHardwareInfo,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          )
        ],
      ), 
      contentGenerator: () {
        final os = serversProvider.systemSpecsInfo.data!.osInfo;
        return [
          const SizedBox(height: 16),
          Wrap(
            children: [
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.operatingSystem,
                  subtitle: os.distro,
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.platform,
                  subtitle: os.platform.capitalize(),
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.version,
                  subtitle: os.release,
                ),
              ),
              listTile(
                CustomListTile(
                  title: "Build",
                  subtitle: generateValue(os.build),
                ),
              ),
              listTile(
                CustomListTile(
                  title: "Kernel",
                  subtitle: os.kernel,
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.architecture,
                  subtitle: os.arch,
                ),
              ),
              listTile(
                CustomListTile(
                  title: AppLocalizations.of(context)!.hostName,
                  subtitle: os.hostname,
                ),
              ),
              listTile(
                CustomListTile(
                  title: "UEFI",
                  subtitle: os.uefi == true 
                    ? AppLocalizations.of(context)!.yes
                    : AppLocalizations.of(context)!.no,
                ),
              )
            ],
          ),
          const SizedBox(height: 16)
        ];
      }, 
      errorGenerator: () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            color: Colors.red,
            size: 50,
          ),
          const SizedBox(height: 30),
          Text(
            AppLocalizations.of(context)!.hardwareInfoNotLoaded,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ), 
      loadStatus: serversProvider.systemSpecsInfo.loadStatus,
      onRefresh: onRefresh
    );
  }
}