import 'dart:convert';
import '../../../const/api_const.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class TashrifSuccessPage extends StatefulWidget {
  final int id;
  final List<dynamic> groups;

  const TashrifSuccessPage({
    super.key,
    required this.id,
    required this.groups,
  });

  @override
  State<TashrifSuccessPage> createState() => _TashrifSuccessPageState();
}

class _TashrifSuccessPageState extends State<TashrifSuccessPage> {
  int? selectedGroupId;
  String? selectedPaymentType;
  final TextEditingController _commentController = TextEditingController();
  bool isLoading = false;

  final List<Map<String, String>> paymentTypes = [
    {"label": "Kunlik", "value": "day"},
    {"label": "Oylik", "value": "month"},
  ];

  bool get isFormValid {
    return selectedGroupId != null &&
        selectedPaymentType != null &&
        _commentController.text.trim().isNotEmpty;
  }

  Future<void> _submit() async {
    final token = GetStorage().read("token");
    final String baseUrl = ApiConst().apiUrl;
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/tashrif/success"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "child_id": widget.id,
          "group_id": selectedGroupId,
          "start_comment": _commentController.text.trim(),
          "paymart_type": selectedPaymentType,
        }),
      );
      if (response.statusCode == 200) {
        Navigator.pop(context, true);
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Qabul qilindi"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final error = jsonDecode(response.body);
        _showError(error['message'] ?? "Xatolik yuz berdi");
      }
    } catch (e) {
      _showError("Xatolik: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _commentController.addListener(() {
      setState(() {});
    });
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
        title: const Text("Guruhga qabul qilish"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Guruh tanlash
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: "Guruhni tanlang",
                border: OutlineInputBorder(),
              ),
              dropdownColor: Colors.white,
              isDense: true,
              items: widget.groups.map<DropdownMenuItem<int>>((group) {
                return DropdownMenuItem<int>(
                  value: group["group_id"],
                  child: Text(group["group_name"]),
                );
              }).toList(),
              value: selectedGroupId,
              onChanged: (value) {
                setState(() {
                  selectedGroupId = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // To‘lov turi
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "To‘lov turi",
                border: OutlineInputBorder(),
              ),
              dropdownColor: Colors.white,
              isDense: true,
              items: paymentTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type["value"],
                  child: Text(type["label"]!),
                );
              }).toList(),
              value: selectedPaymentType,
              onChanged: (value) {
                setState(() {
                  selectedPaymentType = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Izoh
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Izoh (majburiy)",
                border: const OutlineInputBorder(),
                errorText: _commentController.text.trim().isEmpty
                    ? "Izoh kiritilishi shart"
                    : null,
              ),
            ),
            const SizedBox(height: 24),

            // Submit tugmasi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isFormValid && !isLoading ? _submit : null,
                icon: isLoading
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.check),
                label: Text(isLoading ? "Yuborilmoqda..." : "Qabul qilish"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
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
    );
  }
}
