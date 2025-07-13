import 'package:flutter/material.dart';
class ChildDavomadHistoryPage extends StatelessWidget {
  final int child_id;
  const ChildDavomadHistoryPage({super.key, required this.child_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Davomad tarixi"),),
      body: Text("Davomad tarixi"),
    );
  }
}
