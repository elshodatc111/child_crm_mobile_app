import 'dart:convert';
import '../../../const/api_const.dart';
import './widget/active_child.dart';
import './widget/active_tarbiyachi_widget.dart';
import './widget/block_child.dart';
import './widget/block_tarbiyachi_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class GroupAllChildPage extends StatefulWidget {
  final int group_id;

  const GroupAllChildPage({super.key, required this.group_id});

  @override
  State<GroupAllChildPage> createState() => _GroupAllChildPageState();
}

class _GroupAllChildPageState extends State<GroupAllChildPage>
    with SingleTickerProviderStateMixin {
  List<dynamic> child = [];
  List<dynamic> tarbiyachilar = [];
  bool isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchChild();
  }

  Future<void> fetchChild() async {
    setState(() {
      isLoading = true;
    });

    final baseUrl = ApiConst().apiUrl;
    final token = GetStorage().read('token');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/groups/child/${widget.group_id}'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            child = data['child'];
            tarbiyachilar = data['tarbiyachi'];
            isLoading = false;
          });
        } else {
          showMessage(data['message'] ?? 'Xatolik yuz berdi');
        }
      } else {
        showMessage('Tarmoqli xatolik: ${response.statusCode}');
      }
    } catch (e) {
      showMessage('Xatolik: $e');
    }

    setState(() => isLoading = false);
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildChildList() {
    return ListView.builder(
      itemCount: child.length,
      padding: EdgeInsets.all(12.0),
      itemBuilder: (context, index) {
        final item = child[index];
        return item['status'] == 'true'
            ? ActiveChild(
          item['child'],
          item['balans'],
          item['start_time'],
          item['paymart_type'],
        )
            : BlockChild(
          item['child'],
          item['balans'],
          item['start_time'],
          item['paymart_type'],
          item['end_time'],
          item['end_comment'],
        );
      },
    );
  }

  Widget buildTarbiyachiList() {
    return ListView.builder(
      itemCount: tarbiyachilar.length,
      itemBuilder: (context, index) {
        final item = tarbiyachilar[index];
        return item['status'] == 1
            ? ActiveTarbiyachiWidget(
              item['tarbiyachi'],
              item['start_time'],
              item['type'],
            )
            : BlockTarbiyachiWidget(
              item['tarbiyachi'],
              item['start_time'],
              item['end_time'],
              item['type'],
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Bolalar va Tarbiyachilar"),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                icon: Icon(Icons.child_care, color: Colors.white),
                child: Text(
                  "Bolalar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Tab(
                icon: Icon(Icons.people_outline, color: Colors.white),
                child: Text(
                  "Tarbiyachilar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                  controller: _tabController,
                  children: [buildChildList(), buildTarbiyachiList()],
                ),
      ),
    );
  }
}
