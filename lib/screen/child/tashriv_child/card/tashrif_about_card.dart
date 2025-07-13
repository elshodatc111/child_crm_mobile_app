import 'dart:convert';
import '../tashrif_success_page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class TashrifAboutCard extends StatelessWidget {
  final int id;
  final String name;
  final String phone1;
  final String phone2;
  final String addres;
  final String about;
  final String meneger;
  final String dates;
  final VoidCallback onRefresh;
  final String status;
  final List<dynamic> groups;

  const TashrifAboutCard({
    super.key,
    required this.id,
    required this.name,
    required this.phone1,
    required this.phone2,
    required this.addres,
    required this.about,
    required this.meneger,
    required this.dates,
    required this.onRefresh, required this.status, required this.groups,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(Icons.person, "Ism", name),
          _infoRow(Icons.location_on, "Manzil", addres),
          _infoRow(Icons.phone_android, "Telefon 1", phone1),
          _infoRow(Icons.phone, "Telefon 2", phone2),
          _infoRow(Icons.manage_accounts, "Meneger", meneger),
          _infoRow(Icons.info_outline, "Izoh", about),
          _infoRow(Icons.calendar_today, "Yaratilgan sana", dates),
          _infoRow(Icons.access_alarms_sharp, "Holati", status=='new'?"Yangi":status=='pedding'?"Jarayonda":status=='cancel'?"Bekor qilindi":"Qabul qilindi"),
          const SizedBox(height: 12),
          status=='cancel'?Text(""):status=='success'?Text(""):Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TashrifSuccessPage(
                          id: id,
                          groups: groups,
                        ),
                      ),
                    );

                    if (result == true) {
                      onRefresh(); // sahifani yangilaydi
                    }
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text("Qabul qilish"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showCancelModal(context, onRefresh),
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text("Bekor qilish"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 8),
          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelModal(BuildContext context, VoidCallback onRefresh) {
    final TextEditingController _descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: _CancelForm(
            childId: id,
            controller: _descController,
            onRefresh: onRefresh,
          ),
        );
      },
    );
  }
}

class _CancelForm extends StatefulWidget {
  final int childId;
  final TextEditingController controller;
  final VoidCallback onRefresh;

  const _CancelForm({
    required this.childId,
    required this.controller,
    required this.onRefresh,
  });

  @override
  State<_CancelForm> createState() => _CancelFormState();
}

class _CancelFormState extends State<_CancelForm> {
  bool isLoading = false;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_checkInput);
  }

  void _checkInput() {
    setState(() {
      isButtonEnabled = widget.controller.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_checkInput);
    super.dispose();
  }

  Future<void> _cancel() async {
    setState(() => isLoading = true);

    final token = GetStorage().read("token");
    const String baseUrl = "https://atko.tech/child_app/public/api";

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/tashrif/cancel"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "vacancy_child_id": widget.childId,
          "description": widget.controller.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Tashrif bekor qilindi"),
              backgroundColor: Colors.green,
            ),
          );
          widget.onRefresh(); // ✅ Sahifani yangilash
        }
      } else {
        final data = jsonDecode(response.body);
        _showError(data['message'] ?? "Xatolik yuz berdi");
      }
    } catch (e) {
      _showError("Xatolik: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Bekor qilish sababi",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: widget.controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Sababni kiriting...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: !isButtonEnabled || isLoading ? null : _cancel,
            icon: isLoading
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : const Icon(Icons.cancel),
            label: Text(isLoading ? "Yuborilmoqda..." : "Bekor qilish"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
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
  }
}
