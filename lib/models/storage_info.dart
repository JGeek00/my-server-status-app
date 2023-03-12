class StorageInfo {
  final List<DiskLayout> diskLayout;
  final List<FsSize> fsSize;

  StorageInfo({
    required this.diskLayout,
    required this.fsSize,
  });

  factory StorageInfo.fromJson(Map<String, dynamic> json) => StorageInfo(
    diskLayout: List<DiskLayout>.from(json["diskLayout"].map((x) => DiskLayout.fromJson(x))),
    fsSize: List<FsSize>.from(json["fsSize"].map((x) => FsSize.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "diskLayout": List<dynamic>.from(diskLayout.map((x) => x.toJson())),
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
    temperature: json["temperature"],
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
