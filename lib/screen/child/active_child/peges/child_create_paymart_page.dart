import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:child_app_drektor/const/api_const.dart';

class ChildCreatePaymartPage extends StatefulWidget {
  final int child_id;
  final List<dynamic> parents;
  final VoidCallback onCommentsUpdated;

  const ChildCreatePaymartPage({
    super.key,
    required this.child_id,
    required this.parents,
    required this.onCommentsUpdated,
  });

  @override
  State<ChildCreatePaymartPage> createState() => _ChildCreatePaymartPageState();
}

class _ChildCreatePaymartPageState extends State<ChildCreatePaymartPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? selectedType;
  int? selectedParentId;
  bool isLoading = false;

  final List<String> types = ['naqt', 'plastik', 'chegirma'];

  Future<void> submit() async {
    setState(() => isLoading = true);

    final token = GetStorage().read('token');
    final baseUrl = ApiConst().apiUrl;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/child/paymart/create'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'child_id': widget.child_id,
          'type': selectedType,
          'amount': int.parse(_amountController.text),
          'child_parent_id': selectedParentId,
          'description': _descriptionController.text,
        }),
      );

      if (response.statusCode == 200) {
        widget.onCommentsUpdated();
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("To'lov muvaffaqiyatli bajarildi"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final data = jsonDecode(response.body);
        showMessage(data['message'] ?? "Xatolik yuz berdi");
      }
    } catch (e) {
      showMessage("Xatolik: $e");
    }

    setState(() => isLoading = false);
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("To'lov qilish")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "To'lov turi",
                  border: OutlineInputBorder(),
                ),
                value: selectedType,
                items: types.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedType = value),
                validator: (value) =>
                value == null ? "To'lov turini tanlang" : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: "Qarindosh",
                  border: OutlineInputBorder(),
                ),
                value: selectedParentId,
                items: widget.parents.map<DropdownMenuItem<int>>((parent) {
                  return DropdownMenuItem(
                    value: parent['id'],
                    child: Text(parent['name'] ?? '---'),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedParentId = value),
                validator: (value) =>
                value == null ? "Qarindoshni tanlang" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: "To'lov summasi",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "To'lov summasi majburiy";
                  }
                  if (int.tryParse(value) == null) {
                    return "Faqat raqam kiriting";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Izoh",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                value == null || value.trim().isEmpty
                    ? "Izoh majburiy"
                    : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.send,color: Colors.white,),
                  label: Text(
                    isLoading ? "Yuborilmoqda..." : "Saqlash",style: TextStyle(color: Colors.white),
                  ),
                  onPressed: isLoading
                      ? null
                      : () {
                    if (_formKey.currentState!.validate()) {
                      submit();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
