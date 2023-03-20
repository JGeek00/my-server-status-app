class CpuInfo {
  final CpuDetails cpu;
  final CpuCurrentSpeed cpuCurrentSpeed;
  final CpuTemperature cpuTemperature;
  final CpuCurrentLoad cpuCurrentLoad;

  CpuInfo({
    required this.cpu,
    required this.cpuCurrentSpeed,
    required this.cpuTemperature,
    required this.cpuCurrentLoad,
  });

  factory CpuInfo.fromJson(Map<String, dynamic> json) => CpuInfo(
    cpu: CpuDetails.fromJson(json["cpu"]),
    cpuCurrentSpeed: CpuCurrentSpeed.fromJson(json["cpuCurrentSpeed"]),
    cpuTemperature: CpuTemperature.fromJson(json["cpuTemperature"]),
    cpuCurrentLoad: CpuCurrentLoad.fromJson(json["currentLoad"]),
  );

  Map<String, dynamic> toJson() => {
    "cpu": cpu.toJson(),
    "cpuCurrentSpeed": cpuCurrentSpeed.toJson(),
    "cpuTemperature": cpuTemperature.toJson(),
    "cpuCurrentLoad": cpuCurrentLoad.toJson(),
  };
}

class CpuDetails {
  final String manufacturer;
  final String brand;
  final double speed;
  final double speedMin;
  final double speedMax;
  final int cores;
  final int physicalCores;
  final int performanceCores;
  final int efficiencyCores;
  final int processors;
  final String socket;
  final CpuCache cache;

  CpuDetails({
    required this.manufacturer,
    required this.brand,
    required this.speed,
    required this.speedMin,
    required this.speedMax,
    required this.cores,
    required this.physicalCores,
    required this.performanceCores,
    required this.efficiencyCores,
    required this.processors,
    required this.socket,
    required this.cache
  });

  factory CpuDetails.fromJson(Map<String, dynamic> json) => CpuDetails(
    manufacturer: json["manufacturer"],
    brand: json["brand"],
    speed: json["speed"]?.toDouble(),
    speedMin: json["speedMin"]?.toDouble(),
    speedMax: json["speedMax"]?.toDouble(),
    cores: json["cores"],
    physicalCores: json["physicalCores"],
    performanceCores: json["performanceCores"],
    efficiencyCores: json["efficiencyCores"],
    processors: json["processors"],
    socket: json["socket"],
    cache: CpuCache.fromJson(json['cache'])
  );

  Map<String, dynamic> toJson() => {
    "manufacturer": manufacturer,
    "brand": brand,
    "speed": speed,
    "speedMin": speedMin,
    "speedMax": speedMax,
    "cores": cores,
    "physicalCores": physicalCores,
    "performanceCores": performanceCores,
    "efficiencyCores": efficiencyCores,
    "processors": processors,
    "socket": socket,
    "cache": cache.toJson()
  };
}

class CpuCache {
  final int? l1d;
  final int? l1i;
  final int? l2;
  final int? l3;

  CpuCache({
    this.l1d,
    this.l1i,
    this.l2, 
    this.l3
  });

  factory CpuCache.fromJson(Map<String, dynamic> json) => CpuCache(
    l1d: json["l1d"] != null && json["l1d"] != "" ? json["l1d"] : null,
    l1i: json["l1i"] != null && json["l1i"] != "" ? json["l1i"] : null,
    l2: json["l2"] != null && json["l2"] != "" ? json["l2"] : null,
    l3: json["l3"] != null && json["l3"] != "" ? json["l3"] : null,
  );

  Map<String, dynamic> toJson() => {
    "l1d": l1d,
    "l1i": l1i,
    "l2": l2,
    "l3": l3
  };
}

class CpuCurrentSpeed {
  final double avg;
  final double min;
  final double max;
  
  CpuCurrentSpeed({
    required this.avg,
    required this.min,
    required this.max,
  });

  factory CpuCurrentSpeed.fromJson(Map<String, dynamic> json) => CpuCurrentSpeed(
    avg: json["avg"]?.toDouble(),
    min: json["min"]?.toDouble(),
    max: json["max"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "avg": avg,
    "min": min,
    "max": max,
  };
}

class CpuTemperature {
  final int main;
  final int max;

  CpuTemperature({
    required this.main,
    required this.max,
  });

  factory CpuTemperature.fromJson(Map<String, dynamic> json) => CpuTemperature(
    main: json["main"],
    max: json["max"],
  );

  Map<String, dynamic> toJson() => {
    "main": main,
    "max": max,
  };
}

class CpuCurrentLoad {
  final double currentLoad;

  CpuCurrentLoad({
    required this.currentLoad,
  });

  factory CpuCurrentLoad.fromJson(Map<String, dynamic> json) => CpuCurrentLoad(
    currentLoad: json["currentLoad"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "main": currentLoad,
  };
}
