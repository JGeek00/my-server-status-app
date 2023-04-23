import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/custom_list_tile.dart';

import 'package:my_server_status/extensions/capitalize.dart';
import 'package:my_server_status/models/os_info.dart';

class OsModalDetails extends StatelessWidget {
  final OsInfo data;

  const OsModalDetails({
    Key? key,
    required this.data
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    String generateValue(String? value) {
      return value != null && value != '' && value != 'Default string' 
        ? value
        : 'N/A';
    }

    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: height*0.8
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.operatingSystem, 
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context), 
                    icon: const Icon(Icons.close_rounded)
                  )
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    children: [
                      CustomListTile(
                        title: AppLocalizations.of(context)!.operatingSystem,
                        subtitle: data.distro,
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.platform,
                        subtitle: data.platform.capitalize(),
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.version,
                        subtitle: data.release,
                      ),
                      CustomListTile(
                        title: "Build",
                        subtitle: generateValue(data.build),
                      ),
                      CustomListTile(
                        title: "Kernel",
                        subtitle: data.kernel,
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.architecture,
                        subtitle: data.arch,
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.hostName,
                        subtitle: data.hostname,
                      ),
                      CustomListTile(
                        title: "UEFI",
                        subtitle: data.uefi == true 
                          ? AppLocalizations.of(context)!.yes
                          : AppLocalizations.of(context)!.no,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}