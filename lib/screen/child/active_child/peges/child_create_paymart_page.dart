import 'dart:convert';

import 'package:child_app_drektor/const/api_const.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ChildCreatePaymartPage extends StatefulWidget {
  final int child_id;
  final VoidCallback onCommentsUpdated;
  const ChildCreatePaymartPage({super.key, required this.child_id, required this.onCommentsUpdated});
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
