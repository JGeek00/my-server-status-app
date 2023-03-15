import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_server_status/functions/memory_conversion.dart';
import 'package:my_server_status/models/general_info.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StorageSectionHome extends StatelessWidget {
  final List<StorageFs> storageInfo;

  const StorageSectionHome({
    Key? key,
    required this.storageInfo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentIndexStorage = 0;   // To know current index on storage map

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.storage,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${convertMemoryToGb(storageInfo.map((i) => i.size).reduce((a, b) => a+b))} GB",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...storageInfo.map(
            (item) {
              currentIndexStorage++;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.mount),
                        Text("${item.use}%")
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearPercentIndicator(
                    lineHeight: 4,
                    percent: item.use/100,
                    barRadius: const Radius.circular(5),
                    progressColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(AppLocalizations.of(context)!.storageUsageString(convertMemoryToGb(item.size), convertMemoryToGb(item.used)))                            ],
                    ),
                  ),
                  if (currentIndexStorage < storageInfo.length) const SizedBox(height: 20),
                ],
              );
            }
          ).toList()
        ],
      ),
    );
  }
}