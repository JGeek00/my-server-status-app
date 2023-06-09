import 'package:my_server_status/services/http_requests.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

import 'package:my_server_status/constants/enums.dart';
import 'package:my_server_status/functions/conversions.dart';
import 'package:my_server_status/models/general_info.dart';
import 'package:my_server_status/models/server_info.dart';
import 'package:my_server_status/models/system_specs_info.dart';
import 'package:my_server_status/services/database/queries.dart';
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
    loadStatus: LoadStatus.loading,
    data: null
  );

  final SystemSpecsInformation _systemSpecsInfo = SystemSpecsInformation(
    loadStatus: LoadStatus.loading,
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

  SystemSpecsInformation get systemSpecsInfo {
    return _systemSpecsInfo;
  }
 
  void setDbInstance(Database db) {
    _dbInstance = db;
  }

  void addServer(Server server) {
    _serversList.add(server);
    notifyListeners();
  }

  void setSelectedServer(Server? server) {
    _selectedServer = server;
    notifyListeners();
  }

  void setServerConnected(bool? status) {
    _serverConnected = status;
    notifyListeners();
  }

  void setServerInfoLoadStatus(LoadStatus status) {
    _serverInfo.loadStatus = status;
    notifyListeners();
  }

  void setServerInfoData(GeneralInfo data) {
    _serverInfo.data = data;
    notifyListeners();
  }

  void setSystemSpecsInfoLoadStatus(LoadStatus status) {
    _systemSpecsInfo.loadStatus = status;
    notifyListeners();
  }

  void setSystemSpecsInfoData(SystemSpecsInformationData? data) {
    _systemSpecsInfo.data = data;
    notifyListeners();
  }
 
  Future<dynamic> createServer(Server server) async {
    final saved = await saveServerQuery(_dbInstance!, server);
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
    final updated = await setDefaultServerQuery(_dbInstance!, server.id);
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
    final result = await editServerQuery(_dbInstance!, server);
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
    final result = await removeServerQuery(_dbInstance!, server.id);
    if (result == true) {
      if (_selectedServer != null && server.id == _selectedServer!.id) {
        _selectedServer = null;
        _serverConnected = null;
        _serverInfo.loadStatus = LoadStatus.loading;
        _serverInfo.data = null;
        _systemSpecsInfo.loadStatus = LoadStatus.loading;
        _systemSpecsInfo.data = null;
      }

      List<Server> newServers = _serversList.where((s) => s.id != server.id).toList();
      _serversList = newServers;
      notifyListeners();
      return true;
    }
    else {
      return false;
    }
  }

  void checkApiVersion(Server server) async {
    final result = await getApiVersion(server: server);
    if (result['result'] == 'success') {
      _selectedServer!.apiVersion = result['data'];
      notifyListeners();
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
          checkApiVersion(serverObj);
        }
      }
    }
    notifyListeners();
  }
}