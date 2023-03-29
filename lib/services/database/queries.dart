import 'package:sqflite/sqflite.dart';

Future<bool> updateThemeQuery(Database dbInstance, int value) async {
  try {
    return await dbInstance.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE appConfig SET theme = $value',
      );
      return true;
    });
  } catch (e) {
    return false;
  }
}

Future<bool> updateDynamicColorQuery(Database dbInstance, int value) async {
  try {
    return await dbInstance.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE appConfig SET useDynamicColor = $value',
      );
      return true;
    });
  } catch (e) {
    return false;
  }
}

Future<bool> updateStaticColorQuery(Database dbInstance, int value) async {
  try {
    return await dbInstance.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE appConfig SET staticColor = $value',
      );
      return true;
    });
  } catch (e) {
    return false;
  }
}

Future<bool> updateOverrideSslCheckQuery(Database dbInstance, int value) async {
  try {
    return await dbInstance.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE appConfig SET overrideSslCheck = $value',
      );
      return true;
    });
  } catch (e) {
    return false;
  }
}

Future<bool> updateAutoRefreshHomeQuery(Database dbInstance, int value) async {
  try {
    return await dbInstance.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE appConfig SET autoRefreshTimeHome = $value',
      );
      return true;
    });
  } catch (e) {
    return false;
  }
}

Future<bool> updateAutoRefreshStatusQuery(Database dbInstance, int value) async {
  try {
    return await dbInstance.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE appConfig SET autoRefreshTimeStatus = $value',
      );
      return true;
    });
  } catch (e) {
    return false;
  }
}

Future<bool> updateApiAnnouncementReadenQuery(Database dbInstance, int value) async {
  try {
    return await dbInstance.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE appConfig SET apiAnnouncementReaden = $value',
      );
      return true;
    });
  } catch (e) {
    return false;
  }
}