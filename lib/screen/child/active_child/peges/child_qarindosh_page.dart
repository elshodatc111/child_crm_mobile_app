import 'package:child_app_drektor/const/api_const.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class ChildQarindoshPage extends StatefulWidget {
  final int child_id;
  final List<dynamic> parents;
  final VoidCallback onCommentsUpdated;

  const ChildQarindoshPage({
    super.key,
    required this.child_id,
    required this.parents,
    required this.onCommentsUpdated,
  });

  @override
  State<ChildQarindoshPage> createState() => _ChildQarindoshPageState();
}

class _ChildQarindoshPageState extends State<ChildQarindoshPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  final maskFormatter = MaskTextInputFormatter(
    mask: '+998 ## ### ####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  Future<void> _showAddRelativeModal() async {
    _nameController.clear();
    _phoneController.text = '+998 ';
    bool isNameValid = false;
    bool isPhoneValid = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            void validate() {
              final name = _nameController.text.trim();
              final rawPhone = maskFormatter.getUnmaskedText();
              modalSetState(() {
                isNameValid = name.isNotEmpty;
                isPhoneValid = rawPhone.length == 9;
              });
            }

            Future<void> submit() async {
              if (!isNameValid || !isPhoneValid) return;
              modalSetState(() => _isLoading = true);

              final token = GetStorage().read('token');
              final baseUrl = ApiConst().apiUrl;

              try {
                final response = await http.post(
                  Uri.parse('$baseUrl/child/qarindosh/create'),
                  headers: {
                    'Authorization': 'Bearer $token',
                    'Content-Type': 'application/json',
                  },
                  body: json.encode({
                    'child_id': widget.child_id,
                    'name': _nameController.text.trim(),
                    'phone': _phoneController.text.trim(),
                  }),
                );

                if (response.statusCode == 200) {
                  Navigator.of(context).pop(); // modal
                  Navigator.pop(context, true);
                  widget.onCommentsUpdated();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Qarindosh muvaffaqiyatli qo‘shildi"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  final data = json.decode(response.body);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(data['message'] ?? 'Xatolik yuz berdi'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Xatolik: $e"),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              } finally {
                modalSetState(() => _isLoading = false);
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Yaqin qarindosh qo‘shish',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    onChanged: (_) => validate(),
                    enabled: !_isLoading,
                    decoration: const InputDecoration(
                      labelText: 'Ism Familiya',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    inputFormatters: [maskFormatter],
                    keyboardType: TextInputType.phone,
                    onChanged: (_) => validate(),
                    enabled: !_isLoading,
                    decoration: const InputDecoration(
                      labelText: 'Telefon raqami',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          (isNameValid && isPhoneValid && !_isLoading)
                              ? submit
                              : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.blue,width: 1.2)
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Text(
                                'Saqlash',
                                style: TextStyle(fontSize: 16,color: Colors.white),
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
        title: const Text("Yaqin Qarindoshlar"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _showAddRelativeModal,
          ),
        ],
      ),
      body:
          widget.parents.isEmpty
              ? const Center(
                child: Text(
                  "Yaqin qarindoshlar mavjud emas",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: widget.parents.length,
                itemBuilder: (context, index) {
                  final parent = widget.parents[index];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.blue, width: 1.2),
                    ),
                    elevation: 2,
                    child: ListTile(
                      title: Text(parent['name'] ?? ''),
                      subtitle: Text(parent['phone'] ?? ''),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.phone_in_talk,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          final phone = parent['phone'];
                          if (phone != null && phone.isNotEmpty) {
                            launchUrl(Uri(scheme: 'tel', path: phone));
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
