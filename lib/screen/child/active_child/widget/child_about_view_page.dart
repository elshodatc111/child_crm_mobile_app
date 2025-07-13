import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChildAboutViewPage extends StatelessWidget {
  final Map<String, dynamic> about;

  const ChildAboutViewPage({super.key, required this.about});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,###", "uz_UZ");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow("Tug‘ilgan sana:", about['tkun']),
          _divider(),
          _infoRow("Yashash manzili:", about['addres']),
          _divider(),
          _infoRow("Telefon raqam:", about['phone1']),
          _divider(),
          _infoRow("Qoshimcha telefon raqam:", about['phone2']),
          _divider(),
          _infoRow("Balans:", "${formatter.format(about['balans'])} so'm"),
          _divider(),
          _infoRow("Holat", about['status']=='active'?"Aktive":""),
          _divider(),
          _infoRow("Guruh", about['group']),
          _divider(),
          _infoRow("Meneger", about['meneger']),
          _divider(),
          _infoRow("Qo‘shimcha", about['description']),
          _divider(),
          _infoRow("Yaratilgan vaqti", about['created_at']),
          _divider(),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(color: Colors.grey, height: 16, thickness: 0.8);
  }
}
