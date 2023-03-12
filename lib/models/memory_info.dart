class MemoryInfo {
  final int total;
  final int free;
  final int used;
  final int active;
  final int swaptotal;
  final int swapused;
  final int swapfree;

  MemoryInfo({
    required this.total,
    required this.free,
    required this.used,
    required this.active,
    required this.swaptotal,
    required this.swapused,
    required this.swapfree,
  });

  factory MemoryInfo.fromJson(Map<String, dynamic> json) => MemoryInfo(
    total: json["total"],
    free: json["free"],
    used: json["used"],
    active: json["active"],
    swaptotal: json["swaptotal"],
    swapused: json["swapused"],
    swapfree: json["swapfree"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "free": free,
    "used": used,
    "active": active,
    "swaptotal": swaptotal,
    "swapused": swapused,
    "swapfree": swapfree,
  };
}
