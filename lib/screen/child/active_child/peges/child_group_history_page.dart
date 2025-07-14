import 'dart:convert';

import 'package:child_app_drektor/const/api_const.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ChildGroupHistoryPage extends StatefulWidget {
  final int child_id;

  const ChildGroupHistoryPage({super.key, required this.child_id});

  @override
  State<ChildGroupHistoryPage> createState() => _ChildGroupHistoryPageState();
}

class _ChildGroupHistoryPageState extends State<ChildGroupHistoryPage> {
  List<dynamic> groups = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    setState(() {
      isLoading = true;
    });
    final baseUrl = ApiConst().apiUrl;
    final token = GetStorage().read('token');
    final id = widget.child_id;
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/child/groups/$id"),
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
        showMessage("Tarmoqli xatolik: ${response.statusCode}");
      }
    } catch (e) {
      showMessage("Xatolik: $e");
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Guruhlar tarixi")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : groups.isEmpty
              ? const Center(
                child: Text(
                  "To'lov ma`lumotlari topilmadi",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: groups.length,
                itemBuilder: (ctx, index) {
                  final group = groups[index];
                  return CardItem(group: group);
                },
              ),
    );
  }
}

class CardItem extends StatelessWidget {
  final Map<String, dynamic> group;

  const CardItem({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final bool isActive = group['status'] == "true";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: isActive ? Colors.green : Colors.red, width: 1.3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group['group_name'] ?? 'Nomaʼlum guruh',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            isActive
                ? _buildActiveGroup(
              group['start_time'],
              group['paymart_type'],
              group['start_manager'],
              group['start_comment'],
            )
                : _buildEndGroup(
              group['start_time'],
              group['end_time'],
              group['paymart_type'],
              group['start_manager'],
              group['end_manager'],
              group['start_comment'],
              group['end_comment'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveGroup(
      String start,
      String paymartType,
      String manager,
      String comment,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoRow(Icons.date_range, "Boshlanish vaqti", start),
        _infoRow(Icons.payment, "To‘lov turi", paymartType=='day'?"Kunlik":"Oylik"),
        _infoRow(Icons.person, "Qo‘shgan menejer", manager),
        _infoRow(Icons.comment, "Izoh", comment),
      ],
    );
  }

  Widget _buildEndGroup(
      String start,
      String end,
      String paymartType,
      String startManager,
      String endManager,
      String startComment,
      String endComment,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoRow(Icons.date_range, "Boshlanish vaqti", start),
        _infoRow(Icons.event_busy, "Yakunlangan vaqti", end),
        _infoRow(Icons.payment, "To‘lov turi", paymartType=='day'?"Kunlik":"Oylik"),
        _infoRow(Icons.person, "Qo‘shgan menejer", startManager),
        _infoRow(Icons.comment, "Qo‘shish izohi", startComment),
        const Divider(height: 20),
        _infoRow(Icons.person_off, "O‘chirish menejeri", endManager),
        _infoRow(Icons.comment_bank, "O‘chirish izohi", endComment),
      ],
    );
  }
}
