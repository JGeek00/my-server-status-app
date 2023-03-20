import 'package:my_server_status/models/cpu_info.dart';
import 'package:my_server_status/models/network_info.dart';
import 'package:my_server_status/models/storage_info.dart';
import 'package:my_server_status/models/memory_info.dart';
import 'package:my_server_status/models/system_info.dart';

class SystemSpecsInformation {
  int loadStatus = 0;
  SystemSpecsInformationData? data;

  SystemSpecsInformation({
    required this.loadStatus,
    this.data
  });
}

class SystemSpecsInformationData {
  final SystemInfo systemInfo;
  final CpuInfo cpuInfo;
  final MemoryInfo memoryInfo;
  final StorageInfo storageInfo;
  final NetworkInfo networkInfo;

  const SystemSpecsInformationData({
    required this.systemInfo,
    required this.cpuInfo,
    required this.memoryInfo,
    required this.storageInfo,
    required this.networkInfo
  });

  factory SystemSpecsInformationData.fromJson(Map<String, dynamic> json) => SystemSpecsInformationData(
    systemInfo: SystemInfo.fromJson(json["systemInfo"]),
    cpuInfo: CpuInfo.fromJson(json["cpuInfo"]),
    memoryInfo: MemoryInfo.fromJson(json["memoryInfo"]),
    storageInfo: StorageInfo.fromJson(json["storageInfo"]),
    networkInfo: NetworkInfo.fromJson(json["networkInfo"]),
  );
}