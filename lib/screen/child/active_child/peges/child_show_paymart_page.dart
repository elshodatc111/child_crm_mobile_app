import 'package:flutter/material.dart';
class ChildShowPaymartPage extends StatelessWidget {
  final int child_id;
  const ChildShowPaymartPage({super.key, required this.child_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("To'lovlar"),),
      body: Text("To'lovlar"),
    );
  }
}
