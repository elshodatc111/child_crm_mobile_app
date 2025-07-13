import 'dart:convert';
import '../../../const/api_const.dart';
import './card/tashrif_about_card.dart';
import './card/tashrif_show_comments.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class TashrifShowPage extends StatefulWidget {
  final int id;
  final String status;
  const TashrifShowPage({super.key, required this.id, required this.status});

  @override
  State<TashrifShowPage> createState() => _TashrifShowPageState();
}

class _TashrifShowPageState extends State<TashrifShowPage> {
  Map<String, dynamic>? user;
  List<dynamic> comments = [];
  List<dynamic> groups = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTashrifData();
  }

  Future<void> fetchTashrifData() async {
    final token = GetStorage().read('token');
    final baseUrl = ApiConst().apiUrl;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/tashrif/show/${widget.id}"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          user = data["user"];
          comments = data["comments"];
          groups = data["groups"];
          isLoading = false;
        });
      } else {
        throw Exception("Xatolik: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Xatolik: $e")));
      setState(() {
        isLoading = false;
      });
    }
  }

  void showCommentModal() {
    final TextEditingController commentController = TextEditingController();
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Eslatma qo‘shish",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: commentController,
                    maxLines: 4,
                    onChanged: (_) => setModalState(() {}),
                    decoration: InputDecoration(
                      labelText: "Eslatma matni",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      fillColor: Colors.grey[100],
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          commentController.text.trim().isEmpty || isSaving
                              ? null
                              : () async {
                                setModalState(() {
                                  isSaving = true;
                                });

                                bool success = await sendComment(
                                  commentController.text.trim(),
                                );

                                setModalState(() {
                                  isSaving = false;
                                });

                                if (success) {
                                  Navigator.pop(context);
                                  await fetchTashrifData();
                                }
                              },
                      icon:
                          isSaving
                              ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                              : const Icon(Icons.send),
                      label: Text(isSaving ? "Yuborilmoqda..." : "Saqlash"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<bool> sendComment(String description) async {
    final token = GetStorage().read("token");
    final api = "https://atko.tech/child_app/public/api";

    try {
      final response = await http.post(
        Uri.parse("$api/tashrif/create/comment"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "vacancy_child_id": widget.id,
          "description": description,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "Eslatma qo‘shildi"),
            backgroundColor: Colors.green,
          ),
        );
        return true;
      } else {
        throw Exception(data["message"] ?? "Xatolik yuz berdi");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Xatolik: $e")));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tashrif haqida"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: fetchTashrifData,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TashrifAboutCard(
                        id: user?["id"],
                        name: user?["name"],
                        about: user?["description"],
                        addres: user?["addres"],
                        dates: user?["created_at"],
                        meneger: user?["meneger"],
                        phone1: user?["phone1"],
                        phone2: user?["phone2"],
                        onRefresh: fetchTashrifData,
                        status: widget.status,
                        groups: groups,
                      ),
                      SizedBox(height: 8.0,),
                      Container(
                        width: double.infinity,
                        color: Colors.blue.shade100,
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Tashrif haqida eslatmalar",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: showCommentModal,
                              icon: const Icon(
                                Icons.add_circle_outline_sharp,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.40,
                        child: TashrifShowComments(comments: comments),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
