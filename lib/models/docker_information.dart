class DockerInformation {
  final int? containers;
  final int? containersRunning;
  final int? containersPaused;
  final int? containersStopped;
  final int? images;
  final int? ncpu;
  final int? memTotal;

  DockerInformation({
    this.containers,
    this.containersRunning,
    this.containersPaused,
    this.containersStopped,
    this.images,
    this.ncpu,
    this.memTotal,
  });

  factory DockerInformation.fromJson(Map<String, dynamic> json) => DockerInformation(
    containers: json["containers"],
    containersRunning: json["containersRunning"],
    containersPaused: json["containersPaused"],
    containersStopped: json["containersStopped"],
    images: json["images"],
    ncpu: json["ncpu"],
    memTotal: json["memTotal"],
  );

  Map<String, dynamic> toJson() => {
    "containers": containers,
    "containersRunning": containersRunning,
    "containersPaused": containersPaused,
    "containersStopped": containersStopped,
    "images": images,
    "ncpu": ncpu,
    "memTotal": memTotal,
  };
}
