import 'dart:convert';
import '../../../const/api_const.dart';
import './page/group_all_child_page.dart';
import './page/group_crate_davomad_page.dart';
import './page/group_darslar_tarix_page.dart';
import './page/group_davomad_history_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class GroupShowPage extends StatefulWidget {
  final int group_id;
  const GroupShowPage({super.key, required this.group_id});

  @override
  State<GroupShowPage> createState() => _GroupShowPageState();
}

class _GroupShowPageState extends State<GroupShowPage> {
  Map<String, dynamic> about = {};
  List<dynamic> ish_kunlar = [];
  bool davomadStatus = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAbout();
  }

  Future<void> fetchAbout() async {
    setState(() {
      isLoading = true;
    });

    final baseUrl = ApiConst().apiUrl;
    final token = GetStorage().read('token');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/groups/show/${widget.group_id}'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            about = data['about'];
            ish_kunlar = data['ish_kunlar'];
            davomadStatus = data['davomad_status'];
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
      appBar: AppBar(title: const Text("Guruh haqida")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoCard("Guruh nomi:", about['group_name']),
            _infoCard("Tarbiyachi:", about['tarbiyachi']),
            _infoCard("Yordamchi tarbiyachi:", about['yordamchi']),
            _infoCard("Guruh turi:",about['group_type'] == 'olti'? "Haftasiga 6 kunlik": "Haftasiga 5 kunlik",),
            _infoCard("Oylik to'lov:","${NumberFormat('#,###', 'uz_UZ').format(about['price_month'])} so'm",),
            _infoCard("Kunlik to'lov:","${NumberFormat('#,###', 'uz_UZ').format(about['price_day'])} so'm",),

            const SizedBox(height: 16),

            Row(
              children: [
                _menuButton(
                  label: "Bolalar va Tarbiyachilar",
                  color: Colors.teal,
                  icon: Icons.group,
                  onTap: () {
                    Get.to(()=>GroupAllChildPage(group_id: widget.group_id));
                  },
                ),
                _menuButton(
                  label: "Davomad tarixi",
                  color: Colors.blue,
                  icon: Icons.access_time,
                  onTap: () {
                    Get.to(()=>GroupDavomadHistoryPage(group_id: widget.group_id));
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _menuButton(
                  label: "Darslar",
                  color: Colors.orange,
                  icon: Icons.menu_book,
                  onTap: () {
                    Get.to(()=>GroupDarslarTarixPage(group_id: widget.group_id));
                  },
                ),
                davomadStatus==true?_menuButton(
                  label: "Davomad olish",
                  color: Colors.red,
                  icon: Icons.check_circle,
                  onTap: () async {
                    final result = await Get.to(() => GroupCrateDavomadPage(group_id: widget.group_id));
                    if (result == true) {
                      fetchAbout();
                    }
                  },
                ):_menuButton(
                  label: "Davomad olindi",
                  color: Colors.green,
                  icon: Icons.check,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              "Ish kunlari",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...ish_kunlar.map((kun) {
              final today = DateTime.now();
              final sanasi = DateTime.tryParse(kun['sanasi']);
              Color borderColor = Colors.red;
              if (sanasi != null) {
                if (sanasi.year == today.year &&
                    sanasi.month == today.month &&
                    sanasi.day == today.day) {
                  borderColor = Colors.amber; // Bugungi
                } else if (sanasi.isBefore(today)) {
                  borderColor = Colors.green; // O‘tgan
                }
              }
              return Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: borderColor, width: 1.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(kun['sanasi']),
                    Text(kun['hafta_kuni'] ?? ''),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        border: const Border(bottom: BorderSide(color: Colors.blue, width: 1.2)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          Text(value,style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
        ],
      ),
    );
  }
  Widget _menuButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                    color: color, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
