class DockerImage {
  final String? id;
  final String? container;
  final String? comment;
  final String? os;
  final String? architecture;
  final String? parent;
  final String? dockerVersion;
  final int? size;
  final String? author;
  final int? created;
  final ContainerConfig? containerConfig;
  final Config? config;
  final List<String>? repoTags;

  DockerImage({
    this.id,
    this.container,
    this.comment,
    this.os,
    this.architecture,
    this.parent,
    this.dockerVersion,
    this.size,
    this.author,
    this.created,
    this.containerConfig,
    this.config,
    this.repoTags
  });

  factory DockerImage.fromJson(Map<String, dynamic> json) => DockerImage(
    id: json["id"],
    container: json["container"],
    comment: json["comment"]!,
    os: json["os"]!,
    architecture: json["architecture"]!,
    parent: json["parent"],
    dockerVersion: json["dockerVersion"]!,
    size: json["size"],
    author: json["author"],
    created: json["created"],
    containerConfig: json["containerConfig"] == null ? null : ContainerConfig.fromJson(json["containerConfig"]),
    config: json["config"] == null ? null : Config.fromJson(json["config"]),
    repoTags: json["repoTags"] != null ? List<String>.from(json["repoTags"]) : null
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "container": container,
    "comment": comment,
    "os": os,
    "architecture": architecture,
    "parent": parent,
    "dockerVersion": dockerVersion,
    "size": size,
    "author": author,
    "created": created,
    "containerConfig": containerConfig?.toJson(),
    "config": config?.toJson(),
    "repoTags": repoTags == null ? [] : List<dynamic>.from(repoTags!.map((x) => x)),
  };
}

class Config {
  final String? hostname;
  final String? domainname;
  final String? user;
  final bool? attachStdin;
  final bool? attachStdout;
  final bool? attachStderr;
  final bool? tty;
  final bool? openStdin;
  final bool? stdinOnce;
  final List<String>? env;
  final List<String>? cmd;
  final String? image;
  final Map<String, dynamic>? volumes;
  final String? workingDir;
  final List<String>? entrypoint;
  final dynamic onBuild;
  final Map<String, dynamic>? labels;
  final List<String>? shell;
  final Map<String, dynamic>? exposedPorts;
  final Healthcheck? healthcheck;
  final String? stopSignal;
  final bool? argsEscaped;

  Config({
    this.hostname,
    this.domainname,
    this.user,
    this.attachStdin,
    this.attachStdout,
    this.attachStderr,
    this.tty,
    this.openStdin,
    this.stdinOnce,
    this.env,
    this.cmd,
    this.image,
    this.volumes,
    this.workingDir,
    this.entrypoint,
    this.onBuild,
    this.labels,
    this.shell,
    this.exposedPorts,
    this.healthcheck,
    this.stopSignal,
    this.argsEscaped,
  });

  factory Config.fromJson(Map<String, dynamic> json) => Config(
    hostname: json["Hostname"],
    domainname: json["Domainname"],
    user: json["User"]!,
    attachStdin: json["AttachStdin"],
    attachStdout: json["AttachStdout"],
    attachStderr: json["AttachStderr"],
    tty: json["Tty"],
    openStdin: json["OpenStdin"],
    stdinOnce: json["StdinOnce"],
    env: json["Env"] == null ? [] : List<String>.from(json["Env"]!.map((x) => x)),
    cmd: json["Cmd"] == null ? [] : List<String>.from(json["Cmd"]!.map((x) => x)),
    image: json["Image"],
    volumes: json["Volumes"],
    workingDir: json["WorkingDir"],
    entrypoint: json["Entrypoint"] == null ? [] : List<String>.from(json["Entrypoint"]!.map((x) => x)),
    onBuild: json["OnBuild"],
    labels: json["Labels"],
    shell: json["Shell"] == null ? [] : List<String>.from(json["Shell"]!.map((x) => x)),
    exposedPorts: json["ExposedPorts"],
    healthcheck: json["Healthcheck"] == null ? null : Healthcheck.fromJson(json["Healthcheck"]),
    stopSignal: json["StopSignal"],
    argsEscaped: json["ArgsEscaped"],
  );

  Map<String, dynamic> toJson() => {
    "Hostname": hostname,
    "Domainname": domainname,
    "User": user,
    "AttachStdin": attachStdin,
    "AttachStdout": attachStdout,
    "AttachStderr": attachStderr,
    "Tty": tty,
    "OpenStdin": openStdin,
    "StdinOnce": stdinOnce,
    "Env": env == null ? [] : List<dynamic>.from(env!.map((x) => x)),
    "Cmd": cmd == null ? [] : List<dynamic>.from(cmd!.map((x) => x)),
    "Image": image,
    "Volumes": volumes,
    "WorkingDir": workingDir,
    "Entrypoint": entrypoint == null ? [] : List<dynamic>.from(entrypoint!.map((x) => x)),
    "OnBuild": onBuild,
    "Labels": labels,
    "Shell": shell == null ? [] : List<dynamic>.from(shell!.map((x) => x)),
    "ExposedPorts": exposedPorts,
    "Healthcheck": healthcheck?.toJson(),
    "StopSignal": stopSignal,
    "ArgsEscaped": argsEscaped,
  };
}

class ExposedPort {
  ExposedPort();

  factory ExposedPort.fromJson(Map<String, dynamic> json) => ExposedPort(
  );

  Map<String, dynamic> toJson() => {
  };
}

class Healthcheck {
  final List<String>? test;

  Healthcheck({
    this.test,
  });

  factory Healthcheck.fromJson(Map<String, dynamic> json) => Healthcheck(
    test: json["Test"] == null ? [] : List<String>.from(json["Test"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Test": test == null ? [] : List<dynamic>.from(test!.map((x) => x)),
  };
}

class ContainerConfig {
  final String? hostname;
  final String? domainname;
  final String? user;
  final bool? attachStdin;
  final bool? attachStdout;
  final bool? attachStderr;
  final bool? tty;
  final bool? openStdin;
  final bool? stdinOnce;
  final List<String>? env;
  final List<String>? cmd;
  final String? image;
  final Map<String, dynamic>? volumes;
  final String? workingDir;
  final List<String>? entrypoint;
  final dynamic onBuild;
  final ContainerConfigLabels? labels;
  final Map<String, dynamic>? exposedPorts;
  final String? stopSignal;

  ContainerConfig({
    this.hostname,
    this.domainname,
    this.user,
    this.attachStdin,
    this.attachStdout,
    this.attachStderr,
    this.tty,
    this.openStdin,
    this.stdinOnce,
    this.env,
    this.cmd,
    this.image,
    this.volumes,
    this.workingDir,
    this.entrypoint,
    this.onBuild,
    this.labels,
    this.exposedPorts,
    this.stopSignal,
  });

  factory ContainerConfig.fromJson(Map<String, dynamic> json) => ContainerConfig(
    hostname: json["Hostname"],
    domainname: json["Domainname"],
    user: json["User"],
    attachStdin: json["AttachStdin"],
    attachStdout: json["AttachStdout"],
    attachStderr: json["AttachStderr"],
    tty: json["Tty"],
    openStdin: json["OpenStdin"],
    stdinOnce: json["StdinOnce"],
    env: json["Env"] == null ? [] : List<String>.from(json["Env"]!.map((x) => x)),
    cmd: json["Cmd"] == null ? [] : List<String>.from(json["Cmd"]!.map((x) => x)),
    image: json["Image"],
    volumes: json["Volumes"],
    workingDir: json["WorkingDir"],
    entrypoint: json["Entrypoint"] == null ? [] : List<String>.from(json["Entrypoint"]!.map((x) => x)),
    onBuild: json["OnBuild"],
    labels: json["Labels"] == null ? null : ContainerConfigLabels.fromJson(json["Labels"]),
    exposedPorts: json["ExposedPorts"],
    stopSignal: json["StopSignal"],
  );

  Map<String, dynamic> toJson() => {
    "Hostname": hostname,
    "Domainname": domainname,
    "User": user,
    "AttachStdin": attachStdin,
    "AttachStdout": attachStdout,
    "AttachStderr": attachStderr,
    "Tty": tty,
    "OpenStdin": openStdin,
    "StdinOnce": stdinOnce,
    "Env": env == null ? [] : List<dynamic>.from(env!.map((x) => x)),
    "Cmd": cmd == null ? [] : List<dynamic>.from(cmd!.map((x) => x)),
    "Image": image,
    "Volumes": volumes,
    "WorkingDir":workingDir,
    "Entrypoint": entrypoint == null ? [] : List<dynamic>.from(entrypoint!.map((x) => x)),
    "OnBuild": onBuild,
    "Labels": labels?.toJson(),
    "ExposedPorts": exposedPorts,
    "StopSignal": stopSignal,
  };
}

class ContainerConfigLabels {
  final String? description;
  final String? maintainer;

  ContainerConfigLabels({
    this.description,
    this.maintainer,
  });

  factory ContainerConfigLabels.fromJson(Map<String, dynamic> json) => ContainerConfigLabels(
    description: json["description"],
    maintainer: json["maintainer"],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "maintainer": maintainer,
  };
}