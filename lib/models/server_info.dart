import 'package:my_server_status/models/general_info.dart';

class ServerInfo {
  int loadStatus = 0; 
  GeneralInfo? data;

  ServerInfo({
    required this.loadStatus,
    this.data
  });
}