import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_server_status/constants/docker_icons.dart';

import 'package:my_server_status/screens/docker/containers_tab.dart';
import 'package:my_server_status/screens/docker/images_tab.dart';
import 'package:my_server_status/screens/docker/information_tab.dart';

class DockerScreen extends StatefulWidget {
  const DockerScreen({Key? key}) : super(key: key);

  @override
  State<DockerScreen> createState() => _DockerScreenState();
}

class _DockerScreenState extends State<DockerScreen> with TickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabsList() {
      return [
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                DockerIcons.docker,
                size: 20,
              ),
              const SizedBox(width: 14),
              Text(AppLocalizations.of(context)!.general)
            ],
          )
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(DockerIcons.cd),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context)!.images)
            ],
          )
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(DockerIcons.drive),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context)!.containers)
            ],
          )
        ),
      ];
    }

    Widget tabBarView() {
      return TabBarView(
        controller: tabController,
        children: const [
          InformationTab(),
          ImagesTab(),
          ContainersTab()
        ]
      );
    }

    return DefaultTabController(
      length: 3,
      child: !(Platform.isAndroid || Platform.isIOS)
        ? Scaffold(
            appBar: AppBar(
              title: const Text("Docker"),
              centerTitle: false,
              bottom: TabBar(
                controller: tabController,
                unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                isScrollable: true,
                tabs: tabsList()
              )
            ),
            body: tabBarView()
        ) : NestedScrollView(
          headerSliverBuilder: ((context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  title: const Text("Docker"),
                  pinned: true,
                  floating: true,
                  centerTitle: false,
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    controller: tabController,
                    unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    isScrollable: true,
                    tabs: tabsList()
                  )
                ),
              )
            ];
          }), 
          body: tabBarView()
        )
    );
  }
}