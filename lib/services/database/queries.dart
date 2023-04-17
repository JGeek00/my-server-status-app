import 'package:sqflite/sqflite.dart';

import 'package:my_server_status/functions/conversions.dart';
import 'package:my_server_status/models/server.dart';

Future<dynamic> saveServerQuery(Database db, Server server) async {
  try {
    return await db.transaction((txn) async {
      await txn.insert(
        'servers',
        {
          'id': server.id,
          'name': server.name,
          'connectionMethod': server.connectionMethod,
          'domain': server.domain,
          'path': server.path,
          'port': server.port,
          'user': server.user,
          'password': server.password,
          'defaultServer': convertFromBoolToInt(server.defaultServer),
          'authToken': server.authToken
        }
      );
      return null;
    });
  } catch (e) {
    return e;
  }
}

Future<dynamic> editServerQuery(Database db, Server server) async {
  try {
    return await db.transaction((txn) async {
      await txn.update(
        'servers',
        {
          'id': server.id,
          'name': server.name,
          'connectionMethod': server.connectionMethod,
          'domain': server.domain,
          'path': server.path,
          'port': server.port,
          'user': server.user,
          'password': server.password,
          'defaultServer': convertFromBoolToInt(server.defaultServer),
          'authToken': server.authToken
        },
        where: 'id = ?',
        whereArgs: [server.id]
      );
      return null;
    });
  } catch (e) {
    return e;
  }
}

Future<bool> removeServerQuery(Database db, String id) async {
  try {
    return await db.transaction((txn) async {
      await txn.delete(
        'servers', 
        where: 'id = ?', 
        whereArgs: [id]
      );
      return true;
    });
  } catch (e) {
    return false;
  }
}

Future<dynamic> setDefaultServerQuery(Database db, String id) async {
  try {
    return await db.transaction((txn) async {
      await txn.update(
        'servers',
        {'defaultServer': '0'},
        where: 'defaultServer = 1',
      );
      await txn.update(
        'servers',
        {'defaultServer': '1'},
        where: 'defaultServer = ?',
        whereArgs: [id]
      );
      return null;
    });
  } catch (e) {
    return e;
  }
}



Future<bool> updateConfigQuery(Database dbInstance, String column, int value) async {
  try {
    return await dbInstance.transaction((txn) async {
      await txn.update(
        'appConfig', 
        {column: value}
      );
      return true;
    });
  } catch (e) {
    return false;
  }
}