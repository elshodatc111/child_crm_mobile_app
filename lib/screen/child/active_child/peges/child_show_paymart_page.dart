import 'dart:convert';
import '../../../../const/api_const.dart';
import '../peges/child_create_paymart_page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ChildShowPaymartPage extends StatefulWidget {
  final int child_id;
  final List<dynamic> parents;

  const ChildShowPaymartPage({
    super.key,
    required this.child_id,
    required this.parents,
  });

  @override
  State<ChildShowPaymartPage> createState() => _ChildShowPaymartPageState();
}

class _ChildShowPaymartPageState extends State<ChildShowPaymartPage> {
  List<dynamic> paymarts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPaymarts();
  }

  Future<void> fetchPaymarts() async {
    setState(() {
      isLoading = true;
    });
    final baseUrl = ApiConst().apiUrl;
    final token = GetStorage().read('token');
    final id = widget.child_id;
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/child/paymart/$id"),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            paymarts = data['payments'];
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

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
    setState(() => isLoading = false);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To'lovlar"),
        actions: [
          widget.parents.length > 0
              ? IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ChildCreatePaymartPage(
                            child_id: widget.child_id,
                            parents: widget.parents,
                            onCommentsUpdated: () async {
                              await fetchPaymarts();
                            },
                          ),
                    ),
                  );
                },
                icon: Icon(Icons.add_circle_outline_sharp),
              )
              : Text(""),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : paymarts.isEmpty
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "To'lov ma`lumotlari topilmadi.\nTo'lov kiritish uchun yaqin qarindoshlarini kiriting.",
                    textAlign: TextAlign.center, // Matnni o‘rtaga tekislaydi
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: paymarts.length,
                itemBuilder: (ctx, index) {
                  final paymart = paymarts[index];
                  return PaymartItem(
                    type: paymart['type'],
                    amount: paymart['amount'],
                    about: paymart['about'],
                    vaqt: paymart['vaqt'],
                  );
                },
              ),
    );
  }
}

class PaymartItem extends StatelessWidget {
  final String type;
  final int amount;
  final String about;
  final String vaqt;

  const PaymartItem({
    super.key,
    required this.type,
    required this.amount,
    required this.about,
    required this.vaqt,
  });

  String formatDate(String vaqt) {
    try {
      final parsed = DateTime.parse(vaqt);
      return DateFormat('yyyy-MM-dd HH:mm').format(parsed);
    } catch (_) {
      return vaqt;
    }
  }

  String formatAmount(int amount) {
    final formatter = NumberFormat.decimalPattern('uz');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: type == 'naqt' ? Colors.blue : Colors.blueAccent.shade400,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow(Icons.payment, "To'lov turi", type),
            const SizedBox(height: 8),
            _buildRow(
              Icons.monetization_on,
              "Miqdori",
              "${formatAmount(amount)} so'm",
            ),
            const SizedBox(height: 8),
            _buildRow(Icons.access_time, "Vaqt", formatDate(vaqt)),
            const SizedBox(height: 8),
            _buildRow(Icons.edit_note, "Izoh", about),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blueAccent),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              children: [
                TextSpan(
                  text: "$label: ",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
