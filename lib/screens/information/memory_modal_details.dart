import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/custom_list_tile.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/models/memory_info.dart';
import 'package:my_server_status/functions/memory_conversion.dart';

class MemoryModalDetails extends StatelessWidget {
  final MemoryInfo data;

  const MemoryModalDetails({
    Key? key,
    required this.data
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    int filledBanks = 0;
    for (var i in data.memLayout) {
      i.type != 'Empty' ? filledBanks++ : null;
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
                    AppLocalizations.of(context)!.memory,
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
                        title: AppLocalizations.of(context)!.installedMemory,
                        subtitle: "${convertMemoryToGb(data.memLayout.map((e) => e.size).reduce((a, b) => a+b))} GB"
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.filledBanks,
                        subtitle: "$filledBanks/${data.memLayout.length}",
                      ),
                      ...data.memLayout.where((m) => m.type != "Empty").map((m) => Column(
                        children: [
                          SectionLabel(
                            label: m.bank
                          ),
                          Wrap(
                            children: [
                              CustomListTile(
                                title: AppLocalizations.of(context)!.size,
                                subtitle: "${convertMemoryToGb(m.size)} GB",
                              ),
                              CustomListTile(
                                title: AppLocalizations.of(context)!.type,
                                subtitle: m.type,
                              ),
                              CustomListTile(
                                title: AppLocalizations.of(context)!.formFactor,
                                subtitle: m.formFactor,
                              ),
                              CustomListTile(
                                title: "ECC",
                                subtitle: m.ecc == true 
                                  ? AppLocalizations.of(context)!.yes
                                  : AppLocalizations.of(context)!.no,
                              ),
                              CustomListTile(
                                title: AppLocalizations.of(context)!.voltage,
                                subtitle: "${m.voltageConfigured} V",
                              ),
                            ],
                          )
                        ],
                      ))
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