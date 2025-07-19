import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:child_app_drektor/const/api_const.dart';

class KassaOutputPage extends StatefulWidget {
  final int naqt;
  final int plastik;

  const KassaOutputPage({super.key, required this.naqt, required this.plastik});

  @override
  State<KassaOutputPage> createState() => _KassaOutputPageState();
}

class _KassaOutputPageState extends State<KassaOutputPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? expenseType;
  String? paymentType;
  bool isLoading = false;

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      final api = ApiConst().apiUrl;
      final token = GetStorage().read("token");

      final response = await http.post(
        Uri.parse("$api/kassa/post"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "expense_type": expenseType,
          "amount": _amountController.text.trim(),
          "payment_type": paymentType,
          "note": _noteController.text.trim(),
        }),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              data["message"] ?? "Muvaffaqiyatli saqlandi!",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        Navigator.pop(context, true);
      } else if (response.statusCode == 422) {
        final errors = data['errors'] ?? {};
        final firstError =
            errors.isNotEmpty
                ? (errors.values.first as List).first
                : data['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(firstError ?? "Xatolik yuz berdi")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "Noma’lum xatolik yuz berdi!"),
          ),
        );
      }
    } catch (e) {
      print("Xatolik: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Tarmoq yoki server xatoligi!")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chiqarim qoʻshish")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AbsorbPointer(
          absorbing: isLoading,
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Center(
                      child: Text(
                        "Kassadagi balans:",
                        style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _balanceBox("Naqt", widget.naqt, Colors.blue),
                        const SizedBox(width: 12),
                        _balanceBox("Plastik", widget.plastik, Colors.red),
                      ],
                    ),
                    const SizedBox(height: 24),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Chiqim turi",
                        prefixIcon: const Icon(Icons.category),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      value: expenseType,
                      items:
                          ['chiqim', 'xarajat']
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.capitalize!),
                                ),
                              )
                              .toList(),
                      onChanged: (v) => setState(() => expenseType = v),
                      validator: (v) => v == null ? "Turini tanlang" : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Toʻlov turi",
                        prefixIcon: const Icon(Icons.payment),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      value: paymentType,
                      items:
                          ['Naqt', 'Plastik']
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (v) => setState(() => paymentType = v),
                      validator:
                          (v) => v == null ? "Toʻlov turini tanlang" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Miqdor",
                        prefixIcon: const Icon(Icons.attach_money),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Miqdor kiriting";
                        final amt = int.tryParse(v);
                        if (amt == null || amt <= 0)
                          return "Yaroqli miqdor kiritilmadi";
                        if (paymentType == "Naqt" && amt > widget.naqt)
                          return "Naqt yetarli emas";
                        if (paymentType == "Plastik" && amt > widget.plastik)
                          return "Plastik yetarli emas";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Izoh",
                        prefixIcon: const Icon(Icons.note),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _saveData,
                      icon: const Icon(Icons.save,color: Colors.white,),
                      label: const Text("Saqlash",style: TextStyle(color: Colors.white,fontSize: 16),),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _balanceBox(String label, int amount, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "$amount so'm",
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
