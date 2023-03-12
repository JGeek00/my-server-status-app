// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'package:my_server_status/widgets/bottom_nav_bar.dart';

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
  Widget build(BuildContext context) {
    final serversProvider = Provider.of<ServersProvider>(context);
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    List<AppScreen> screens = serversProvider.selectedServer != null
      ? screensServerConnected
      : screensSelectServer;

    return AnnotatedRegion<SystemUiOverlayStyle>(
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
        body: PageTransitionSwitcher(
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
        bottomNavigationBar: const BottomNavBar(),
      )
    );
  }
}