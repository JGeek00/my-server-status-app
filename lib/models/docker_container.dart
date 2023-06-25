class DockerContainer {
  final String? id;
  final String? name;
  final String? image;
  final String? command;
  final int? created;
  final int? started;
  final int? finished;
  final String? state;
  final int? restartCount;
  final String? platform;
  final List<Port>? ports;
  final List<Mount>? mounts;

  DockerContainer({
    this.id,
    this.name,
    this.image,
    this.command,
    this.created,
    this.started,
    this.finished,
    this.state,
    this.restartCount,
    this.platform,
    this.ports,
    this.mounts,
  });

  factory DockerContainer.fromJson(Map<String, dynamic> json) => DockerContainer(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    command: json["command"],
    created: json["created"],
    started: json["started"],
    finished: json["finished"],
    state: json["state"],
    restartCount: json["restartCount"],
    platform: json["platform"],
    ports: json["ports"] == null ? [] : List<Port>.from(json["ports"]!.map((x) => Port.fromJson(x))),
    mounts: json["mounts"] == null ? [] : List<Mount>.from(json["mounts"]!.map((x) => Mount.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "command": command,
    "created": created,
    "started": started,
    "finished": finished,
    "state": state,
    "restartCount": restartCount,
    "platform": platform,
    "ports": ports == null ? [] : List<dynamic>.from(ports!.map((x) => x.toJson())),
    "mounts": mounts == null ? [] : List<dynamic>.from(mounts!.map((x) => x.toJson())),
  };
}

class Mount {
  final String? type;
  final String? source;
  final String? destination;
  final String? mode;
  final bool? rw;
  final String? propagation;
  final String? name;
  final String? driver;

  Mount({
    this.type,
    this.source,
    this.destination,
    this.mode,
    this.rw,
    this.propagation,
    this.name,
    this.driver,
  });

  factory Mount.fromJson(Map<String, dynamic> json) => Mount(
    type: json["Type"],
    source: json["Source"],
    destination: json["Destination"],
    mode: json["Mode"],
    rw: json["RW"],
    propagation: json["Propagation"],
    name: json["Name"],
    driver: json["Driver"],
  );

  Map<String, dynamic> toJson() => {
    "Type": type,
    "Source": source,
    "Destination": destination,
    "Mode": mode,
    "RW": rw,
    "Propagation": propagation,
    "Name": name,
    "Driver": driver,
  };
}

class Port {
  final String? ip;
  final int? privatePort;
  final int? publicPort;
  final String? type;

  Port({
    this.ip,
    this.privatePort,
    this.publicPort,
    this.type,
  });

  factory Port.fromJson(Map<String, dynamic> json) => Port(
    ip: json["IP"],
    privatePort: json["PrivatePort"],
    publicPort: json["PublicPort"],
    type: json["Type"],
  );

  Map<String, dynamic> toJson() => {
    "IP": ip,
    "PrivatePort": privatePort,
    "PublicPort": publicPort,
    "Type": type,
  };
}