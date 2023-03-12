import 'package:flutter/material.dart';
import 'package:my_server_status/screens/home/home_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: Center(
        child: Text("Home screen"),
      ),
    );
  }
}