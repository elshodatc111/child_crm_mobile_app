import 'package:flutter/material.dart';
class GroupAllChildPage extends StatelessWidget {
  final int group_id;
  const GroupAllChildPage({super.key, required this.group_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bolalar va Tarbiyachilar tarixi"),),
    );
  }
}
