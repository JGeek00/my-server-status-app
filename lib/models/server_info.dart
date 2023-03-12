import 'package:my_server_status/models/cpu_info.dart';
import 'package:my_server_status/models/memory_info.dart';
import 'package:my_server_status/models/network_info.dart';
import 'package:my_server_status/models/storage_info.dart';

class ServerInfo {
  int loadStatus = 0; 
  ServerInfoData? data;

  ServerInfo({
    required this.loadStatus,
    this.data
  });
}

class ServerInfoData {
  final CpuInfo cpu;
  final MemoryInfo memory;
  final StorageInfo storage;
  final NetworkInfo network;

  ServerInfoData({
    required this.cpu,
    required this.memory,
    required this.storage,
    required this.network
  });
}