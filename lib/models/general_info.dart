class GeneralInfo {
  final Cpu cpu;
  final Memory memory;
  final List<StorageFs> storageFs;
  final List<Network> network;
  final System? system;

  GeneralInfo({
    required this.cpu,
    required this.memory,
    required this.storageFs,
    required this.network,
    required this.system,
  });

  factory GeneralInfo.fromJson(Map<String, dynamic> json) => GeneralInfo(
    cpu: Cpu.fromJson(json["cpu"]),
    memory: Memory.fromJson(json["memory"]),
    storageFs: List<StorageFs>.from(json["storageFs"].map((x) {
      if (x["size"] != null && x["used"] != null && x["use"] != null && x["mount"] != null) {
        return StorageFs.fromJson(x);
      }
      else {
        return null;
      }
    }).where((x) => x != null)),
    network: List<Network>.from(json["network"].map((x) => Network.fromJson(x))),
    system: json["system"] != null ? System.fromJson(json["system"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "cpu": cpu.toJson(),
    "memory": memory.toJson(),
    "storageFs": List<dynamic>.from(storageFs.map((x) => x.toJson())),
    "network": List<dynamic>.from(network.map((x) => x.toJson())),
    "system": system?.toJson(),
  };
}

class Cpu {
  final CpuInfo info;
  final Speed speed;
  final Temp temp;
  final Load load;

  Cpu({
    required this.info,
    required this.speed,
    required this.temp,
    required this.load,
  });

  factory Cpu.fromJson(Map<String, dynamic> json) => Cpu(
    info: CpuInfo.fromJson(json["info"]),
    speed: Speed.fromJson(json["speed"]),
    temp: Temp.fromJson(json["temp"]),
    load: Load.fromJson(json["load"]),
  );

  Map<String, dynamic> toJson() => {
    "info": info.toJson(),
    "speed": speed.toJson(),
    "temp": temp.toJson(),
    "load": load.toJson(),
  };
}

class CpuInfo {
  final String manufacturer;
  final String brand;

  CpuInfo({
    required this.manufacturer,
    required this.brand,
  });

  factory CpuInfo.fromJson(Map<String, dynamic> json) => CpuInfo(
    manufacturer: json["manufacturer"],
    brand: json["brand"],
  );

  Map<String, dynamic> toJson() => {
    "manufacturer": manufacturer,
    "brand": brand,
  };
}

class Load {
  final double currentLoad;

  Load({
    required this.currentLoad,
  });

  factory Load.fromJson(Map<String, dynamic> json) => Load(
    currentLoad: json["currentLoad"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "currentLoad": currentLoad,
  };
}

class Speed {
  final double avg;

  Speed({
    required this.avg,
  });

  factory Speed.fromJson(Map<String, dynamic> json) => Speed(
    avg: json["avg"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "avg": avg,
  };
}

class Temp {
  final int? main;

  Temp({
    this.main,
  });

  factory Temp.fromJson(Map<String, dynamic> json) => Temp(
    main: json["main"] != null 
      ? json["main"].runtimeType == double ? json["main"].toInt() : json["main"]
      : null,
  );

  Map<String, dynamic> toJson() => {
    "main": main,
  };
}

class Memory {
  final MemoryInfo info;
  final List<Layout> layout;

  Memory({
    required this.info,
    required this.layout,
  });

  factory Memory.fromJson(Map<String, dynamic> json) => Memory(
    info: MemoryInfo.fromJson(json["info"]),
    layout: List<Layout>.from(json["layout"].map((x) => Layout.fromJson(x)),
  ));

  Map<String, dynamic> toJson() => {
    "info": info.toJson(),
    "layout": List<dynamic>.from(layout.map((x) => x.toJson())),
  };
}

class MemoryInfo {
  final int total;
  final int active;
  final int swaptotal;
  final int swapused;

  MemoryInfo({
    required this.total,
    required this.active,
    required this.swaptotal,
    required this.swapused,
  });

  factory MemoryInfo.fromJson(Map<String, dynamic> json) => MemoryInfo(
    total: json["total"],
    active: json["active"],
    swaptotal: json["swaptotal"],
    swapused: json["swapused"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "active": active,
    "swaptotal": swaptotal,
    "swapused": swapused,
  };
}

class Layout {
  final int size;
  final String type;

  Layout({
    required this.size,
    required this.type,
  });

  factory Layout.fromJson(Map<String, dynamic> json) => Layout(
    size: json["size"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "size": size,
    "type": type,
  };
}

class Network {
  final String iface;
  final String ip4;
  final String ip6;
  final String mac;
  final String operstate;
  final String type;

  Network({
    required this.iface,
    required this.ip4,
    required this.ip6,
    required this.mac,
    required this.operstate,
    required this.type,
  });

  factory Network.fromJson(Map<String, dynamic> json) => Network(
    iface: json["iface"],
    ip4: json["ip4"],
    ip6: json["ip6"],
    mac: json["mac"],
    operstate: json["operstate"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "iface": iface,
    "ip4": ip4,
    "ip6": ip6,
    "mac": mac,
    "operstate": operstate,
    "type": type,
  };
}

class StorageFs {
  final int size;
  final int used;
  final double use;
  final String mount;
  
  StorageFs({
    required this.size,
    required this.used,
    required this.use,
    required this.mount,
  });

  factory StorageFs.fromJson(Map<String, dynamic> json) => StorageFs(
    size: json["size"],
    used: json["used"],
    use: json["use"]?.toDouble(),
    mount: json["mount"],
  );

  Map<String, dynamic> toJson() => {
    "size": size,
    "used": used,
    "use": use,
    "mount": mount,
  };
}

class System {
  final double? uptime;

  System({
    this.uptime,
  });

  factory System.fromJson(Map<String, dynamic> json) => System(
    uptime: json["uptime"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "uptime": uptime,
  };
}
