import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_server_status/screens/docker/image_screen.dart';
import 'package:my_server_status/widgets/tab_content.dart';

import 'package:my_server_status/functions/memory_conversion.dart';
import 'package:my_server_status/functions/datetime.dart';
import 'package:my_server_status/services/http_requests.dart';
import 'package:my_server_status/models/docker_images.dart';
import 'package:my_server_status/providers/servers_provider.dart';
import 'package:my_server_status/constants/enums.dart';

class ImagesTab extends StatefulWidget {
  const ImagesTab({Key? key}) : super(key: key);

  @override
  State<ImagesTab> createState() => _ImagesTabState();
}

class _ImagesTabState extends State<ImagesTab> {
  LoadStatus loadStatus = LoadStatus.loading;
  List<DockerImage>? data;

  Future loadData() async {
    final server = Provider.of<ServersProvider>(context, listen: false).selectedServer;
    final result = await getDockerImages(server: server!);
    if (result['result'] == 'success') {
      if (mounted) {
        setState(() {
          data = result['data'];
          loadStatus = LoadStatus.loaded;
        });
      }
      else {
        data = result['data'];
        loadStatus = LoadStatus.loaded;
      }
    }
    else {
      if (!context.mounted) return;
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
            builder: (context) => ImageScreen(image: data![i])
          )),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data![i].id!,
                  style: const TextStyle(
                    fontSize: 16
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    itemCount: data![i].repoTags!.length,
                    itemBuilder: (context, j) => Chip(label: Text(data![i].repoTags![j])),
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${convertMemoryToMb(data![i].size!.toDouble())} MB",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurfaceVariant
                      ),
                    ),
                    Text(
                      convertUnixDate(date: data![i].created!),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurfaceVariant
                      ),
                    ),
                  ],
                )
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