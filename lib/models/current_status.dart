class CurrentStatus {
  final Cpu cpu;
  final List<double>? socketTemperature;
  final double? chipsetTemperature;
  final Memory memory;
  final Storage? storage;
  final List<Network>? network;

  CurrentStatus({
    required this.cpu,
    this.socketTemperature,
    this.chipsetTemperature,
    required this.memory,
    this.storage,
    this.network,
  });

  factory CurrentStatus.fromJson(Map<String, dynamic> json) => CurrentStatus(
    cpu: Cpu.fromJson(json["cpu"]),
    socketTemperature: json["socketTemperature"] != null ? List<double>.from(json["socketTemperature"].map((x) => x.toDouble())) : [],
    chipsetTemperature: json["chipsetTemperature"]?.toDouble(),
    memory: Memory.fromJson(json["memory"]),
    storage: json["storage"] != null ? Storage.fromJson(json["storage"]) : null,
    network: List<Network>.from(json["network"].map((x) => Network.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cpu": cpu.toJson(),
    "socketTemperature": socketTemperature != null ? List<double>.from(socketTemperature!.map((x) => x)) : null,
    "chipsetTemperature": chipsetTemperature,
    "memory": memory.toJson(),
    "storage": storage != null ? storage!.toJson() : null,
    "network": network != null ? List<Network>.from(network!.map((x) => x.toJson())) : null,
  };
}

class Cpu {
  final CpuSpecs? specs;
  final List<Core> cores;
  final Average average;

  Cpu({
    required this.specs,
    required this.cores,
    required this.average,
  });

  factory Cpu.fromJson(Map<String, dynamic> json) => Cpu(
    specs: json["specs"] != null ? CpuSpecs.fromJson(json["specs"]) : null,
    cores: List<Core>.from(json["cores"].map((x) => Core.fromJson(x))),
    average: Average.fromJson(json["average"]),
  );

  Map<String, dynamic> toJson() => {
    "cores": List<dynamic>.from(cores.map((x) => x.toJson())),
    "average": average.toJson(),
  };
}

class CpuSpecs {
  final String name;
  final double? minSpeed;
  final double speed;
  final double? maxSpeed;

  CpuSpecs({
    required this.name,
    required this.minSpeed,
    required this.speed,
    required this.maxSpeed
  });

  factory CpuSpecs.fromJson(Map<String, dynamic> json) => CpuSpecs(
    name: json["name"],
    minSpeed: json["minSpeed"]?.toDouble(),
    speed: json["speed"]?.toDouble(),
    maxSpeed: json["maxSpeed"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "minSpeed": minSpeed,
    "speed": speed,
    "maxSpeed": maxSpeed,
  };
}

class Average {
  final int? temperature;
  final Load load;

  Average({
    this.temperature,
    required this.load,
  });

  factory Average.fromJson(Map<String, dynamic> json) => Average(
    temperature: json["temperature"] != null 
      ? json["temperature"].runtimeType == double ? json["temperature"].toInt() : json["temperature"]
      : null,
    load: Load.fromJson(json["load"]),
  );

  Map<String, dynamic> toJson() => {
    "temperature": temperature,
    "load": load.toJson(),
  };
}

class Load {
  final double average;
  final double user;
  final double system;
  final double idle;

  Load({
    required this.average,
    required this.user,
    required this.system,
    required this.idle,
  });

  factory Load.fromJson(Map<String, dynamic> json) => Load(
    average: json["average"]?.toDouble(),
    user: json["user"]?.toDouble(),
    system: json["system"]?.toDouble(),
    idle: json["idle"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "average": average,
    "user": user,
    "system": system,
    "idle": idle,
  };
}

class Core {
  final double speed;
  final int? temperature;
  final Map<String, double> load;

  Core({
    this.temperature,
    required this.speed,
    required this.load,
  });

  factory Core.fromJson(Map<String, dynamic> json) => Core(
    speed: json["speed"]?.toDouble(),
    temperature: json["temperature"] != null 
      ? json["temperature"].runtimeType == double ? json["temperature"].toInt() : json["temperature"]
      : null,
    load: Map.from(json["load"]).map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "speed": speed,
    "temperature": temperature,
    "load": Map.from(load).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}

class Memory {
  final MemorySpecs specs;
  final int total;
  final int used;
  final int free;
  final int active;

  Memory({
    required this.specs,
    required this.total,
    required this.used,
    required this.free,
    required this.active,
  });

  factory Memory.fromJson(Map<String, dynamic> json) => Memory(
    specs: MemorySpecs.fromJson(json["specs"]),
    total: json["total"],
    used: json["used"],
    free: json["free"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "specs": specs.toJson(),
    "total": total,
    "used": used,
    "free": free,
    "active": active,
  };
}

class MemorySpecs {
  final int capacity;
  final String type;

  MemorySpecs({
    required this.capacity,
    required this.type
  });

  factory MemorySpecs.fromJson(Map<String, dynamic> json) => MemorySpecs(
    capacity: json["capacity"].toInt(),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "capacity": capacity,
    "type": type,
  };
}
class Network {
  final String iface;
  final double tx;
  final double rx;

  Network({
    required this.iface,
    required this.tx,
    required this.rx,
  });

  factory Network.fromJson(Map<String, dynamic> json) => Network(
    iface: json["iface"],
    tx: json["tx"]?.toDouble(),
    rx: json["rx"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "iface": iface,
    "tx": tx,
    "rx": rx,
  };
}

class Storage {
  final double rx;
  final double wx;

  Storage({
    required this.rx,
    required this.wx,
  });

  factory Storage.fromJson(Map<String, dynamic> json) => Storage(
    rx: json["rx"].toDouble(),
    wx: json["wx"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "rx": rx,
    "wx": wx,
  };
}
