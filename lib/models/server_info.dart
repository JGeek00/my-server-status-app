import 'package:my_server_status/models/general_info.dart';
import 'package:my_server_status/constants/enums.dart';

class ServerInfo {
  LoadStatus loadStatus = LoadStatus.loading; 
  GeneralInfo? data;

  ServerInfo({
    required this.loadStatus,
    this.data
  });
}