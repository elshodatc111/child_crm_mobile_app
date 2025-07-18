import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../const/api_const.dart';

class TecherCreateLessinPage extends StatefulWidget {
  final int techer_id;
  const TecherCreateLessinPage({super.key, required this.techer_id});

  @override
  State<TecherCreateLessinPage> createState() => _TecherCreateLessinPageState();
}

class _TecherCreateLessinPageState extends State<TecherCreateLessinPage> {
  List<dynamic> groups = [];
  bool isLoading = true;

  int? selectedGroupId;
  final TextEditingController lessonNameController = TextEditingController();
  final TextEditingController childCountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchGroupsData();
  }

  Future<void> fetchGroupsData() async {
    final token = GetStorage().read('token');
    final url = Uri.parse('${ApiConst().apiUrl}/groups');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (!mounted) return;
        setState(() {
          groups = jsonData['groups'];
          isLoading = false;
        });
      } else {
        throw Exception("Xatolik: ${response.statusCode}");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xatolik: $e")),
      );
    }
  }

  Future<void> handleSubmit() async {
    final groupId = selectedGroupId;
    final lessonName = lessonNameController.text.trim();
    final childCount = int.tryParse(childCountController.text.trim());

    if (groupId == null || lessonName.isEmpty || childCount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Iltimos, barcha maydonlarni to‘ldiring")),
      );
      return;
    }

    final token = GetStorage().read('token');
    final url = Uri.parse('${ApiConst().apiUrl}/techer/create/lessin');

    // loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "group_id": groupId,
          "techer_id": widget.techer_id,
          "lesson_name": lessonName,
          "child_count": childCount,
        }),
      );

      Navigator.of(context).pop(); // dismiss loading

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // sahifani yopish
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dars muvaffaqiyatli yaratildi!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Xatolik: ${response.statusCode}")),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // dismiss loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xatolik: $e")),
      );
    }
  }

  InputDecoration _inputDecoration(String label, Icon icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yangi dars qo'shish"),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                decoration: _inputDecoration("Guruhni tanlang", const Icon(Icons.group)),
                items: groups.map<DropdownMenuItem<int>>((group) {
                  return DropdownMenuItem<int>(
                    value: group['id'],
                    child: Text("${group['group_name']} (${group['user_count']} ta bola)"),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGroupId = value;
                  });
                },
                value: selectedGroupId,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: lessonNameController,
                decoration: _inputDecoration("Dars nomi", const Icon(Icons.menu_book)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: childCountController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Bolalar soni", const Icon(Icons.people)),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: handleSubmit,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    "Saqlash",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
