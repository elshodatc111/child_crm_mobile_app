import '../../../../const/api_const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChildCommentPage extends StatefulWidget {
  final int child_id;
  final List<dynamic> comments;
  final VoidCallback onCommentsUpdated;

  const ChildCommentPage({
    super.key,
    required this.child_id,
    required this.comments,
    required this.onCommentsUpdated,
  });

  @override
  State<ChildCommentPage> createState() => _ChildCommentPageState();
}

class _ChildCommentPageState extends State<ChildCommentPage> {
  final TextEditingController _descController = TextEditingController();
  bool _isLoading = false;

  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd.MM.yyyy, HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Future<bool> _submitComment(String description) async {
    final baseUrl = ApiConst().apiUrl;
    final token = GetStorage().read('token');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/child/comment/create'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'child_id': widget.child_id,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final data = json.decode(response.body);
        String errorMessage = data['message'] ?? 'Xatolik yuz berdi';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.redAccent,
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Xatolik: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }
  }

  void _openAddCommentModal() {
    _descController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
                bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Izoh qo‘shish',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Izohni kiriting',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      modalSetState(
                        () {},
                      ); // Yozuv o'zgarganda tugmani yangilash uchun
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          (_isLoading || _descController.text.trim().isEmpty)
                              ? null
                              : () async {
                                modalSetState(() {
                                  _isLoading = true;
                                });
                                bool success = await _submitComment(
                                  _descController.text.trim(),
                                );
                                modalSetState(() {
                                  _isLoading = false;
                                });
                                if (success) {
                                  Navigator.of(modalContext).pop();
                                  Navigator.pop(context, true);
                                  widget.onCommentsUpdated();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Izoh muvaffaqiyatli qo‘shildi",
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                'Saqlash',
                                style: TextStyle(fontSize: 16),
                              ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Izohlar"),
        actions: [
          IconButton(
            onPressed: _openAddCommentModal,
            icon: const Icon(Icons.add_circle_outline_outlined),
          ),
        ],
      ),
      body:
          widget.comments.isEmpty
              ? const Center(
                child: Text(
                  "Izohlar mavjud emas",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: widget.comments.length,
                itemBuilder: (context, index) {
                  final comment = widget.comments[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.blue, width: 1.2),
                    ),
                    elevation: 2,
                    shadowColor: Colors.grey.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                comment['user'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.indigo,
                                ),
                              ),
                              Text(
                                formatDate(comment['created_at'].toString()),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            comment['description'].toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
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
