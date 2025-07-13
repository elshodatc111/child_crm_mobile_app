import 'dart:convert';
import './childs_item_card.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../const/api_const.dart';

class ActiveChildPage extends StatefulWidget {
  const ActiveChildPage({super.key});

  @override
  State<ActiveChildPage> createState() => _ActiveChildPageState();
}

class _ActiveChildPageState extends State<ActiveChildPage> {
  List<dynamic> allChildren = [];
  List<dynamic> filteredChildren = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchChildren();
  }

  Future<void> fetchChildren() async {
    final baseUrl = ApiConst().apiUrl;
    final token = GetStorage().read('token');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/childs'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            allChildren = data['children'];
            filteredChildren = allChildren;
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

  void onSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredChildren =
          allChildren.where((child) {
            final name = (child['name'] ?? '').toLowerCase();
            final group = (child['group_name'] ?? '').toLowerCase();
            return name.contains(searchQuery) || group.contains(searchQuery);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aktiv bolalar"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Container(
                    color: Colors.blue,
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      onChanged: onSearch,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Ism yoki guruh bo‘yicha qidiring',
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(vertical: 4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                        filteredChildren.isEmpty
                            ? const Center(
                              child: Text("Hech qanday bola topilmadi."),
                            )
                            : ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: filteredChildren.length,
                              itemBuilder: (context, index) {
                                final child = filteredChildren[index];
                                final balansColor =
                                    child['balans'] >= 0
                                        ? Colors.green
                                        : Colors.red;
                                return ChildsItemCard(
                                  id: child['id'],
                                  name: child['name'],
                                  birthday: child['birthday'],
                                  group_name: child['group_name'],
                                  balans: child['balans'],
                                  balansColor: balansColor,
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }
}

