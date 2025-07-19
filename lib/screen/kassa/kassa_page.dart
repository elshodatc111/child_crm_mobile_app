import 'dart:convert';
import 'package:child_app_drektor/screen/kassa/kassa_output_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../const/api_const.dart';

class KassaPage extends StatefulWidget {
  const KassaPage({super.key});

  @override
  State<KassaPage> createState() => _KassaPageState();
}

class _KassaPageState extends State<KassaPage> {
  int naqt = 0;
  int plastik = 0;
  int naqtChiqim = 0;
  int plastikChiqim = 0;
  int naqtXarajat = 0;
  int plastikXarajat = 0;
  List<dynamic> history = [];
  bool isLoading = true;
  String type = GetStorage().read("user")['type']??"";
  bool isActionLoading = false;

  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }
  Future<void> _confirmTransaction(int id) async {
    setState(() => isActionLoading = true);
    final token = storage.read('token');

    try {
      final response = await http.post(
        Uri.parse('${ApiConst().apiUrl}/kassa/success'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'id': id}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(data["message"] ?? "Tasdiqlandi"),
        ));
        await _fetchData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(data["message"] ?? "Xatolik yuz berdi"),
        ));
      }
    } catch (e) {
      debugPrint("Tasdiqlash xatoligi: $e");
    } finally {
      setState(() => isActionLoading = false);
    }
  }

  Future<void> _cancelTransaction(int id) async {
    setState(() => isActionLoading = true);
    final token = storage.read('token');

    try {
      final response = await http.post(
        Uri.parse('${ApiConst().apiUrl}/kassa/delete'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'id': id}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(data["message"] ?? "Bekor qilindi"),
        ));
        await _fetchData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(data["message"] ?? "Xatolik yuz berdi"),
        ));
      }
    } catch (e) {
      debugPrint("Bekor qilish xatoligi: $e");
    } finally {
      setState(() => isActionLoading = false);
    }
  }

  Future<void> _fetchData() async {
    setState(() => isLoading = true);

    try {
      final token = storage.read('token');
      if (token == null) {
        debugPrint("Token mavjud emas");
        setState(() => isLoading = false);
        return;
      }

      final response = await http.get(
        Uri.parse('${ApiConst().apiUrl}/kassa'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final kassa = body['kassa'];

        if (mounted) {
          setState(() {
            naqt = int.tryParse(kassa['naqt'] ?? '0') ?? 0;
            plastik = int.tryParse(kassa['plastik'] ?? '0') ?? 0;
            naqtChiqim = int.tryParse(kassa['naqt_chiqim'] ?? '0') ?? 0;
            plastikChiqim = int.tryParse(kassa['plastik_chiqim'] ?? '0') ?? 0;
            naqtXarajat = int.tryParse(kassa['naqt_xarajat'] ?? '0') ?? 0;
            plastikXarajat = int.tryParse(kassa['plastik_xarajat'] ?? '0') ?? 0;
            history = body['history'];
            isLoading = false;
          });
        }
      } else {
        debugPrint("Xatolik status code: ${response.statusCode}");
        debugPrint("Body: ${response.body}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("Exception: $e");
      setState(() => isLoading = false);
    }
  }

  String formatCurrency(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => " ",
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required int amount,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              "${formatCurrency(amount)} so'm",
              style: TextStyle(
                fontSize: 16,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
      onRefresh: _fetchData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "💰 Kassada mavjud",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildCard(
                  icon: Icons.attach_money,
                  title: "Naqt",
                  amount: naqt,
                  color: Colors.green,
                ),
                _buildCard(
                  icon: Icons.credit_card,
                  title: "Plastik",
                  amount: plastik,
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "⏳ Tasdiqlanmagan chiqimlar",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildCard(
                  icon: Icons.money_off,
                  title: "Naqt Chiqim",
                  amount: naqtChiqim,
                  color: Colors.orange,
                ),
                _buildCard(
                  icon: Icons.credit_card_off,
                  title: "Plastik Chiqim",
                  amount: plastikChiqim,
                  color: Colors.orangeAccent,
                ),
              ],
            ),
            Row(
              children: [
                _buildCard(
                  icon: Icons.trending_down,
                  title: "Naqt Xarajat",
                  amount: naqtXarajat,
                  color: Colors.red,
                ),
                _buildCard(
                  icon: Icons.trending_down,
                  title: "Plastik Xarajat",
                  amount: plastikXarajat,
                  color: Colors.redAccent,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final result = await Get.to(
                        () => KassaOutputPage(naqt: naqt, plastik: plastik),
                  );
                  if (result == true) {
                    _fetchData();
                  }
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Yangi chiqim qo'shish",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            const Text(
              "📋 Tasdiqlanmagan chiqimlar",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            ListView.builder(
              shrinkWrap: true,
              // Bu muhim
              physics: NeverScrollableScrollPhysics(),
              // Scrollni SingleChildScrollView ga topshiradi
              itemCount: history.length,
              itemBuilder: (ctx, index) {
                final item = history[index];
                return _itemTranzaksiobItem(
                  item['id'],
                  item['status'],
                  item['amount'],
                  item['start_comment'],
                  item['meneger'],
                  item['created_at'],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemTranzaksiobItem(
      int id,
      String status,
      String amount,
      String start_comment,
      String meneger,
      String created_at,
      ) {
    String formattedAmount = amount.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ' ',
    );
    String formattedDate = '';
    try {
      DateTime date = DateTime.parse(created_at);
      formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(date);
    } catch (e) {
      formattedDate = created_at;
    }

    return Stack(
      children: [
        Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 6),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.blue, width: 1.2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Yuqoridagi sarlavha
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Menejer: $meneger",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      status == 'naqt_chiqim'
                          ? "Chiqim (Naqt)"
                          : status == 'plastik_chiqim'
                          ? "Chiqim (Plastik)"
                          : status == 'naqt_xarajat'
                          ? "Xarajat (Naqt)"
                          : "Xarajat (Plastik)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: status.contains('xarajat') ? Colors.red : Colors.green,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("💰 $formattedAmount so'm", style: const TextStyle(fontSize: 14)),
                    Text("🕒 $formattedDate", style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(start_comment, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => _cancelTransaction(id),
                      icon: const Icon(Icons.close),
                      label: const Text("Bekor qilish"),
                    ),
                    const SizedBox(width: 8),
                    type == 'direktor'
                        ? ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _confirmTransaction(id),
                      icon: const Icon(Icons.check),
                      label: const Text("Tasdiqlash"),
                    )
                        : const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Loading indicator ustida ko‘rsatish
        if (isActionLoading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }

}
