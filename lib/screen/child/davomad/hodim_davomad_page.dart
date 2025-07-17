import 'dart:convert';
import 'package:child_app_drektor/const/api_const.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class HodimDavomadPage extends StatefulWidget {
  const HodimDavomadPage({super.key});

  @override
  State<HodimDavomadPage> createState() => _HodimDavomadPageState();
}

class _HodimDavomadPageState extends State<HodimDavomadPage> {
  List<dynamic> hodimlar = [];
  Map<int, String> selectedStatuses = {};
  bool isLoading = true;
  bool isSaving = false;

  final statusOptions = {
    'present': '✅ Keldi',
    'absent': '❌ Kelmadi',
    'late': '⏰ Kech keldi',
    'no_uniform': '👕 Formasiz',
    'off_day': '📅 Dam olish',
  };

  @override
  void initState() {
    super.initState();
    fetchHodimlar();
  }

  Future<void> fetchHodimlar() async {
    final token = GetStorage().read('token');
    final response = await http.get(
      Uri.parse("${ApiConst().apiUrl}/hodimlar"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> result = data['result'];

      // Avtomatik selectedStatuses ni to'ldirish
      for (var item in result) {
        if (item['davomad'] != null && item['davomad'] != 'olinmadi') {
          selectedStatuses[item['user_id']] = item['davomad'];
        }
      }

      setState(() {
        hodimlar = result;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xatolik yuz berdi: ${response.statusCode}")),
      );
    }
  }

  Future<void> saveStatuses() async {
    setState(() => isSaving = true);
    final token = GetStorage().read("token");

    Map<String, String> statusesJson = {
      for (var entry in selectedStatuses.entries)
        entry.key.toString(): entry.value,
    };

    final url = Uri.parse("${ApiConst().apiUrl}/hodimlar/davomad");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'statuses': statusesJson}),
      );

      if (response.statusCode == 200) {
        showMessage('Davomadlar saqlandi!');
        await fetchHodimlar();
      } else {
        showMessage('Tarmoqli xatolik: ${response.statusCode}');
      }
    } catch (e) {
      showMessage('Xatolik: ${e.toString()}');
    }

    setState(() => isSaving = false);
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  bool get allSelected => selectedStatuses.length == hodimlar.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hodimlar davomadi")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: hodimlar.length,
                      itemBuilder: (context, index) {
                        final hodim = hodimlar[index];
                        final userId = hodim['user_id'];
                        final oldStatus = hodim['davomad'];

                        return Card(
                          color: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: Colors.blue,
                              width: 1.2,
                            ),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      hodim['username'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      getRoleName(hodim['type']),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: getRoleColor(hodim['type']),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                if (oldStatus != null &&
                                    oldStatus != 'olinmadi')
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      "Saqlangan holat: ${statusOptions[oldStatus] ?? oldStatus}",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.orange.shade700,
                                      ),
                                    ),
                                  ),
                                Wrap(
                                  spacing: 4,
                                  runSpacing: -8,
                                  children:
                                      statusOptions.entries.map((entry) {
                                        final isSelected =
                                            selectedStatuses[userId] ==
                                            entry.key;
                                        return ChoiceChip(
                                          label: Text(entry.value),
                                          selected: isSelected,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 14,
                                          ),
                                          onSelected: (_) {
                                            setState(() {
                                              selectedStatuses[userId] =
                                                  entry.key;
                                            });
                                          },
                                          selectedColor: Colors.green.shade300,
                                          backgroundColor: Colors.grey.shade200,
                                          labelStyle: TextStyle(
                                            color:
                                                isSelected
                                                    ? Colors.black
                                                    : Colors.grey[800],
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed:
                            !allSelected || isSaving ? null : saveStatuses,
                        icon:
                            isSaving
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.orange,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Icon(Icons.save,size: 20,color: Colors.white,),
                        label:
                            isSaving
                                ? Text(
                                  "Saqlanmoqda",
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                                : Text(
                                  "Saqlash",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  String getRoleName(String type) {
    switch (type) {
      case 'tarbiyachi':
        return 'Tarbiyachi';
      case 'kichik_tarbiyachi':
        return 'Yordamchi Tarbiyachi';
      case 'menejer':
        return 'Menejer';
      case 'oshpaz':
        return 'Oshpaz';
      default:
        return 'Hodim';
    }
  }

  Color getRoleColor(String type) {
    switch (type) {
      case 'tarbiyachi':
        return Colors.blue.shade400;
      case 'kichik_tarbiyachi':
        return Colors.indigo.shade400;
      case 'menejer':
        return Colors.green.shade400;
      case 'oshpaz':
        return Colors.orange.shade400;
      default:
        return Colors.teal.shade400;
    }
  }
}
