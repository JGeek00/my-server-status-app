class NetworkInfo {
  final List<NetworkInterface> networkInterfaces;

  NetworkInfo({
    required this.networkInterfaces,
  });

  factory NetworkInfo.fromJson(Map<String, dynamic> json) => NetworkInfo(
    networkInterfaces: List<NetworkInterface>.from(json["networkInterfaces"].map((x) => NetworkInterface.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "networkInterfaces": List<dynamic>.from(networkInterfaces.map((x) => x.toJson())),
  };
}

class NetworkInterface {
  final String iface;
  final String ifaceName;
  final bool networkInterfaceDefault;
  final String ip4;
  final String ip4Subnet;
  final String ip6;
  final String ip6Subnet;
  final String mac;
  final bool? internal;
  final bool virtual;
  final String? operstate;
  final String? type;
  final String? duplex;
  final int? mtu;
  final double? speed;
  final bool? dhcp;

  NetworkInterface({
    required this.iface,
    required this.ifaceName,
    required this.networkInterfaceDefault,
    required this.ip4,
    required this.ip4Subnet,
    required this.ip6,
    required this.ip6Subnet,
    required this.mac,
    this.internal,
    required this.virtual,
    this.operstate,
    this.type,
    this.duplex,
    this.mtu,
    this.speed,
    this.dhcp,
  });

  factory NetworkInterface.fromJson(Map<String, dynamic> json) => NetworkInterface(
    iface: json["iface"],
    ifaceName: json["ifaceName"],
    networkInterfaceDefault: json["default"],
    ip4: json["ip4"],
    ip4Subnet: json["ip4subnet"],
    ip6: json["ip6"],
    ip6Subnet: json["ip6subnet"],
    mac: json["mac"],
    internal: json["internal"],
    virtual: json["virtual"],
    operstate: json["operstate"],
    type: json["type"],
    duplex: json["duplex"],
    mtu: json["mtu"],
    speed: json["speed"] != null 
      ? json["speed"].runtimeType == int ? json["speed"]!.toDouble() : json["speed"] 
      : null,
    dhcp: json["dhcp"],
  );

  Map<String, dynamic> toJson() => {
    "iface": iface,
    "ifaceName": ifaceName,
    "default": networkInterfaceDefault,
    "ip4": ip4,
    "ip4subnet": ip4Subnet,
    "ip6": ip6,
    "ip6subnet": ip6Subnet,
    "mac": mac,
    "internal": internal,
    "virtual": virtual,
    "operstate": operstate,
    "type": type,
    "duplex": duplex,
    "mtu": mtu,
    "speed": speed,
    "dhcp": dhcp,
  };
}
