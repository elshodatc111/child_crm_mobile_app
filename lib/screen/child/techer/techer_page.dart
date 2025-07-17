import 'dart:convert';
import 'package:child_app_drektor/const/api_const.dart';
import 'package:child_app_drektor/screen/child/techer/techer_show_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class TecherPage extends StatefulWidget {
  const TecherPage({super.key});

  @override
  State<TecherPage> createState() => _TecherPageState();
}

class _TecherPageState extends State<TecherPage> {
  List<dynamic> techers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTechers();
  }

  Future<void> fetchTechers() async {
    setState(() => isLoading = true);
    final baseUrl = ApiConst().apiUrl;
    final token = GetStorage().read('token');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/techers'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            techers = data['teachers'];
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

  Widget buildTeacherCard(dynamic teacher) {
    return InkWell(
      onTap: () {
        Get.to(() => TecherShowPage(id: teacher['id']));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue,width: 1.2),
          borderRadius: BorderRadius.all(Radius.circular(16))
        ),
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        teacher['fio'] ?? 'Ism yo‘q',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Chip(
                      backgroundColor: teacher['status'] == 'active'
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      label: Text(
                        teacher['status'] == 'active' ? 'Faol' : 'Faol emas',
                        style: TextStyle(
                          color: teacher['status'] == 'active'
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20, thickness: 1),

                // Phone
                Row(
                  children: [
                    const Icon(Icons.phone_android, size: 18, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text(
                      "Telefon:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        teacher['phone'] ?? '-',
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Address
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 18, color: Colors.orange),
                    const SizedBox(width: 8),
                    const Text(
                      "Manzil:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        teacher['address'] ?? '-',
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("O'qituvchilar"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : techers.isEmpty
          ? const Center(child: Text("O'qituvchilar topilmadi"))
          : RefreshIndicator(
        onRefresh: fetchTechers,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: techers.length,
          itemBuilder: (context, index) {
            return buildTeacherCard(techers[index]);
          },
        ),
      ),
    );
  }
}
