import 'package:child_app_drektor/screen/moliya/show_tranzaksiya_modal.dart';
import 'package:child_app_drektor/screen/moliya/tranzaksiya_modal.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'balance_card.dart';
import 'history_item.dart';

class MoliyaPage extends StatefulWidget {
  const MoliyaPage({super.key});

  @override
  State<MoliyaPage> createState() => _MoliyaPageState();
}

class _MoliyaPageState extends State<MoliyaPage> {
  bool isLoading = true;
  int naqt = 0;
  int plastik = 0;
  List history = [];

  final formatter = NumberFormat('#,###', 'uz_UZ');

  @override
  void initState() {
    super.initState();
    fetchMoliyaData();
  }

  Future<void> fetchMoliyaData() async {
    try {
      final box = GetStorage();
      final token = box.read('token');
      final response = await http.get(
        Uri.parse('https://atko.tech/child_app/public/api/moliya'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          naqt = data['naqt'];
          plastik = data['plastik'];
          history = data['history'];
          isLoading = false;
        });
      } else {
        throw Exception('Xatolik yuz berdi');
      }
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar(
        "Xatolik",
        "Internet aloqasini tekshiring",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            BalanceCard(naqt: naqt, plastik: plastik),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Oxirgi 45 kunlik tranzaksiyalar",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) => HistoryItem(item: history[index]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showTranzaksiyaModal(context, fetchMoliyaData),
        icon: const Icon(Icons.add_circle_outline, color: Colors.white),
        label: const Text("Yangi tranzaksiya", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}