import './peges/child_comment_page.dart';
import './peges/child_create_paymart_page.dart';
import './peges/child_davomad_history_page.dart';
import './peges/child_group_history_page.dart';
import './peges/child_qarindosh_page.dart';
import './peges/child_show_paymart_page.dart';
import './widget/child_about_view_page.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../const/api_const.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ChildShowPage extends StatefulWidget {
  final int id;

  const ChildShowPage({super.key, required this.id});

  @override
  State<ChildShowPage> createState() => _ChildShowPageState();
}

class _ChildShowPageState extends State<ChildShowPage> {
  Map<String, dynamic>? about;
  List<dynamic> parents = [];
  List<dynamic> comments = [];
  bool isLoading = true;
  final String type = GetStorage().read('user')['type'] ?? '';


  @override
  void initState() {
    super.initState();
    fetchChildren();
  }

  Future<void> fetchChildren() async {
    setState(() {
      isLoading = true;
    });

    final baseUrl = ApiConst().apiUrl;
    final token = GetStorage().read('token');
    final id = widget.id;
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/child/$id"),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            about = data['about'];
            parents = data['parents'];
            comments = data['comments'];
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

  Future<void> launchPhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Telefon raqam ochilmadi: $phoneNumber';
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
      appBar: AppBar(
        title: Text(
          isLoading ? "Yuklanmoqda..." : about?['name'] ?? "Bola haqida",
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ChildAboutViewPage(about: about!),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                width: Get.width * 0.45,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    if (about!['phone1'] != null) {
                                      launchPhoneCall(about!['phone1']);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.phone_in_talk,
                                    color: Colors.blue,
                                  ),
                                  label: const Text("Qo'ng'iroq (Tel1)"),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.blue),
                                    foregroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              SizedBox(
                                width: Get.width * 0.45,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => ChildCommentPage(
                                              child_id: widget.id,
                                              comments: comments,
                                              onCommentsUpdated: () async {
                                                await fetchChildren();
                                              },
                                            ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.comment,
                                    color: Colors.blue,
                                  ),
                                  label: const Text("Izohlar"),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.blue),
                                    foregroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              SizedBox(
                                width: Get.width * 0.45,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Get.to(
                                      () => ChildGroupHistoryPage(
                                        child_id: widget.id,
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.history_edu,
                                    color: Colors.purple,
                                  ),
                                  label: const Text("Guruhlar tarixi"),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Colors.purple,
                                    ),
                                    foregroundColor: Colors.purple,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              type=='tarbiyachi'?Text(''):type=='kichik_tarbiyachi'?Text(""):SizedBox(
                                width: Get.width * 0.45,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Get.to(
                                          () => ChildShowPaymartPage(
                                        child_id: widget.id,
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.payment,
                                    color: Colors.orange,
                                  ),
                                  label: const Text("To‘lovlar"),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Colors.orange,
                                    ),
                                    foregroundColor: Colors.orange,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                width: Get.width * 0.45,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    if (about!['phone2'] != null) {
                                      launchPhoneCall(about!['phone2']);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.phone_forwarded,
                                    color: Colors.blue,
                                  ),
                                  label: const Text("Qo'ng'iroq (Tel2)"),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.blue),
                                    foregroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              SizedBox(
                                width: Get.width * 0.45,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => ChildQarindoshPage(
                                          child_id: widget.id,
                                          parents: parents,
                                          onCommentsUpdated: () async {
                                            await fetchChildren();
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.group,
                                    color: Colors.green,
                                  ),
                                  label: const Text("Yaqin qarindoshlar"),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.green),
                                    foregroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              SizedBox(
                                width: Get.width * 0.45,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Get.to(
                                      () => ChildDavomadHistoryPage(
                                        child_id: widget.id,
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.event_available,
                                    color: Colors.teal,
                                  ),
                                  label: const Text("Davomad tarixi"),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.teal),
                                    foregroundColor: Colors.teal,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              type=='tarbiyachi'?Text(''):type=='kichik_tarbiyachi'?Text(""):SizedBox(
                                width: Get.width * 0.45,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Get.to(
                                          () => ChildCreatePaymartPage(
                                        child_id: widget.id,
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.attach_money,
                                    color: Colors.orange,
                                  ),
                                  label: const Text("To‘lov qilish"),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Colors.orange,
                                    ),
                                    foregroundColor: Colors.orange,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }
}
