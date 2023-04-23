import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/option_box.dart';

class AutoRefreshTimeModal extends StatefulWidget {
  final int time;
  final void Function(int) onChange;
  final double screenHeight;
  final String screen;

  const AutoRefreshTimeModal({
    Key? key,
    required this.time,
    required this.onChange,
    required this.screenHeight,
    required this.screen,
  }) : super(key: key);

  @override
  State<AutoRefreshTimeModal> createState() => _AutoRefreshTimeModalState();
}

class _AutoRefreshTimeModalState extends State<AutoRefreshTimeModal> {
  int selectedOption = 0;

  void _updateRadioValue(value) {
    setState(() {
      selectedOption = value;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedOption = widget.time;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).dialogBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28)
        ),
      ),
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.update_rounded,
                    size: 24,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              width: double.maxFinite,
              child: Text(
                AppLocalizations.of(context)!.autoRefreshTime,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
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
            SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Wrap(
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.5,
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 10,
                              right: 5,
                              bottom: 5
                            ),
                            child: OptionBox(
                              optionsValue: selectedOption,
                              itemValue: 0,
                              onTap: _updateRadioValue,
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 250),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: selectedOption == 0
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurfaceVariant
                                  ),
                                  child: Text(AppLocalizations.of(context)!.disabled),
                                ),
                              ),
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.5,
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 10,
                              left: 5,
                              bottom: 5
                            ),
                            child: OptionBox(
                              optionsValue: selectedOption,
                              itemValue: 1,
                              onTap: _updateRadioValue,
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 250),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: selectedOption == 1
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurfaceVariant
                                  ),
                                  child: Text(AppLocalizations.of(context)!.second1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.5,
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 5,
                              right: 5,
                              bottom: 5
                            ),
                            child: OptionBox(
                              optionsValue: selectedOption,
                              itemValue: 2,
                              onTap: _updateRadioValue,
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 250),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: selectedOption == 2
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurfaceVariant
                                  ),
                                  child: Text(AppLocalizations.of(context)!.second2),
                                ),
                              ),
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.5,
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 5,
                              left: 5,
                              bottom: 5
                            ),
                            child: OptionBox(
                              optionsValue: selectedOption,
                              itemValue: 3,
                              onTap: _updateRadioValue,
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 250),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: selectedOption == 3
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurfaceVariant
                                  ),
                                  child: Text(AppLocalizations.of(context)!.second3),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.5,
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 5,
                              right: 5,
                              bottom: 10
                            ),
                            child: OptionBox(
                              optionsValue: selectedOption,
                              itemValue: 4,
                              onTap: _updateRadioValue,
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 250),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: selectedOption == 4
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurfaceVariant
                                  ),
                                  child: Text(AppLocalizations.of(context)!.second4),
                                ),
                              ),
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.5,
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 5,
                              left: 5,
                              bottom: 10
                            ),
                            child: OptionBox(
                              optionsValue: selectedOption,
                              itemValue: 5,
                              onTap: _updateRadioValue,
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 250),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: selectedOption == 5
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurfaceVariant
                                  ),
                                  child: Text(AppLocalizations.of(context)!.second5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
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
                          widget.onChange(selectedOption);
                        },
                        child: Text(AppLocalizations.of(context)!.confirm),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}