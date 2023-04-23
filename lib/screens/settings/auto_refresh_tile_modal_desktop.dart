import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_server_status/widgets/custom_list_tile_dialog.dart';
import 'package:my_server_status/widgets/custom_radio_list_tile.dart';

class AutoRefreshTimeModalDesktop extends StatefulWidget {
  final int time;
  final void Function(int) onChange;
  final String screen;

  const AutoRefreshTimeModalDesktop({
    Key? key,
    required this.time,
    required this.onChange,
    required this.screen
  }) : super(key: key);

  @override
  State<AutoRefreshTimeModalDesktop> createState() => _AutoRefreshTimeModalDesktopState();
}

class _AutoRefreshTimeModalDesktopState extends State<AutoRefreshTimeModalDesktop> {
  String selectedOption = "0";

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedOption = widget.time.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Icon(
                Icons.update_rounded,
                size: 24,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.autoRefreshTime,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ],
      ),
      content: SizedBox(
        width: 200,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.screen == "Home") ...[
                    Text(
                      AppLocalizations.of(context)!.appliedTo,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.home_rounded,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppLocalizations.of(context)!.home,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                  if (widget.screen == "Status") ...[
                    Text(
                      AppLocalizations.of(context)!.appliedTo,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.analytics_rounded,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppLocalizations.of(context)!.status,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_rounded,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Text(AppLocalizations.of(context)!.autoRefreshWarning),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            CustomRadioListTile(
              groupValue: selectedOption.toString(), 
              value: "0", 
              radioBackgroundColor: Theme.of(context).colorScheme.surfaceVariant, 
              title: AppLocalizations.of(context)!.disabled, 
              onChanged: (value) => setState(() => selectedOption = value),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            CustomRadioListTile(
              groupValue: selectedOption.toString(), 
              value: "1", 
              radioBackgroundColor: Theme.of(context).colorScheme.surfaceVariant, 
              title: AppLocalizations.of(context)!.second1, 
              onChanged: (value) => setState(() => selectedOption = value),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            CustomRadioListTile(
              groupValue: selectedOption.toString(), 
              value: "2", 
              radioBackgroundColor: Theme.of(context).colorScheme.surfaceVariant, 
              title: AppLocalizations.of(context)!.second2, 
              onChanged: (value) => setState(() => selectedOption = value),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            CustomRadioListTile(
              groupValue: selectedOption.toString(), 
              value: "3", 
              radioBackgroundColor: Theme.of(context).colorScheme.surfaceVariant, 
              title: AppLocalizations.of(context)!.second3, 
              onChanged: (value) => setState(() => selectedOption = value),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            CustomRadioListTile(
              groupValue: selectedOption.toString(), 
              value: "4", 
              radioBackgroundColor: Theme.of(context).colorScheme.surfaceVariant, 
              title: AppLocalizations.of(context)!.second4, 
              onChanged: (value) => setState(() => selectedOption = value),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            CustomRadioListTile(
              groupValue: selectedOption.toString(), 
              value: "5", 
              radioBackgroundColor: Theme.of(context).colorScheme.surfaceVariant, 
              title: AppLocalizations.of(context)!.second5, 
              onChanged: (value) => setState(() => selectedOption = value),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onChange(int.parse(selectedOption));
              },
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
          ],
        ),
      ],
    );
  }
}