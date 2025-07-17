import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget BlockChild(
  String name,
  int balans,
  String start_time,
  String paymart_type,
  String end_time,
  String commint,
) {
  final numberFormat = NumberFormat("#,##0", "uz_UZ");

  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(width: 1.2, color: Colors.red),
    ),
    color: Colors.white,
    elevation: 1,
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Ism
          Row(
            children: [
              const Icon(Icons.person_outline, color: Colors.teal),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "${name} (Tark etgan)",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Balans
          buildRow(
            icon: Icons.account_balance_wallet_outlined,
            label: "Balans:",
            value: "${numberFormat.format(balans)} so'm",
            iconColor: Colors.orange,
          ),

          /// To‘lov turi
          buildRow(
            icon: Icons.payment_outlined,
            label: "To‘lov turi:",
            value: paymart_type == "day" ? "Kunlik" : "Oylik",
            iconColor: Colors.purple,
          ),

          /// Boshlanish sanasi
          buildRow(
            icon: Icons.play_circle_outline,
            label: "Ro'yhatga olindi:",
            value: start_time.split(' ')[0],
            iconColor: Colors.green,
          ),

          /// Tugagan sanasi
          buildRow(
            icon: Icons.stop_circle_outlined,
            label: "Guruhdan o'chirildi:",
            value:
                end_time.isEmpty || end_time == "null"
                    ? "—"
                    : end_time.split(' ')[0],
            iconColor: Colors.redAccent,
          ),

          /// Izoh
          buildRow(
            icon: Icons.comment_outlined,
            label: "Izoh:",
            value: commint.isNotEmpty ? commint : "—",
            iconColor: Colors.blue,
          ),
        ],
      ),
    ),
  );
}

/// 🔧 Helper zamonaviy satr generatori
Widget buildRow({
  required IconData icon,
  required String label,
  required String value,
  required Color iconColor,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    ),
  );
}
