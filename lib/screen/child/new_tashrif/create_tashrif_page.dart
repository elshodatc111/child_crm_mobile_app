import 'dart:convert';
import 'package:child_app_drektor/const/api_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CreateTashrifPage extends StatefulWidget {
  const CreateTashrifPage({super.key});

  @override
  State<CreateTashrifPage> createState() => _CreateTashrifPageState();
}

class _CreateTashrifPageState extends State<CreateTashrifPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phone1Controller = TextEditingController();
  final TextEditingController phone2Controller = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController addresController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final phoneFormatter = MaskTextInputFormatter(
    mask: '+998 ## ### ####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    phone1Controller.text = '+998 ';
    phone2Controller.text = '+998 ';
  }

  Future<void> _selectDate() async {
    DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: now,
      helpText: "Tug‘ilgan sanani tanlang",
      locale: const Locale('uz', 'UZ'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1976D2),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            cardColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFF1976D2)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate =
          "${pickedDate.year.toString().padLeft(4, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      setState(() {
        birthdayController.text = formattedDate;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final api = ApiConst().apiUrl;
      final token = GetStorage().read("token");

      final response = await http.post(
        Uri.parse("$api/tashrif/create"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "name": nameController.text.trim(),
          "phone1": phone1Controller.text.trim(),
          "phone2": phone2Controller.text.trim(),
          "birthday": birthdayController.text.trim(),
          "addres": addresController.text.trim(),
          "description": descriptionController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(data["message"] ?? "Muvaffaqiyatli saqlandi!",style: TextStyle(color: Colors.white),),
          ),
        );
        Navigator.pop(context);
      } else if (response.statusCode == 422) {
        // Validation errorlarni ko'rsatish
        final errors = data['errors'] ?? {};
        final firstError =
            errors.values.isNotEmpty
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Ulanishda xatolik: $e")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yangi tashrif"), centerTitle: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  buildTextField("Ism va Familiya", nameController),
                  buildPhoneField("Telefon raqam", phone1Controller),
                  buildPhoneField("Qo'shimcha telefon raqam", phone2Controller),
                  buildDatePickerField("Tug‘ilgan sana", birthdayController),
                  buildTextField("Manzil", addresController),
                  buildTextField(
                    "Tashrif haqida",
                    descriptionController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : _submitForm,
                    icon: const Icon(Icons.save),
                    label: const Text("Saqlash"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      elevation: 6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator:
            (value) =>
                (value == null || value.isEmpty)
                    ? 'Iltimos, $label kiriting'
                    : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget buildPhoneField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.phone,
        inputFormatters: [phoneFormatter],
        onTap: () {
          if (controller.text.trim().isEmpty) {
            setState(() {
              controller.text = '+998 ';
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            });
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) return 'Iltimos, $label kiriting';
          if (value.length != 16) return 'To‘liq +998 bilan raqam kiriting';
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: '+998 90 123 4567',
          filled: true,
          fillColor: Colors.grey[100],
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget buildDatePickerField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: _selectDate,
        validator:
            (value) =>
                (value == null || value.isEmpty)
                    ? 'Iltimos, $label tanlang'
                    : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'YYYY-mm-dd',
          suffixIcon: const Icon(Icons.calendar_today),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
