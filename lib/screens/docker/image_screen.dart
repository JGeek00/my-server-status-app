import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_server_status/constants/os_icons.dart';

import 'package:my_server_status/functions/datetime.dart';
import 'package:my_server_status/functions/memory_conversion.dart';
import 'package:my_server_status/models/docker_images.dart';
import 'package:my_server_status/screens/docker/values_modal_bottom_sheet.dart';
import 'package:my_server_status/widgets/custom_list_tile.dart';
import 'package:my_server_status/widgets/section_label.dart';

class ImageScreen extends StatelessWidget {
  final DockerImage image;

  const ImageScreen({
    Key? key,
    required this.image
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget specTile({
      required double width,
      required IconData icon,
      required String label,
      required String value
    }) {
      return FractionallySizedBox(
        widthFactor: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
               fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16
              )
            ),
          ],
        ),
      );
    }

    IconData osIcon(String os) {
      switch (os) {
        case 'macos':
          return OSIcons.macos;

        case 'linux':
          return OSIcons.linux;

        case 'freebsd':
          return OSIcons.freebsd;

        case 'windows':
          return OSIcons.windows;

        default:
          return Icons.computer_rounded;
      }
    }

    List<Widget> content() {
      return [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                runSpacing: 32,
                children: [
                  specTile(
                    width: width > 700 ? 0.25 : 0.5,
                    icon: Icons.storage_rounded, 
                    label: AppLocalizations.of(context)!.size, 
                    value: "${convertMemoryToMb(image.size!.toDouble())} GB"
                  ),
                  specTile(
                    width: width > 700 ? 0.25 : 0.5,
                    icon: Icons.calendar_month_rounded, 
                    label: AppLocalizations.of(context)!.creationDate, 
                    value: convertUnixDate(
                      date: image.created!,
                      lineJump: true
                    )
                  ),
                  specTile(
                    width: width > 700 ? 0.25 : 0.5,
                    icon: osIcon(image.os!), 
                    label: AppLocalizations.of(context)!.operatingSystem, 
                    value: image.os!
                  ),
                  specTile(
                    width: width > 700 ? 0.25 : 0.5,
                    icon: Icons.memory_rounded, 
                    label: AppLocalizations.of(context)!.architecture, 
                    value: image.architecture!
                  ),
                ],
              ),
            ),
          ),
        ),
        if (image.id != null && image.id != "") CustomListTile(
          title: AppLocalizations.of(context)!.imageId,
          subtitle: image.id!,
        ),
        if (image.repoTags != null && image.repoTags!.isNotEmpty) Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.tags,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  itemCount: image.repoTags!.length,
                  itemBuilder: (context, j) => Chip(label: Text(image.repoTags![j])),
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ],
          ),
        ),
        if (image.author != null && image.author != "") CustomListTile(
          title: AppLocalizations.of(context)!.author,
          subtitle: image.author!,
        ),
        if (image.dockerVersion != null && image.dockerVersion != "") CustomListTile(
          title: AppLocalizations.of(context)!.dockerVersion,
          subtitle: image.dockerVersion!,
        ),
        if (image.comment != null && image.comment != "") CustomListTile(
          title: AppLocalizations.of(context)!.comment,
          subtitle: image.comment!,
        ),
        if (image.config != null) ...[
          SectionLabel(label: AppLocalizations.of(context)!.configuration),
          if (image.config!.hostname != null && image.config!.hostname != "") CustomListTile(
            title: AppLocalizations.of(context)!.hostName,
            subtitle: image.config!.hostname,
          ),
          if (image.config!.domainname != null && image.config!.domainname != "") CustomListTile(
            title: AppLocalizations.of(context)!.domainName,
            subtitle: image.config!.domainname,
          ),
          if (image.config!.user != null && image.config!.user != "") CustomListTile(
            title: AppLocalizations.of(context)!.user,
            subtitle: image.config!.user,
          ),
          if (image.config!.env != null && image.config!.env!.isNotEmpty) CustomListTile(
            title: AppLocalizations.of(context)!.envVariables,
            subtitle: AppLocalizations.of(context)!.tapSeeValues,
            onTap: () => showModalBottomSheet(
              context: context, 
              builder: (context) => ValuesModalBottomSheet(
                values: { for (var v in image.config!.env!) v.split('=')[0] : v.split('=')[1] },
                label: AppLocalizations.of(context)!.envVariables,
              ),
              isScrollControlled: true,
              backgroundColor: Colors.transparent
            ),
          ),
          if (image.config!.cmd != null && image.config!.cmd!.isNotEmpty) CustomListTile(
            title: "CMD",
            subtitle: image.config!.cmd!.join("\n"),
          ),
          if (image.config!.image != null && image.config!.image != "") CustomListTile(
            title: AppLocalizations.of(context)!.image,
            subtitle: image.config!.image,
          ),
          if (image.config!.workingDir != null && image.config!.workingDir != "") CustomListTile(
            title: AppLocalizations.of(context)!.image,
            subtitle: image.config!.workingDir,
          ),
          if (image.config!.entrypoint != null && image.config!.entrypoint!.isNotEmpty) CustomListTile(
            title: AppLocalizations.of(context)!.entrypoint,
            subtitle: image.config!.entrypoint!.join('\n'),
          ),
          if (image.config!.exposedPorts != null && image.config!.exposedPorts!.isNotEmpty) CustomListTile(
            title: AppLocalizations.of(context)!.exposedPorts,
            subtitle: image.config!.exposedPorts!.keys.join('\n'),
          ),
          if (image.config!.volumes != null && image.config!.volumes!.isNotEmpty) CustomListTile(
            title: AppLocalizations.of(context)!.volumes,
            subtitle: image.config!.volumes!.keys.join('\n'),
          ),
          if (image.config!.labels != null) CustomListTile(
            title: AppLocalizations.of(context)!.labels,
            subtitle: AppLocalizations.of(context)!.tapSeeValues,
            onTap: () => showModalBottomSheet(
              context: context, 
              builder: (context) => ValuesModalBottomSheet(
                values: Map<String, String>.from(image.config!.labels!),
                label: AppLocalizations.of(context)!.labels,
              ),
              isScrollControlled: true,
              backgroundColor: Colors.transparent
            ),
          )
        ]
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.imageDetails),
      ),
      body: ListView(
        children: content(),
      ),
    );

    // return Scaffold(
    //   body: NestedScrollView(
    //     headerSliverBuilder: (context, innerBoxIsScrolled) => [
    //       SliverOverlapAbsorber(
    //         handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
    //         sliver: SliverAppBar(
    //           pinned: true,
    //           floating: true,
    //           centerTitle: false,
    //           forceElevated: innerBoxIsScrolled,
    //           title: Text(AppLocalizations.of(context)!.imageDetails),
    //         ),
    //       )
    //     ], 
    //     body: SafeArea(
    //       top: false,
    //       bottom: false,
    //       child: Builder(
    //         builder: (context) => CustomScrollView(
    //           slivers: [
    //             SliverOverlapInjector(
    //               handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
    //             ),
    //             SliverList.list(
    //               children: 
    //             )
    //           ],
    //         )
    //       ),
    //     )
    //   ),
    // );
  }
}