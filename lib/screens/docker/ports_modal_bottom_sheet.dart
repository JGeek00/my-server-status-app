import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/models/docker_container.dart';
import 'package:my_server_status/widgets/section_label.dart';

class PortsModalBottomSheet extends StatelessWidget {
  final List<Port> ports;

  const PortsModalBottomSheet({
    Key? key,
    required this.ports,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Port> exposed = ports.where((p) => p.publicPort != null).toList();
    final List<Port> rest = ports.where((p) => p.publicPort == null).toList();

    Widget portCard(Port port) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: (MediaQuery.of(context).size.width-32)/2
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (port.ip != null) Row(
                  children: [
                    const Text(
                      "IP:",
                      style: TextStyle(
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text("${port.ip}")
                  ],
                ),
                if (port.type != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.type}:",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text("${port.type}")
                    ],
                  ),
                ],
                if (port.publicPort != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.publicPort}:",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text("${port.publicPort}")
                    ],
                  ),
                ],
                if (port.privatePort != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.privatePort}:",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text("${port.privatePort}")
                    ],
                  ),
                ]
              ],
            ),
          ),
        ),
      );
    }

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
                  AppLocalizations.of(context)!.ports,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24
                  ),
                ),
              ),
              if (exposed.isNotEmpty) ...[
                SectionLabel(label: AppLocalizations.of(context)!.exposedPorts),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Wrap(
                    runSpacing: 8,
                    spacing: 8,
                    children: exposed.map((port) => portCard(port)).toList(),
                  ),
                ),
              ],
              if (rest.isNotEmpty) ...[
                SectionLabel(label: AppLocalizations.of(context)!.notExposedPorts),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Wrap(
                    runSpacing: 8,
                    spacing: 8,
                    children: rest.map((port) => portCard(port)).toList(),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}