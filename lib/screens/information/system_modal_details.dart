import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/custom_list_tile.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/functions/memory_conversion.dart';
import 'package:my_server_status/models/system_info.dart';

class SystemModalDetails extends StatelessWidget {
  final SystemInfo data;

  const SystemModalDetails({
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
                    AppLocalizations.of(context)!.system, 
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
                      SectionLabel(
                        label: AppLocalizations.of(context)!.system,
                        padding: const EdgeInsets.only(
                          top: 8, left: 16, bottom: 16
                        ),
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.manufacturer,
                        subtitle: generateValue(data.system.manufacturer),
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.model,
                        subtitle: generateValue(data.system.model),
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.version,
                        subtitle: generateValue(data.system.version),
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.serial,
                        subtitle: generateValue(data.system.serial),
                      ),
                      const SectionLabel(label: "BIOS"),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.vendor,
                        subtitle: generateValue(data.bios.vendor),
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.version,
                        subtitle: generateValue(data.bios.version),
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.releaseDate,
                        subtitle: generateValue(data.bios.releaseDate),
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.revision,
                        subtitle: generateValue(data.bios.revision),
                      ),
                      SectionLabel(label: AppLocalizations.of(context)!.baseboard),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.manufacturer,
                        subtitle: generateValue(data.baseboard.manufacturer),
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.model,
                        subtitle: generateValue(data.baseboard.model),
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.version,
                        subtitle: generateValue(data.baseboard.version),
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.serial,
                        subtitle: generateValue(data.baseboard.serial),
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.maxAllowedMemory,
                        subtitle: data.baseboard.memMax != null
                          ? "${convertMemoryToGb(data.baseboard.memMax!)} GB"
                          : "N/A",
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.memorySlots,
                        subtitle: data.baseboard.memSlots.toString(),
                      ),
                      SectionLabel(label: AppLocalizations.of(context)!.chassis),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.manufacturer,
                        subtitle: generateValue(data.chassis.manufacturer),
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.model,
                        subtitle: generateValue(data.chassis.model),
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.version,
                        subtitle: generateValue(data.chassis.version),
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