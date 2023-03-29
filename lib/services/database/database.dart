import 'package:sqflite/sqflite.dart';

Future<Map<String, dynamic>> loadDb(bool acceptsDynamicTheme) async {
  List<Map<String, Object?>>? servers;
  List<Map<String, Object?>>? appConfig;

  Future upgradeDbToV2(Database db) async {
    await db.execute("ALTER TABLE appConfig ADD COLUMN autoRefreshTimeStatus NUMERIC");
    await db.execute("UPDATE appConfig SET autoRefreshTimeStatus = 2");

    await db.transaction((txn) async{
      await txn.rawQuery(
        'SELECT * FROM appConfig',
      );
    });
  }

  Database db = await openDatabase(
    'my_server_status.db',
    version: 2,
    onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE servers (id TEXT PRIMARY KEY, name TEXT, connectionMethod TEXT, domain TEXT, path TEXT, port INTEGER, user TEXT, password TEXT, defaultServer INTEGER, authToken TEXT)");
      await db.execute("CREATE TABLE appConfig (theme NUMERIC, overrideSslCheck NUMERIC, useDynamicColor NUMERIC, staticColor NUMERIC, autoRefreshTimeHome NUMERIC, autoRefreshTimeStatus NUMERIC, apiAnnouncementReaden NUMERIC)");
      await db.execute("INSERT INTO appConfig (theme, overrideSslCheck, useDynamicColor, staticColor, autoRefreshTimeHome, autoRefreshTimeStatus, apiAnnouncementReaden) VALUES (0, 0, ${acceptsDynamicTheme == true ? 1 : 0}, 0, 2, 2, 0)");
    },
    onUpgrade: (Database db, int oldVersion, int newVersion) async {
      if (oldVersion == 1) {
        await upgradeDbToV2(db);
      }
    },
    onOpen: (Database db) async {
      await db.transaction((txn) async{
        servers = await txn.rawQuery(
          'SELECT * FROM servers',
        );
      });
      await db.transaction((txn) async{
        appConfig = await txn.rawQuery(
          'SELECT * FROM appConfig',
        );
      });
    }
  );

  return {
    "servers": servers,
    "appConfig": appConfig![0],
    "dbInstance": db,
  };
}