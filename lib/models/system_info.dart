class SystemInfo {
  final Chassis system;
  final Bios bios;
  final Baseboard baseboard;
  final Chassis chassis;

  SystemInfo({
    required this.system,
    required this.bios,
    required this.baseboard,
    required this.chassis,
  });

  factory SystemInfo.fromJson(Map<String, dynamic> json) => SystemInfo(
    system: Chassis.fromJson(json["system"]),
    bios: Bios.fromJson(json["bios"]),
    baseboard: Baseboard.fromJson(json["baseboard"]),
    chassis: Chassis.fromJson(json["chassis"]),
  );

  Map<String, dynamic> toJson() => {
    "system": system.toJson(),
    "bios": bios.toJson(),
    "baseboard": baseboard.toJson(),
    "chassis": chassis.toJson(),
  };
}

class Baseboard {
  final String manufacturer;
  final String model;
  final String version;
  final String serial;
  final int memMax;
  final int memSlots;

  Baseboard({
    required this.manufacturer,
    required this.model,
    required this.version,
    required this.serial,
    required this.memMax,
    required this.memSlots,
  });

  factory Baseboard.fromJson(Map<String, dynamic> json) => Baseboard(
    manufacturer: json["manufacturer"],
    model: json["model"],
    version: json["version"],
    serial: json["serial"],
    memMax: json["memMax"],
    memSlots: json["memSlots"],
  );

  Map<String, dynamic> toJson() => {
    "manufacturer": manufacturer,
    "model": model,
    "version": version,
    "serial": serial,
    "memMax": memMax,
    "memSlots": memSlots,
  };
}

class Bios {
  final String vendor;
  final String version;
  final String releaseDate;
  final String revision;

  Bios({
    required this.vendor,
    required this.version,
    required this.releaseDate,
    required this.revision,
  });

  factory Bios.fromJson(Map<String, dynamic> json) => Bios(
    vendor: json["vendor"],
    version: json["version"],
    releaseDate: json["releaseDate"],
    revision: json["revision"],
  );

  Map<String, dynamic> toJson() => {
    "vendor": vendor,
    "version": version,
    "releaseDate": releaseDate,
    "revision": revision,
  };
}

class Chassis {
  final String manufacturer;
  final String model;
  final String version;
  final String? serial;

  Chassis({
    required this.manufacturer,
    required this.model,
    required this.version,
    this.serial,
  });

  factory Chassis.fromJson(Map<String, dynamic> json) => Chassis(
    manufacturer: json["manufacturer"],
    model: json["model"],
    version: json["version"],
    serial: json["serial"],
  );

  Map<String, dynamic> toJson() => {
    "manufacturer": manufacturer,
    "model": model,
    "version": version,
    "serial": serial,
  };
}
