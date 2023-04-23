import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/custom_list_tile.dart';
import 'package:my_server_status/widgets/section_label.dart';

import 'package:my_server_status/models/cpu_info.dart';
import 'package:my_server_status/functions/memory_conversion.dart';

class CpuModalDetails extends StatelessWidget {
  final CpuInfo data;

  const CpuModalDetails({
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
                  const Text(
                    "CPU",
                    style: TextStyle(
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
                        label: AppLocalizations.of(context)!.cores,
                        padding: const EdgeInsets.only(
                          top: 8, left: 16, bottom: 16
                        ),
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.physicalCores,
                        subtitle: data.cpu.physicalCores.toString(),
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.threads,
                        subtitle: data.cpu.cores.toString(),
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.performanceCores,
                        subtitle: data.cpu.performanceCores.toString(),
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.efficiencyCores,
                        subtitle: data.cpu.efficiencyCores.toString(),
                      ),
                      SectionLabel(label: AppLocalizations.of(context)!.speed),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.baseFrequency,
                        subtitle: "${data.cpu.speed} GHz",
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.minFrequency,
                        subtitle: "${data.cpu.speedMin} GHz",
                      ),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.maxFrequency,
                        subtitle: "${data.cpu.speedMax} GHz",
                      ),
                      SectionLabel(label: AppLocalizations.of(context)!.cache),
                      CustomListTile(
                        title: "L1",
                        subtitle: data.cpu.cache.l1d != null || data.cpu.cache.l1i != null
                          ? "${convertMemoryToKb((data.cpu.cache.l1d != null ? data.cpu.cache.l1d!.toDouble() : 0) + (data.cpu.cache.l1i != null ? data.cpu.cache.l1i!.toDouble() : 0))} KB"
                          : "N/A",
                      ),
                      CustomListTile(
                        title: "L2",
                        subtitle: data.cpu.cache.l2 != null ? "${convertMemoryToMb(data.cpu.cache.l2!.toDouble())} MB" : 'N/A',
                      ),
                      CustomListTile(
                        title: "L3",
                        subtitle: data.cpu.cache.l3 != null ? "${convertMemoryToMb(data.cpu.cache.l3!.toDouble())} MB" : 'N/A',
                      ),
                      SectionLabel(label: AppLocalizations.of(context)!.other),
                      CustomListTile(
                        title: AppLocalizations.of(context)!.socket,
                        subtitle: generateValue(data.cpu.socket),
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