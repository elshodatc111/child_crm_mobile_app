import 'package:flutter/material.dart';
class GroupDarslarTarixPage extends StatelessWidget {
  final int group_id;
  const GroupDarslarTarixPage({super.key, required this.group_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Darslar tarixi"),),
    );
  }
}
