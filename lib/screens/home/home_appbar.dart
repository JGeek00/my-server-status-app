import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget build(BuildContext context) {

    return AppBar(
      toolbarHeight: 70,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Home")
            // Row(
            //   children: [
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         if (serversProvider.selectedServer != null) ...[
            //           Text(
            //             server!.name,
            //             style: const TextStyle(
            //               fontSize: 20
            //             ),
            //           ),
            //           const SizedBox(height: 5),
            //           Text(
            //             "${server.connectionMethod}://${server.domain}${server.path ?? ""}${server.port != null ? ':${server.port}' : ""}",
            //             style: TextStyle(
            //               fontSize: 14,
            //               color: Theme.of(context).listTileTheme.textColor
            //             ),
            //           )
            //         ],
            //         if (serversProvider.selectedServer == null) Text(
            //           AppLocalizations.of(context)!.noServerSelected,
            //           style: const TextStyle(
            //             fontSize: 20
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(70);
}