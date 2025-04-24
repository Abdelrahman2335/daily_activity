import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            // TODO Add user image

            child: Icon(PhosphorIcons.user()),
          ),
        ),
      ),
    );
  }
}
