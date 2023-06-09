import 'package:my_server_status/models/cpu_info.dart';
import 'package:my_server_status/models/network_info.dart';
import 'package:my_server_status/models/os_info.dart';
import 'package:my_server_status/models/storage_info.dart';
import 'package:my_server_status/models/memory_info.dart';
import 'package:my_server_status/models/system_info.dart';
import 'package:my_server_status/constants/enums.dart';

class SystemSpecsInformation {
  LoadStatus loadStatus = LoadStatus.loading;
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
  final OsInfo osInfo;

  const SystemSpecsInformationData({
    required this.systemInfo,
    required this.cpuInfo,
    required this.memoryInfo,
    required this.storageInfo,
    required this.networkInfo,
    required this.osInfo
  });

  factory SystemSpecsInformationData.fromJson(Map<String, dynamic> json) => SystemSpecsInformationData(
    systemInfo: SystemInfo.fromJson(json["systemInfo"]),
    cpuInfo: CpuInfo.fromJson(json["cpuInfo"]),
    memoryInfo: MemoryInfo.fromJson(json["memoryInfo"]),
    storageInfo: StorageInfo.fromJson(json["storageInfo"]),
    networkInfo: NetworkInfo.fromJson(json["networkInfo"]),
    osInfo: OsInfo.fromJson(json["osInfo"]),
  );
}