import 'dart:convert';
import 'package:child_app_drektor/const/api_const.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // sana formatlash uchun

class TecherLessinPage extends StatefulWidget {
  final int id;
  const TecherLessinPage({super.key, required this.id});

  @override
  State<TecherLessinPage> createState() => _TecherLessinPageState();
}

class _TecherLessinPageState extends State<TecherLessinPage> {
  bool isLoading = true;
  List<dynamic> lessin = [];

  @override
  void initState() {
    super.initState();
    fetchLessinData();
  }

  Future<void> fetchLessinData() async {
    final token = GetStorage().read('token');
    final url =
    Uri.parse('${ApiConst().apiUrl}/techer/show/lessin/${widget.id}');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          lessin = jsonData['res'];
          isLoading = false;
        });
      } else {
        throw Exception("Xatolik: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xatolik: $e")),
      );
    }
  }

  String formatDate(String dateStr) {
    try {
      DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Darslar tarixi"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : lessin.isEmpty
          ? const Center(child: Text("Darslar topilmadi."))
          : ListView.builder(
        itemCount: lessin.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final item = lessin[index];
          return Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.blue,width: 1.2)
            ),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.school, color: Colors.blue),
              ),
              title: Text(
                item['lesson_name'] ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.groups, size: 16),
                      const SizedBox(width: 4),
                      Expanded(child: Text(item['group_name'] ?? '')),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16),
                      const SizedBox(width: 4),
                      Text("Menejer: ${item['meneger'] ?? ''}"),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.numbers, size: 16),
                      const SizedBox(width: 4),
                      Text("O'quvchilar soni: ${item['child_count']}"),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Text("Sana: ${formatDate(item['created_at'])}"),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
