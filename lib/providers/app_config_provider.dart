import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite/sqlite_api.dart';

import 'package:my_server_status/services/database/queries.dart';
import 'package:my_server_status/models/app_log.dart';
import 'package:my_server_status/functions/conversions.dart';

class AppConfigProvider with ChangeNotifier {
  Database? _dbInstance;

  PackageInfo? _appInfo;

  AndroidDeviceInfo? _androidDeviceInfo;
  IosDeviceInfo? _iosDeviceInfo;

  int _selectedScreen = 0;

  bool _showingSnackbar = false;

  int _selectedTheme = 0;
  bool _useDynamicColor = true;
  int _staticColor = 0;

  int _overrideSslCheck = 0;

  int _autoRefreshTimeHome = 0;
  int _autoRefreshTimeStatus = 0;

  bool _apiAnnouncementReaden = false;

  bool _timeoutRequests = true;

  bool _statusColorsCharts = false;

  bool _hideVolumesNoMountPoint = true;

  bool _combinedCpuChart = true;

  bool _hideServerAddress = false;

  final List<AppLog> _logs = [];

  PackageInfo? get getAppInfo {
    return _appInfo;
  }

  AndroidDeviceInfo? get androidDeviceInfo {
    return _androidDeviceInfo;
  }

  IosDeviceInfo? get iosDeviceInfo {
    return _iosDeviceInfo;
  }

  ThemeMode get selectedTheme {
    switch (_selectedTheme) {
      case 0:
        return SchedulerBinding.instance.window.platformBrightness == Brightness.light 
          ? ThemeMode.light 
          : ThemeMode.dark;

      case 1:
        return ThemeMode.light;

      case 2:
        return ThemeMode.dark;

      default:
        return ThemeMode.light;
    }
  }

  int get selectedThemeNumber {
    return _selectedTheme;
  }

  bool get overrideSslCheck {
    return _overrideSslCheck == 1 ? true : false;
  }

  int get selectedScreen {
    return _selectedScreen;
  }

  bool get showingSnackbar {
    return _showingSnackbar;
  }

  bool get useDynamicColor {
    return _useDynamicColor;
  }

  int get staticColor {
    return _staticColor;
  }

  List<AppLog> get logs {
    return _logs;
  }

  int get autoRefreshTimeHome {
    return _autoRefreshTimeHome;
  }

  int get autoRefreshTimeStatus {
    return _autoRefreshTimeStatus;
  }

  bool get apiAnnouncementReaden {
    return _apiAnnouncementReaden;
  }

  bool get timeoutRequests {
    return _timeoutRequests;
  }

  bool get statusColorsCharts {
    return _statusColorsCharts;
  }

  bool get hideVolumesNoMountPoint {
    return _hideVolumesNoMountPoint;
  }

  bool get combinedCpuChart {
    return _combinedCpuChart;
  }

  bool get hideServerAddress {
    return _hideServerAddress;
  }

  void setDbInstance(Database db) {
    _dbInstance = db;
  }

  void setAppInfo(PackageInfo appInfo) {
    _appInfo = appInfo;
  }
  
  void setAndroidInfo(AndroidDeviceInfo deviceInfo) {
    _androidDeviceInfo = deviceInfo;
  }

  void setIosInfo(IosDeviceInfo deviceInfo) {
    _iosDeviceInfo = deviceInfo;
  }

  void setSelectedScreen(int screen) {
    _selectedScreen = screen;
    notifyListeners();
  }

  void setShowingSnackbar(bool status) async {
    _showingSnackbar = status;
    notifyListeners();
  }

  void addLog(AppLog log) {
    _logs.add(log);
    notifyListeners();
  }

  Future<bool> setOverrideSslCheck(bool status) async {
    final updated = await updateConfigQuery(_dbInstance!, 'overrideSslCheck', status == true ? 1 : 0);
    if (updated == true) {
      _overrideSslCheck = status == true ? 1 : 0;
      notifyListeners();
      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> setSelectedTheme(int value) async {
    final updated = await updateConfigQuery(_dbInstance!, 'theme', value);
    if (updated == true) {
      _selectedTheme = value;
      notifyListeners();
      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> setUseDynamicColor(bool value) async {
    final updated = await updateConfigQuery(_dbInstance!, 'useDynamicColor', value == true ? 1 : 0);
    if (updated == true) {
      _useDynamicColor = value;
      notifyListeners();
      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> setStaticColor(int value) async {
    final updated = await updateConfigQuery(_dbInstance!, 'staticColor', value);
    if (updated == true) {
      _staticColor = value;
      notifyListeners();
      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> setAutoRefreshTimeHome(int value) async {
    final updated = await updateConfigQuery(_dbInstance!, 'autoRefreshTimeHome', value);
    if (updated == true) {
      _autoRefreshTimeHome = value;
      notifyListeners();
      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> setAutoRefreshTimeStatus(int value) async {
    final updated = await updateConfigQuery(_dbInstance!, 'autoRefreshTimeStatus', value);
    if (updated == true) {
      _autoRefreshTimeStatus = value;
      notifyListeners();
      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> setApiAnnouncementReaden(bool value) async {
    final updated = await updateConfigQuery(_dbInstance!, 'apiAnnouncementReaden', value == true ? 1 : 0);
    if (updated == true) {
      _apiAnnouncementReaden = value;
      notifyListeners();
      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> setTimeoutRequests(bool value) async {
    final updated = await updateConfigQuery(_dbInstance!, 'timeoutRequests', value == true ? 1 : 0);
    if (updated == true) {
      _timeoutRequests = value;
      notifyListeners();
      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> setStatusColorsCharts(bool value) async {
    final updated = await updateConfigQuery(_dbInstance!, 'statusColorsCharts', value == true ? 1 : 0);
    if (updated == true) {
      _statusColorsCharts = value;
      notifyListeners();
      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> setHideVolumesNoMountPoint(bool value) async {
    final updated = await updateConfigQuery(_dbInstance!, 'hideVolumesNoMountPoint', value == true ? 1 : 0);
    if (updated == true) {
      _hideVolumesNoMountPoint = value;
      notifyListeners();
      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> setHideServerAddress(bool value) async {
    final updated = await updateConfigQuery(_dbInstance!, 'hideServerAddress', value == true ? 1 : 0);
    if (updated == true) {
      _hideServerAddress = value;
      notifyListeners();
      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> setCombinedCpuChart(bool value) async {
    final updated = await updateConfigQuery(_dbInstance!, 'combinedCpuChart', value == true ? 1 : 0);
    if (updated == true) {
      _combinedCpuChart = value;
      notifyListeners();
      return true;
    }
    else {
      return false;
    }
  }

  void saveFromDb(Database dbInstance, Map<String, dynamic> dbData) {
    _selectedTheme = dbData['theme'];
    _overrideSslCheck = dbData['overrideSslCheck'];
    _useDynamicColor = convertFromIntToBool(dbData['useDynamicColor'])!;
    _staticColor = dbData['staticColor'];
    _autoRefreshTimeHome = dbData['autoRefreshTimeHome'];
    _autoRefreshTimeStatus = dbData['autoRefreshTimeStatus'];
    _apiAnnouncementReaden = convertFromIntToBool(dbData['apiAnnouncementReaden'])!;
    _timeoutRequests = convertFromIntToBool(dbData['timeoutRequests'])!;
    _statusColorsCharts = convertFromIntToBool(dbData['statusColorsCharts'])!;
    _hideVolumesNoMountPoint = convertFromIntToBool(dbData['hideVolumesNoMountPoint'])!;
    _combinedCpuChart = convertFromIntToBool(dbData['combinedCpuChart'])!;
    _hideServerAddress = convertFromIntToBool(dbData['hideServerAddress'])!;

    _dbInstance = dbInstance;
    notifyListeners();
  }
}