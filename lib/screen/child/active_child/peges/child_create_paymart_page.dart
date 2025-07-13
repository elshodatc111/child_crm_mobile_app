import 'package:flutter/material.dart';
class ChildCreatePaymartPage extends StatelessWidget {
  final int child_id;
  const ChildCreatePaymartPage({super.key, required this.child_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("To'lov qilish"),),
      body: Text("To'lovlar"),
    );
  }
}
