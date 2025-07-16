import 'dart:convert';
import '../../../../const/api_const.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class GroupDarslarTarixPage extends StatefulWidget {
  final int group_id;

  const GroupDarslarTarixPage({super.key, required this.group_id});

  @override
  State<GroupDarslarTarixPage> createState() => _GroupDarslarTarixPageState();
}

class _GroupDarslarTarixPageState extends State<GroupDarslarTarixPage> {
  bool isLoading = true;
  List<dynamic> darslar = [];

  @override
  void initState() {
    super.initState();
    fetchDarslar();
  }

  Future<void> fetchDarslar() async {
    setState(() => isLoading = true);
    final token = GetStorage().read('token');
    final url = '${ApiConst().apiUrl}/groups/darslar/${widget.group_id}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            darslar = data['darslar'];
            isLoading = false;
          });
        }
      } else {
        throw Exception("Xatolik: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xatolik: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Darslar tarixi")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : darslar.isEmpty
              ? const Center(child: Text("Hech qanday dars topilmadi."))
              : RefreshIndicator(
                onRefresh: fetchDarslar,
                child: ListView.builder(
                  itemCount: darslar.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final item = darslar[index];
                    final date = DateFormat(
                      'yyyy-MM-dd – kk:mm',
                    ).format(DateTime.parse(item['created_at'] ?? ''));

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.blue, width: 1.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.book_outlined,
                                  color: Colors.teal,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item['dars'] ?? "Noma'lum dars",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text("O'qituvchi: ${item['techer'] ?? '-'}"),
                            Text("Darslar soni: ${item['count'] ?? 0}"),
                            Text("Meneger: ${item['meneger'] ?? '-'}"),
                            Text("Sanasi: $date"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
