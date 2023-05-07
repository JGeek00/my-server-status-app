import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_server_status/functions/memory_conversion.dart';
import 'package:my_server_status/models/general_info.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StorageSectionHome extends StatefulWidget {
  final List<StorageFs> storageInfo;

  const StorageSectionHome({
    Key? key,
    required this.storageInfo
  }) : super(key: key);

  @override
  State<StorageSectionHome> createState() => _StorageSectionHomeState();
}

class _StorageSectionHomeState extends State<StorageSectionHome> {
  bool showAllEntries = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
                    "${convertMemoryToGb(widget.storageInfo.map((i) => i.size).reduce((a, b) => a+b))} GB",
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
          ...widget.storageInfo.sublist(
            0, showAllEntries == true ? widget.storageInfo.length : (widget.storageInfo.length > 3 ? 3 : widget.storageInfo.length)
          ).toList().asMap().entries.map(
            (item) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.value.mount,
                          overflow: TextOverflow.ellipsis,
                        )
                      ),
                      const SizedBox(width: 16),
                      Text("${item.value.use}%")
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                LinearPercentIndicator(
                  lineHeight: 4,
                  percent: item.value.use/100,
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
                      Text(AppLocalizations.of(context)!.storageUsageString(convertMemoryToGb(item.value.size), convertMemoryToGb(item.value.used)))                            ],
                  ),
                ),
                if (item.key < widget.storageInfo.length) const SizedBox(height: 20),
              ],
            )
          ).toList(),
          if (widget.storageInfo.length > 3) Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => showAllEntries = !showAllEntries), 
                child: Text(
                  showAllEntries == false
                    ? AppLocalizations.of(context)!.showMoreEntries(widget.storageInfo.length-3)
                    : AppLocalizations.of(context)!.showLessEntries
                )
              )
            ],
          )
        ],
      ),
    );
  }
}