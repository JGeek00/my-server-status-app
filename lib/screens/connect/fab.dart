import 'package:flutter/material.dart';

import 'package:my_server_status/widgets/add_server_modal.dart';

class FabConnect extends StatelessWidget {
  const FabConnect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void openAddServerModal() async {
      await Future.delayed(const Duration(seconds: 0), (() => {
        Navigator.push(context, MaterialPageRoute(
          fullscreenDialog: true,
          builder: (BuildContext context) => const AddServerModal()
        ))
      }));
    }

    return FloatingActionButton(
      onPressed: openAddServerModal,
      child: const Icon(Icons.add_rounded),
    );
  }
}