import 'package:flutter/material.dart';
class GroupCrateDavomadPage extends StatelessWidget {
  final int group_id;
  const GroupCrateDavomadPage({super.key, required this.group_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Davomad olish"),),
    );
  }
}
