import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/widgets/tab_content.dart';
import 'package:my_server_status/screens/docker/container_screen.dart';

import 'package:my_server_status/models/docker_container.dart';
import 'package:my_server_status/functions/datetime.dart';
import 'package:my_server_status/services/http_requests.dart';
import 'package:my_server_status/providers/servers_provider.dart';
import 'package:my_server_status/constants/enums.dart';

class ContainersTab extends StatefulWidget {
  const ContainersTab({Key? key}) : super(key: key);

  @override
  State<ContainersTab> createState() => _ContainersTabState();
}

class _ContainersTabState extends State<ContainersTab> {
  LoadStatus loadStatus = LoadStatus.loading;
  List<DockerContainer>? data;

  Future loadData() async {
    final server = Provider.of<ServersProvider>(context, listen: false).selectedServer;
    final result = await getDockerContainers(server: server!);
    if (result['result'] == 'success') {
      setState(() {
        data = result['data'];
        loadStatus = LoadStatus.loaded;
      });
    }
    else {
      setState(() => loadStatus = LoadStatus.error);
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTabContentBuilder(
      loadingGenerator: () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 30),
          Text(
            AppLocalizations.of(context)!.loadingDockerInformation,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          )
        ],
      ), 
      itemCount: data != null ? data!.length : 0,
      contentGenerator: (context, i) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => ContainerScreen(container: data![i])
          )),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data![i].name!,
                      style: const TextStyle(
                        fontSize: 16
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data![i].image!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${AppLocalizations.of(context)!.created}: ${convertUnixDate(date: data![i].created!)}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Icon(
                  data![i].state! == 'running'
                    ? Icons.check_circle_rounded
                    : data![i].state! == 'stopped'
                      ? Icons.cancel_rounded
                      : Icons.error_rounded,
                  color: data![i].state! == 'running'
                    ? Colors.green
                    : data![i].state! == 'stopped'
                      ? Colors.red
                      : Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ), 
      errorGenerator: () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            color: Colors.red,
            size: 50,
          ),
          const SizedBox(height: 30),
          Text(
            AppLocalizations.of(context)!.dockerInformationNotLoaded,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ), 
      loadStatus: loadStatus, 
      onRefresh: loadData,
    );
  }
}