import 'dart:convert';

import 'package:child_app_drektor/const/api_const.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
class GroupCrateDavomadPage extends StatefulWidget {
  final int group_id;
  const GroupCrateDavomadPage({super.key, required this.group_id});

  @override
  State<GroupCrateDavomadPage> createState() => _GroupCrateDavomadPageState();
}

class _GroupCrateDavomadPageState extends State<GroupCrateDavomadPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Davomad olish"),),
    );
  }
}
