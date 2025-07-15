import 'package:flutter/material.dart';
class GroupDavomadHistoryPage extends StatelessWidget {
  final int group_id;
  const GroupDavomadHistoryPage({super.key, required this.group_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Davomad tarixi"),),
    );
  }
}
