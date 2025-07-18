import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../const/api_const.dart';

class TecherCreateCommentPage extends StatefulWidget {
  final int id;

  const TecherCreateCommentPage({super.key, required this.id});

  @override
  State<TecherCreateCommentPage> createState() =>
      _TecherCreateCommentPageState();
}

class _TecherCreateCommentPageState extends State<TecherCreateCommentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();

  Future<void> _saveComment() async {
    if (!_formKey.currentState!.validate()) return;

    final token = GetStorage().read('token');
    final comment = _commentController.text.trim();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await http.post(
        Uri.parse("${ApiConst().apiUrl}/techer/create/comment"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id': widget.id,
          'comment': comment,
        }),
      );

      Navigator.of(context).pop(); // dismiss loading

      if (response.statusCode == 200) {
        // Qaytib TecherShowPage'dagi funksiyani yangilash
        Get.back(result: true); // result = true bilan qaytadi
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

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("O'qituvchi haqida izoh"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                TextFormField(
                  controller: _commentController,
                  maxLines: 5,
                  minLines: 3,
                  decoration: InputDecoration(
                    hintText: "O'qituvchi haqida izoh yozing...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.edit_note),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Iltimos, izoh kiriting';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveComment,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      "Saqlash",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
