import 'package:flutter/material.dart';

import 'package:my_server_status/screens/docker/docker_screen.dart';
import 'package:my_server_status/screens/information/information.dart';
import 'package:my_server_status/screens/settings/settings.dart';
import 'package:my_server_status/screens/connect/connect.dart';
import 'package:my_server_status/screens/status/status.dart';
import 'package:my_server_status/screens/home/home.dart';

import 'package:my_server_status/constants/docker_icons.dart';
import 'package:my_server_status/models/app_screen.dart';

List<AppScreen> screensSelectServer = [
  const AppScreen(
    name: "connect", 
    icon: Icons.link_rounded, 
    body: ConnectScreen(),
  ),
  const AppScreen(
    name: "settings", 
    icon: Icons.settings_rounded,
    body: SettingsScreen()
  )
];

List<AppScreen> screensServerConnected = [
  const AppScreen(
    name: "home", 
    icon: Icons.home_rounded, 
    body: HomeScreen(),
  ),
  const AppScreen(
    name: "information", 
    icon: Icons.list_alt_rounded, 
    body: InformationScreen(),
  ),
  const AppScreen(
    name: "status", 
    icon: Icons.analytics_rounded, 
    body: StatusScreen(),
  ),
  const AppScreen(
    name: "docker", 
    icon: DockerIcons.docker, 
    body: DockerScreen(),
  ),
  const AppScreen(
    name: "settings", 
    icon: Icons.settings_rounded,
    body: SettingsScreen()
  )
];