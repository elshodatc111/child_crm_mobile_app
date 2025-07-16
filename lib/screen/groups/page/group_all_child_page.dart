import 'dart:convert';
import 'package:child_app_drektor/const/api_const.dart';
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
        return Container(
          margin: EdgeInsets.only(bottom: 8.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1.2,
              color: item['status'] == 'true' ? Colors.green : Colors.red,
            ),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child:
              item['status'] == 'true'
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
                  ),
        );
      },
    );
  }

  Widget BlockChild(
    String name,
    int balans,
    String start_time,
    String paymart_type,
    String end_time,
    String commint,
  ) {
    final numberFormat = NumberFormat("#,##0", "uz_UZ");
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.person_outline, color: Colors.teal),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.orange,
                ),
                Text(
                  "Balans:",
                  // ✅ Formatlangan
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            Text(
              "${numberFormat.format(balans)} so'm",
              // ✅ Formatlangan
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.payment_outlined, color: Colors.purple),
                Text("To‘lov turi:", style: const TextStyle(fontSize: 16)),
              ],
            ),
            Text(
              "${paymart_type == "day" ? "Kunlik" : "Oylik"}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.access_time_filled_outlined,
                  color: Colors.blue,
                ),
                Text("Ro'yhatga olindi:", style: const TextStyle(fontSize: 16)),
              ],
            ),
            Text(
              "${start_time}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.access_time_filled_outlined,
                  color: Colors.blue,
                ),
                Text("Guruhdan o'chirildi:", style: const TextStyle(fontSize: 16)),
              ],
            ),
            Text(
              "${end_time}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.access_time_filled_outlined,
                  color: Colors.blue,
                ),
                Text("Izoh:", style: const TextStyle(fontSize: 16)),
              ],
            ),
            Text(
              "${commint}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget ActiveChild(
    String name,
    int balans,
    String start_time,
    String paymart_type,
  ) {
    final numberFormat = NumberFormat("#,##0", "uz_UZ");
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.person_outline, color: Colors.teal),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.orange,
                ),
                Text(
                  "Balans:",
                  // ✅ Formatlangan
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            Text(
              "${numberFormat.format(balans)} so'm",
              // ✅ Formatlangan
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.payment_outlined, color: Colors.purple),
                Text("To‘lov turi:", style: const TextStyle(fontSize: 16)),
              ],
            ),
            Text(
              "${paymart_type == "day" ? "Kunlik" : "Oylik"}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.access_time_filled_outlined,
                  color: Colors.blue,
                ),
                Text("Ro'yhatga olindi:", style: const TextStyle(fontSize: 16)),
              ],
            ),
            Text(
              "${start_time.split(' ')[0]}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),

        // Paymart type
      ],
    );
  }

  Widget buildTarbiyachiList() {
    return ListView.builder(
      itemCount: tarbiyachilar.length,
      itemBuilder: (context, index) {
        final item = tarbiyachilar[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: Icon(
              item['type'] == 'tarbiyachi'
                  ? Icons.person_outline
                  : Icons.group_outlined,
              color: Colors.indigo,
            ),
            title: Text(item['tarbiyachi']),
            subtitle: Text("Turi: ${item['type']}"),
            trailing:
                item['status'] == 1
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.cancel, color: Colors.red),
          ),
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
