import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/models/docker_container.dart';

class VolumesModalBottomSheet extends StatelessWidget {
  final List<Mount> volumes;

  const VolumesModalBottomSheet({
    Key? key,
    required this.volumes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28)
            )
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    height: 5,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  AppLocalizations.of(context)!.volumes,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24
                  ),
                ),
              ),
              ...volumes.map((vol) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    if (vol.type != null && vol.type != "") Row(
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.type}:",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text("${vol.type}")
                      ],
                    ),
                    if (vol.source != null && vol.source != "") ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.source}:",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text("${vol.source}")
                        ],
                      ),
                    ],
                    if (vol.destination != null && vol.destination != "") ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.destination}:",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text("${vol.destination}")
                        ],
                      ),
                    ],
                    if (vol.mode != null && vol.mode != "") ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.mode}:",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(vol.mode!.toUpperCase())
                        ],
                      ),
                    ],
                    if (vol.propagation != null && vol.propagation != "") ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.propagation}:",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(vol.propagation!)
                        ],
                      ),
                    ]
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}