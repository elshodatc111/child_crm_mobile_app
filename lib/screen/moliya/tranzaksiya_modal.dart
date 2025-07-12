import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class TranzaksiyaModal extends StatefulWidget {
  final VoidCallback onSuccess;

  const TranzaksiyaModal({super.key, required this.onSuccess});

  @override
  State<TranzaksiyaModal> createState() => _TranzaksiyaModalState();
}

class _TranzaksiyaModalState extends State<TranzaksiyaModal> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final ValueNotifier<String> selectedType = ValueNotifier(
    "balans_naqt_xarajat",
  );
  bool isLoading = false;

  Future<void> handleSave(BuildContext context) async {
    final box = GetStorage();
    final token = box.read("token");
    final amount = amountController.text.trim();
    final comment = commentController.text.trim();
    final type = selectedType.value;

    if (amount.isEmpty || comment.isEmpty || type.isEmpty) {
      Get.snackbar(
        "Xatolik",
        "Iltimos, barcha maydonlarni to‘ldiring!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://atko.tech/child_app/public/api/moliya/chiqim'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {'amount': amount, 'status': type, 'start_comment': comment},
      );

      final data = jsonDecode(response.body);
      setState(() => isLoading = false);

      if (response.statusCode == 200 && data['success'] == true) {
        Navigator.pop(context);
        widget.onSuccess();
        Get.snackbar(
          "Muvaffaqiyatli",
          data['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Xatolik",
          data['message'] ?? "Nomaʼlum xatolik yuz berdi",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar(
        "Xatolik",
        "Internet aloqasini tekshiring!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Yangi tranzaksiya",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Tranzaksiya summasi",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder(
              valueListenable: selectedType,
              builder:
                  (context, value, _) => DropdownButtonFormField<String>(
                    value: value,
                    dropdownColor: Colors.white,
                    decoration: InputDecoration(
                      labelText: "Tranzaksiya turi",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items:
                        [
                          "balans_naqt_xarajat",
                          "balans_plastik_xarajat",
                          "balans_naqt_daromad",
                          "balans_plastik_daromad",
                        ].map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(
                              type.replaceAll("_", " ").capitalizeFirst!,
                            ),
                          );
                        }).toList(),
                    onChanged: (value) => selectedType.value = value!,
                  ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Izoh",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            isLoading
                ? const CircularProgressIndicator()
                : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white),
                        label: const Text("Bekor qilish"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0,),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => handleSave(context),
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const Text("Saqlash"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
