import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TranzaksiyaModal extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final ValueNotifier<String> selectedType = ValueNotifier("naqt_daromad");

  final VoidCallback onSuccess;

  TranzaksiyaModal({super.key, required this.onSuccess});

  void handleSave(BuildContext context) {
    String amount = amountController.text.trim();
    String comment = commentController.text.trim();
    String type = selectedType.value;

    // ✅ Bo'sh maydonlar tekshiruv
    if (amount.isEmpty || comment.isEmpty || type.isEmpty) {
      Get.snackbar(
        "Xatolik",
        "Iltimos, barcha maydonlarni to‘ldiring!",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // ⚠️ Yuborishdan oldin barcha validatsiyalardan o‘tdi
    Navigator.pop(context);
    onSuccess();
    Get.snackbar(
      "Tranzaksiya",
      "Tranzaksiya saqlandi",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
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

            // Tranzaksiya summasi
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Tranzaksiya summasi",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Turi
            ValueListenableBuilder(
              valueListenable: selectedType,
              builder:(context, value, _) => DropdownButtonFormField<String>(
                    value: value,
                    decoration: InputDecoration(
                      labelText: "Tranzaksiya turi",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    dropdownColor: Colors.white,
                    items:
                        [
                          "naqt_xarajat",
                          "plastik_xarajat",
                          "naqt_daromad",
                          "plastik_daromad",
                        ].map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(
                              type.replaceAll("_", " ").capitalizeFirst!,
                              style: const TextStyle(
                                fontSize: 16,
                                color:Colors.black
                              ),
                            ),
                          );
                        }).toList(),
                    onChanged: (value) => selectedType.value = value!,
                  ),
            ),

            const SizedBox(height: 16),

            // Izoh
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Izoh",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Tugmalar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
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
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                ElevatedButton.icon(
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
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
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
