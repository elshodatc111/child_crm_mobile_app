import 'dart:convert';
import './../groups/group_show_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../const/api_const.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  List<dynamic> groups = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    setState(() => isLoading = true);

    final baseUrl = ApiConst().apiUrl;
    final token = GetStorage().read('token');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/groups'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            groups = data['groups'];
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchGroups,
        child: groups.isEmpty
            ? const Center(
          child: Text(
            "Guruhlar mavjud emas",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
            : ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            return GroupCard(group: group);
          },
        ),
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  final Map<String, dynamic> group;

  const GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final int group_id = group['id'] ?? 0;
    final String name = group['group_name'] ?? 'Nomaʼlum';
    final int count = group['user_count'] ?? 0;

    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(width: 1.2,color: Colors.blue)),
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.to(() => GroupShowPage(group_id: group_id));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.group, color: Colors.blue, size: 32),
            title: Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              "$count ta bola",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
          ),
        ),
      ),
    );
  }
}
