import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../const/api_const.dart';

class TecherShowPage extends StatefulWidget {
  final int id;
  const TecherShowPage({super.key, required this.id});

  @override
  State<TecherShowPage> createState() => _TecherShowPageState();
}

class _TecherShowPageState extends State<TecherShowPage> {
  Map<String, dynamic>? data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTecherData();
  }

  Future<void> fetchTecherData() async {
    final token = GetStorage().read('token');
    final url = Uri.parse('${ApiConst().apiUrl}/techer/show/${widget.id}');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          data = jsonData;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("O'qituvchi haqida"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : data == null
          ? const Center(child: Text("Ma'lumotlar topilmadi"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(theme),
            const SizedBox(height: 16),
            _buildActionButtons(),
            const SizedBox(height: 24),
            _buildCommentSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(ThemeData theme) {
    final about = data!['about'];
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.blue, width: 1.2),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(about['fio'] ?? '', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.phone, "Telefon", about['phone']),
            _buildInfoRow(Icons.email_outlined, "Email", about['email']),
            _buildInfoRow(Icons.location_on, "Manzil", about['address']),
            _buildInfoRow(Icons.calendar_today, "Tug'ilgan kun", about['tkun']),
            const SizedBox(height: 16),
            const Text("📊 Joriy oy statistikasi",
                style: TextStyle(color: Colors.deepOrange, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statCard("Darslar soni", data!['count']['darslar']),
                _statCard("Bolalar soni", data!['count']['child']),
                _statCard("To'langan", "${data!['tulov']} so'm"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 6),
          Expanded(child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.w500))),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _statCard(String title, dynamic value) {
    return Card(
      color: Colors.lightBlue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: Get.width * 0.264,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Text(value.toString(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 4),
            Text(title, textAlign: TextAlign.center,style:TextStyle(fontSize: 8),),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Add comment function
            },
            icon: const Icon(Icons.comment_outlined),
            label: const Text("Izoh qoldirish"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Lessons history
            },
            icon: const Icon(Icons.history),
            label: const Text("Darslar tarixi"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Add new lesson
            },
            icon: const Icon(Icons.add_circle_outline),
            label: const Text("Yangi dars qo'shish"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentSection(ThemeData theme) {
    final List comments = data!['UserComment'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Text("🗒 Izohlar", style: theme.textTheme.titleLarge)),
        const SizedBox(height: 8),
        if (comments.isEmpty)
          const Center(child: Text("Izohlar mavjud emas"))
        else
          ...comments.map((comment) {
            final formattedDate =
            DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(comment['created_at']));
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.blue, width: 1),
              ),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("👤 ${comment['meneger']}"),
                    Text(formattedDate, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(comment['comment'], style: const TextStyle(fontSize: 16)),
                ),
              ),
            );
          }).toList(),
      ],
    );
  }
}
