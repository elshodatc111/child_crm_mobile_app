import 'package:flutter/material.dart';
class ChildGroupHistoryPage extends StatelessWidget {
  final int child_id;
  const ChildGroupHistoryPage({super.key, required this.child_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Guruhlar tarixi"),),
      body: Text("Guruhlar tarixi"),
    );
  }
}
