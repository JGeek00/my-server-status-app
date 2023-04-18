// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'package:my_server_status/widgets/api_announcement.dart';
import 'package:my_server_status/widgets/navigation_rail.dart';
import 'package:my_server_status/widgets/bottom_nav_bar.dart';
import 'package:my_server_status/widgets/menu_bar.dart';

import 'package:my_server_status/providers/servers_provider.dart';
import 'package:my_server_status/config/app_screens.dart';
import 'package:my_server_status/models/app_screen.dart';
import 'package:my_server_status/providers/app_config_provider.dart';


class Base extends StatefulWidget {
  final AppConfigProvider appConfigProvider;

  const Base({
    Key? key,
    required this.appConfigProvider,
  }) : super(key: key);

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> with WidgetsBindingObserver {
  int selectedScreen = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.appConfigProvider.apiAnnouncementReaden == false) {
        showDialog(
          context: context, 
          barrierDismissible: false,
          builder: (context) => ApiAnnouncementModal(
            onConfirm: () => widget.appConfigProvider.setApiAnnouncementReaden(true)
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    final width = MediaQuery.of(context).size.width;

    List<AppScreen> screens = serversProvider.selectedServer != null
      ? screensServerConnected
      : screensSelectServer;

    return CustomMenuBar(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Theme.of(context).brightness == Brightness.light
            ? Brightness.light
            : Brightness.dark,
          statusBarIconBrightness: Theme.of(context).brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
          systemNavigationBarIconBrightness: Theme.of(context).brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        ),
        child: Scaffold(
          body: Row(
            children: [
              if (width > 900) const SideNavigationRail(),
              Expanded(
                child: PageTransitionSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (
                    (child, primaryAnimation, secondaryAnimation) => FadeThroughTransition(
                      animation: primaryAnimation, 
                      secondaryAnimation: secondaryAnimation,
                      child: child,
                    )
                  ),
                  child: screens[appConfigProvider.selectedScreen].body,
                ),
              ),
            ],
          ),
          
          bottomNavigationBar: width <= 900 
            ? const BottomNavBar()
            : null,
        )
      ),
    );
  }
}