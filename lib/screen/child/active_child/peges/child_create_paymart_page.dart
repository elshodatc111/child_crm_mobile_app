import 'dart:convert';
import 'package:flutter/material.dart';

class ChildCreatePaymartPage extends StatefulWidget {
  final int child_id;
  final VoidCallback onCommentsUpdated;

  const ChildCreatePaymartPage({
    super.key,
    required this.child_id,
    required this.onCommentsUpdated,
  });

  @override
  State<ChildCreatePaymartPage> createState() => _ChildCreatePaymartPageState();
}

class _ChildCreatePaymartPageState extends State<ChildCreatePaymartPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("To'lov qilish")),
      body: Text("To'lovlar"),
    );
  }
}
