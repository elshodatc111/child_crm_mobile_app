import 'package:flutter/material.dart';

class GroupShowPage extends StatelessWidget {
  final int group_id;
  const GroupShowPage({super.key, required this.group_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Guruh haqida")),
      body: Center(child: Text("Guruh haqida")),
    );
  }
}
