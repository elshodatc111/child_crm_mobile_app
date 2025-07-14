import 'dart:convert';
import '../../../../const/api_const.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ChildDavomadHistoryPage extends StatefulWidget {
  final int child_id;

  const ChildDavomadHistoryPage({super.key, required this.child_id});

  @override
  State<ChildDavomadHistoryPage> createState() =>
      _ChildDavomadHistoryPageState();
}

class _ChildDavomadHistoryPageState extends State<ChildDavomadHistoryPage> {
  List<dynamic> davomad = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDavomad();
  }

  Future<void> fetchDavomad() async {
    setState(() {
      isLoading = true;
    });
    final baseUrl = ApiConst().apiUrl;
    final token = GetStorage().read('token');
    final id = widget.child_id;
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/child/davomad/$id"),
        headers: {'Authorization': 'Bearer $token'},
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            davomad = data['attendance'];
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
      appBar: AppBar(title: Text("Davomad tarixi")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : davomad.isEmpty
              ? const Center(
                child: Text(
                  "To'lov ma`lumotlari topilmadi",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: davomad.length,
                itemBuilder: (ctx, index) {
                  final davomatItem = davomad[index];
                  return DavomadItem(davomatItem: davomatItem);
                },
              ),
    );
  }
}

class DavomadItem extends StatelessWidget {
  final Map<String, dynamic> davomatItem;

  const DavomadItem({super.key, required this.davomatItem});

  String formatDate(String raw) {
    try {
      final parsed = DateTime.parse(raw);
      return DateFormat('yyyy-MM-dd HH:mm').format(parsed);
    } catch (_) {
      return raw;
    }
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'keldi':
        return Colors.green;
      case 'kelmadi':
        return Colors.red;
      case 'kech keldi':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'keldi':
        return Icons.check_circle;
      case 'kelmadi':
        return Icons.cancel;
      case 'kech keldi':
        return Icons.access_time;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = davomatItem['status'] ?? '';
    final guruh = davomatItem['guruh'] ?? '';
    final data = davomatItem['data'] ?? '';
    final amount = davomatItem['amount'] ?? 0;
    final meneger = davomatItem['meneger'] ?? '';
    final createdAt = davomatItem['created_at'] ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor(status), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Sarlavha (guruh va status)
          Row(
            children: [
              Icon(statusIcon(status), color: statusColor(status), size: 22),
              const SizedBox(width: 8),
              Text(
                guruh,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor(status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor(status),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Sana va to‘lov miqdori
          Row(
            children: [
              const Icon(Icons.calendar_month, size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                "Sana: ",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(data),
              const Spacer(),
              const Icon(Icons.monetization_on, size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                NumberFormat.decimalPattern().format(amount) + " so'm",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Menejer va yaratilgan vaqt
          Row(
            children: [
              const Icon(Icons.person, size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              Text("Menejer: "),
              Text(meneger),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(Icons.access_time, size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              Text("Yaratilgan: "),
              Text(formatDate(createdAt)),
            ],
          ),
        ],
      ),
    );
  }
}
