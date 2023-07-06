import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/docker/ports_modal_bottom_sheet.dart';
import 'package:my_server_status/screens/docker/volumes_modal_bottom_sheet.dart';
import 'package:my_server_status/widgets/custom_list_tile.dart';

import 'package:my_server_status/functions/datetime.dart';
import 'package:my_server_status/models/docker_container.dart';

class ContainerScreen extends StatelessWidget {
  final DockerContainer container;

  const ContainerScreen({
    Key? key,
    required this.container
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.containerDetails),
      ),
      body: ListView(
        children: [
          if (container.id != null && container.id != "") CustomListTile(
            title: AppLocalizations.of(context)!.containerId,
            subtitle: container.id,
          ),
          if (container.name != null && container.name != "") CustomListTile(
            title: AppLocalizations.of(context)!.name,
            subtitle: container.name,
          ),
          if (container.image != null && container.image != "") CustomListTile(
            title: AppLocalizations.of(context)!.image,
            subtitle: container.image,
          ),
          if (container.command != null && container.command != "") CustomListTile(
            title: AppLocalizations.of(context)!.command,
            subtitle: container.command,
          ),
          if (container.created != null) CustomListTile(
            title: AppLocalizations.of(context)!.created,
            subtitle: convertUnixDate(date: container.created!),
          ),
          if (container.started != null) CustomListTile(
            title: AppLocalizations.of(context)!.started,
            subtitle: convertUnixDate(date: container.started!),
          ),
          if (container.finished != null) CustomListTile(
            title: AppLocalizations.of(context)!.finished,
            subtitle: convertUnixDate(date: container.finished!),
          ),
          if (container.state != null) CustomListTile(
            title: AppLocalizations.of(context)!.state,
            subtitleWidget: Row(
              children: [
                Text(
                  container.state! == 'running'
                    ? AppLocalizations.of(context)!.running
                    : container.state! == 'stopped'
                      ? AppLocalizations.of(context)!.stopped
                      : AppLocalizations.of(context)!.paused
                ),
                const SizedBox(width: 4),
                Icon(
                  container.state! == 'running'
                    ? Icons.check_rounded
                    : container.state! == 'stopped'
                      ? Icons.clear_rounded
                      : Icons.error_outline_rounded,
                  color: container.state! == 'running'
                    ? Colors.green
                    : container.state! == 'stopped'
                      ? Colors.red
                      : Colors.orange,
                  size: 18,
                ),
              ],
            ),
          ),
          if (container.restartCount != null) CustomListTile(
            title: AppLocalizations.of(context)!.restartCount,
            subtitle: container.restartCount.toString(),
          ),
          if (container.platform != null) CustomListTile(
            title: AppLocalizations.of(context)!.platform,
            subtitle: container.platform,
          ),
          if (container.ports != null && container.ports!.isNotEmpty) CustomListTile(
            title: AppLocalizations.of(context)!.ports,
            subtitle: AppLocalizations.of(context)!.tapSeeValues,
            onTap: () => showModalBottomSheet(
              context: context, 
              builder: (context) => PortsModalBottomSheet(ports: container.ports!),
              isScrollControlled: true,
              backgroundColor: Colors.transparent
            ),
          ),
          if (container.mounts != null && container.mounts!.isNotEmpty) CustomListTile(
            title: AppLocalizations.of(context)!.volumes,
            subtitle: AppLocalizations.of(context)!.tapSeeValues,
            onTap: () => showModalBottomSheet(
              context: context, 
              builder: (context) => VolumesModalBottomSheet(volumes: container.mounts!),
              isScrollControlled: true,
              backgroundColor: Colors.transparent
            ),
          ),
        ],
      ),
    );
  }
}