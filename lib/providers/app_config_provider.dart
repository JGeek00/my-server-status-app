import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite/sqlite_api.dart';

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

  String? _doNotRememberVersion;

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

  String? get doNotRememberVersion {
    return _doNotRememberVersion;
  }

  List<AppLog> get logs {
    return _logs;
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
    final updated = await _updateOverrideSslCheck(status == true ? 1 : 0);
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
    final updated = await _updateThemeDb(value);
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
    final updated = await _updateDynamicColorDb(value == true ? 1 : 0);
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
    final updated = await _updateStaticColorDb(value);
    if (updated == true) {
      _staticColor = value;
      notifyListeners();
      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> setDoNotRememberVersion(String value) async {
    try {
      return await _dbInstance!.transaction((txn) async {
        await txn.rawUpdate(
          'UPDATE appConfig SET doNotRememberVersion = "$value"',
        );
        _doNotRememberVersion = value;
        notifyListeners();
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> _updateThemeDb(int value) async {
    try {
      return await _dbInstance!.transaction((txn) async {
        await txn.rawUpdate(
          'UPDATE appConfig SET theme = $value',
        );
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> _updateDynamicColorDb(int value) async {
    try {
      return await _dbInstance!.transaction((txn) async {
        await txn.rawUpdate(
          'UPDATE appConfig SET useDynamicColor = $value',
        );
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> _updateUseThemeColorForStatusDb(int value) async {
    try {
      return await _dbInstance!.transaction((txn) async {
        await txn.rawUpdate(
          'UPDATE appConfig SET useThemeColorForStatus = $value',
        );
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> _updateStaticColorDb(int value) async {
    try {
      return await _dbInstance!.transaction((txn) async {
        await txn.rawUpdate(
          'UPDATE appConfig SET staticColor = $value',
        );
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> _updateOverrideSslCheck(int value) async {
    try {
      return await _dbInstance!.transaction((txn) async {
        await txn.rawUpdate(
          'UPDATE appConfig SET overrideSslCheck = $value',
        );
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> _updateSetHideZeroValues(int value) async {
    try {
      return await _dbInstance!.transaction((txn) async {
        await txn.rawUpdate(
          'UPDATE appConfig SET hideZeroValues = $value',
        );
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> _updateShowNameTimeLogsDb(int value) async {
    try {
      return await _dbInstance!.transaction((txn) async {
        await txn.rawUpdate(
          'UPDATE appConfig SET showNameTimeLogs = $value',
        );
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  void saveFromDb(Database dbInstance, Map<String, dynamic> dbData) {
    _selectedTheme = dbData['theme'];
    _overrideSslCheck = dbData['overrideSslCheck'];
    _useDynamicColor = convertFromIntToBool(dbData['useDynamicColor'])!;
    _staticColor = dbData['staticColor'];
    _doNotRememberVersion = dbData['doNotRememberVersion'];

    _dbInstance = dbInstance;
    notifyListeners();
  }
}