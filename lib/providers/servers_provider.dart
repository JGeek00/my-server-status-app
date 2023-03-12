import 'package:my_server_status/functions/conversions.dart';
import 'package:my_server_status/models/server_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

import 'package:my_server_status/models/server.dart';

class ServersProvider with ChangeNotifier {
  Database? _dbInstance;

  List<Server> _serversList = [];
  Server? _selectedServer;

  List<Server> get serversList {
    return _serversList;
  }

  bool? _serverConnected;

  final ServerInfo _serverInfo = ServerInfo(
    loadStatus: 0, // 0 = loading, 1 = loaded, 2 = error
    data: null
  );

  Server? get selectedServer {
    return _selectedServer;
  }

  bool? get serverConnected {
    return _serverConnected;
  }

  ServerInfo get serverInfo {
    return _serverInfo;
  }
 
  void setDbInstance(Database db) {
    _dbInstance = db;
  }

  void addServer(Server server) {
    _serversList.add(server);
    notifyListeners();
  }

  void setSelectedServer(Server server) {
    _selectedServer = server;
    notifyListeners();
  }

  void setServerConnected(bool status) {
    _serverConnected = status;
    notifyListeners();
  }

  void setServerInfoLoadStatus(int status) {
    _serverInfo.loadStatus = status;
    notifyListeners();
  }

  void setServerInfoData(ServerInfoData data) {
    _serverInfo.data = data;
    notifyListeners();
  }
 
  Future<dynamic> createServer(Server server) async {
    final saved = await saveServerIntoDb(server);
    if (saved == null) {
      if (server.defaultServer == true) {
        final defaultServer = await setDefaultServer(server);
        if (defaultServer == null) {
          _serversList.add(server);
          notifyListeners();
          return null;
        }
        else {
          return defaultServer;
        }
      }
      else {
        _serversList.add(server);
        notifyListeners();
        return null;
      }
    }
    else {
      return saved;
    }
  }

  Future<dynamic> setDefaultServer(Server server) async {
    final updated = await setDefaultServerDb(server.id);
    if (updated == null) {
      List<Server> newServers = _serversList.map((s) {
        if (s.id == server.id) {
          s.defaultServer = true;
          return s;
        }
        else {
          s.defaultServer = false;
          return s;
        }
      }).toList();
      _serversList = newServers;
      notifyListeners();
      return null;
    }
    else {
      return updated;
    }
  }

  Future<dynamic> editServer(Server server) async {
    final result = await editServerDb(server);
    if (result == null) {
      List<Server> newServers = _serversList.map((s) {
        if (s.id == server.id) {
          return server;
        }
        else {
          return s;
        }
      }).toList();
      _serversList = newServers;
      notifyListeners();
      return null;
    }
    else {
      return result;
    }
  }

  Future<bool> removeServer(Server server) async {
    final result = await removeFromDb(server.id);
    if (result == true) {
      _selectedServer = null;
      List<Server> newServers = _serversList.where((s) => s.id != server.id).toList();
      _serversList = newServers;
      notifyListeners();
      return true;
    }
    else {
      return false;
    }
  }

  Future<dynamic> saveServerIntoDb(Server server) async {
    try {
      return await _dbInstance!.transaction((txn) async {
        await txn.rawInsert(
          'INSERT INTO servers (id, name, connectionMethod, domain, path, port, user, password, defaultServer, authToken) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [server.id, server.name, server.connectionMethod, server.domain, server.path, server.port, server.user, server.password, server.defaultServer, server.authToken]
        );
        return null;
      });
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> editServerDb(Server server) async {
    try {
      return await _dbInstance!.transaction((txn) async {
        await txn.rawUpdate(
          'UPDATE servers SET name = ?, connectionMethod = ?, domain = ?, path = ?, port = ?, user = ?, password = ?, authToken = ? WHERE id = "${server.id}"',
          [server.name, server.connectionMethod, server.domain, server.path, server.port, server.user, server.password, server.authToken]
        );
        return null;
      });
    } catch (e) {
      return e;
    }
  }

  Future<bool> removeFromDb(String id) async {
    try {
      return await _dbInstance!.transaction((txn) async {
        await txn.rawDelete(
          'DELETE FROM servers WHERE id = "$id"',
        );
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> setDefaultServerDb(String id) async {
    try {
      return await _dbInstance!.transaction((txn) async {
        await txn.rawUpdate(
          'UPDATE servers SET defaultServer = 0 WHERE defaultServer = 1',
        );
        await txn.rawUpdate(
          'UPDATE servers SET defaultServer = 1 WHERE id = "$id"',
        );
        return null;
      });
    } catch (e) {
      return e;
    }
  }

  void saveFromDb(List<Map<String, dynamic>>? data) async {
    if (data != null) {
      for (var server in data) {
        final Server serverObj = Server(
          id: server['id'],
          name: server['name'],
          connectionMethod: server['connectionMethod'],
          domain: server['domain'],
          path: server['path'],
          port: server['port'],
          user: server['user'],
          password: server['password'],
          defaultServer: convertFromIntToBool(server['defaultServer'])!,
          authToken: server['authToken'],
        );
        _serversList.add(serverObj);
        if (convertFromIntToBool(server['defaultServer']) == true) {
          _selectedServer = serverObj;
        }
      }
    }
    notifyListeners();
  }
}