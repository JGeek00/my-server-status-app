class MemoryInfo {
  final Mem mem;
  final List<MemLayout> memLayout;

  const MemoryInfo({
    required this.mem,
    required this.memLayout
  });

  factory MemoryInfo.fromJson(Map<String, dynamic> json) => MemoryInfo(
    mem:  Mem.fromJson(json["mem"]),
    memLayout: List<MemLayout>.from(json["memLayout"].map((x) => MemLayout.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "mem": mem.toJson(),
    "memLayout": List<MemLayout>.from(memLayout.map((x) => x.toJson())),
  };
}

class Mem {
  final int total;
  final int free;
  final int used;
  final int active;
  final int available;
  final int swaptotal;
  final int swapused;
  final int swapfree;

  Mem({
    required this.total,
    required this.free,
    required this.used,
    required this.active,
    required this.available,
    required this.swaptotal,
    required this.swapused,
    required this.swapfree,
  });

  factory Mem.fromJson(Map<String, dynamic> json) => Mem(
    total: json["total"],
    free: json["free"],
    used: json["used"],
    active: json["active"],
    available: json["available"],
    swaptotal: json["swaptotal"],
    swapused: json["swapused"],
    swapfree: json["swapfree"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "free": free,
    "used": used,
    "active": active,
    "available": available,
    "swaptotal": swaptotal,
    "swapused": swapused,
    "swapfree": swapfree,
  };
}

class MemLayout {
  final int size;
  final String bank;
  final String type;
  final bool? ecc;
  final String formFactor;
  final double? voltageConfigured;

  MemLayout({
    required this.size,
    required this.bank,
    required this.type,
    this.ecc,
    required this.formFactor,
    this.voltageConfigured,
  });


  factory MemLayout.fromJson(Map<String, dynamic> json) => MemLayout(
    size: json["size"],
    bank: json["bank"],
    type: json["type"],
    ecc: json["ecc"],
    formFactor: json["formFactor"],
    voltageConfigured: json["voltageConfigured"],
  );

  Map<String, dynamic> toJson() => {
    "size": size,
    "bank": bank,
    "type": type,
    "ecc": ecc,
    "formFactor": formFactor,
    "voltageConfigured": voltageConfigured,
  };
}
