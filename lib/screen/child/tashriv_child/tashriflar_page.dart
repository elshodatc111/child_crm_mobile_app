import 'dart:convert';
import 'package:child_app_drektor/screen/child/tashriv_child/tashrif_show_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../const/api_const.dart';
import './create_tashrif_page.dart';

class TashriflarPage extends StatefulWidget {
  const TashriflarPage({super.key});

  @override
  State<TashriflarPage> createState() => _TashriflarPageState();
}

class _TashriflarPageState extends State<TashriflarPage> {
  List<dynamic> allTashrifs = [];
  List<dynamic> filteredTashrifs = [];
  final TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTashrifs();
    searchController.addListener(() => filterTashrifs(searchController.text));
  }

  Future<void> fetchTashrifs() async {
    try {
      final token = GetStorage().read("token");
      final api = ApiConst().apiUrl;
      final response = await http.get(
        Uri.parse("$api/tashrif"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          allTashrifs = data["users"];
          filteredTashrifs = allTashrifs;
          isLoading = false;
        });
      } else {
        throw Exception("Ma'lumotlarni olishda xatolik");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xatolik: $e")),
      );
      setState(() => isLoading = false);
    }
  }

  void filterTashrifs(String query) {
    setState(() {
      filteredTashrifs = allTashrifs.where(
            (item) => item["name"]
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()),
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tashriflar"),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const CreateTashrifPage())?.then((result) {
                if (result == true) {
                  fetchTashrifs();
                }
              });
            },
            icon: const Icon(Icons.person_add),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(backgroundColor: Colors.white,color: Colors.blue,))
          : RefreshIndicator(
        onRefresh: fetchTashrifs,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: "Ism bo‘yicha qidiring...",
                    icon: Icon(Icons.search, color: Colors.blueAccent),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: filteredTashrifs.isEmpty
                    ? const Center(child: Text("Ma'lumot topilmadi"))
                    : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: filteredTashrifs.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final tashrif = filteredTashrifs[index];
                    final statusColor =
                    tashrif['status'] == 'success'
                        ? Colors.green
                        : tashrif['status'] == 'new'
                        ? Colors.blue
                        : tashrif['status'] == 'cancel'
                        ? Colors.red
                        : Colors.orange;
                    return Card(
                      elevation: 2,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Colors.blue,
                          width: 1.2,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        leading: CircleAvatar(
                          backgroundColor:
                          statusColor.withOpacity(0.2),
                          child: Icon(Icons.person,
                              color: statusColor),
                        ),
                        title: Text(
                          tashrif['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                          "Holat: ${tashrif['status'] == 'new' ? "Yangi" : tashrif['status'] == 'success' ? "Qabul qilindi" : tashrif['status'] == 'cancel' ? "Bekor qilindi" : "Jarayonda"}",
                          style: TextStyle(
                            color: statusColor,
                          ),
                        ),
                        trailing: Icon(Icons.chevron_right,
                            color: Colors.grey[600]),
                        onTap: () {
                          Get.to(() => TashrifShowPage(
                            id: tashrif['id'],
                            status: tashrif['status'],
                          ))?.then((result) {
                            if (result == true) {
                              fetchTashrifs();
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
