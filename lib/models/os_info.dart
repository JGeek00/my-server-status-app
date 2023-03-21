class OsInfo {
  final String platform;
  final String distro;
  final String release;
  final String kernel;
  final String arch;
  final String hostname;
  final String build;
  final bool uefi;
  
  OsInfo({
    required this.platform,
    required this.distro,
    required this.release,
    required this.kernel,
    required this.arch,
    required this.hostname,
    required this.build,
    required this.uefi,
  });

  factory OsInfo.fromJson(Map<String, dynamic> json) => OsInfo(
    platform: json["platform"],
    distro: json["distro"],
    release: json["release"],
    kernel: json["kernel"],
    arch: json["arch"],
    hostname: json["hostname"],
    build: json["build"],
    uefi: json["uefi"],
  );

  Map<String, dynamic> toJson() => {
    "platform": platform,
    "distro": distro,
    "release": release,
    "kernel": kernel,
    "arch": arch,
    "hostname": hostname,
    "build": build,
    "uefi": uefi,
  };
}
