class StorageInfo {
  final List<DiskLayout> diskLayout;
  final List<BlockDevices> blockDevices;
  final List<FsSize> fsSize;

  StorageInfo({
    required this.diskLayout,
    required this.blockDevices,
    required this.fsSize,
  });

  factory StorageInfo.fromJson(Map<String, dynamic> json) => StorageInfo(
    diskLayout: List<DiskLayout>.from(json["diskLayout"].map((x) => DiskLayout.fromJson(x))),
    blockDevices: List<BlockDevices>.from(json["blockDevices"].map((x) => BlockDevices.fromJson(x))),
    fsSize: List<FsSize>.from(json["fsSize"].map((x) {
      if (x["size"] != null && x["used"] != null && x["use"] != null && x["mount"] != null) {
        return FsSize.fromJson(x);
      }
      else {
        return null;
      }
    }).where((x) => x != null)),
  );

  Map<String, dynamic> toJson() => {
    "diskLayout": List<dynamic>.from(diskLayout.map((x) => x.toJson())),
    "blockDevices": List<dynamic>.from(blockDevices.map((x) => x.toJson())),
    "fsSize": List<dynamic>.from(fsSize.map((x) => x.toJson())),
  };
}

class DiskLayout {
  final String? device;
  final String? type;
  final String? name;
  final String? vendor;
  final int? size;
  final String? interfaceType;
  final double? temperature;
  final String? serialNum;
  final String? firmwareRevision;

  DiskLayout({
    this.device,
    this.type,
    this.name,
    this.vendor,
    this.size,
    this.interfaceType,
    this.temperature,
    this.serialNum,
    this.firmwareRevision,
  });

  factory DiskLayout.fromJson(Map<String, dynamic> json) => DiskLayout(
    device: json["device"],
    type: json["type"],
    name: json["name"],
    vendor: json["vendor"],
    size: json["size"],
    interfaceType: json["interfaceType"],
    temperature: json["temperature"] != null ? double.parse(json["temperature"]) : null,
    serialNum: json["serialNum"],
    firmwareRevision: json["firmwareRevision"],
  );

  Map<String, dynamic> toJson() => {
    "device": device,
    "type": type,
    "name": name,
    "vendor": vendor,
    "size": size,
    "interfaceType": interfaceType,
    "temperature": temperature,
    "serialNum": serialNum,
    "firmwareRevision": firmwareRevision,
  };
}

class BlockDevices {
  final String name;
  final String type;
  final String fsType;
  final String mount;
  final int? size;
  final String physical;
  final String label;
  final String? model;
  final bool removable;
  final String protocol;
  final String? group;
  final String? device;
  
  BlockDevices({
    required this.name,
    required this.type,
    required this.fsType,
    required this.mount,
    required this.size,
    required this.physical,
    required this.label,
    this.model,
    required this.removable,
    required this.protocol,
    this.group,
    this.device,
  });

  factory BlockDevices.fromJson(Map<String, dynamic> json) => BlockDevices(
    name: json["name"],
    type: json["type"],
    fsType: json["fsType"],
    mount: json["mount"],
    size: json["size"],
    physical: json["physical"]!,
    label: json["label"],
    model: json["model"],
    removable: json["removable"],
    protocol: json["protocol"],
    group: json["group"],
    device: json["device"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "type": type,
    "fsType": fsType,
    "mount": mount,
    "size": size,
    "physical": physical,
    "label": label,
    "model": model,
    "removable": removable,
    "protocol": protocol,
    "group": group,
    "device": device,
  };
}

class FsSize {
  final String fs;
  final String type;
  final int size;
  final int used;
  final int available;
  final double use;
  final String mount;
  final bool rw;

  FsSize({
    required this.fs,
    required this.type,
    required this.size,
    required this.used,
    required this.available,
    required this.use,
    required this.mount,
    required this.rw,
  });

  factory FsSize.fromJson(Map<String, dynamic> json) => FsSize(
    fs: json["fs"],
    type: json["type"],
    size: json["size"],
    used: json["used"],
    available: json["available"],
    use: json["use"]?.toDouble(),
    mount: json["mount"],
    rw: json["rw"],
  );

  Map<String, dynamic> toJson() => {
    "fs": fs,
    "type": type,
    "size": size,
    "used": used,
    "available": available,
    "use": use,
    "mount": mount,
    "rw": rw,
  };
}
