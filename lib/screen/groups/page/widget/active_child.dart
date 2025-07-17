import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget ActiveChild(
  String name,
  int balans,
  String start_time,
  String paymart_type,
) {
  final numberFormat = NumberFormat("#,##0", "uz_UZ");

  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: Colors.green, width: 1.2),
    ),
    color: Colors.white,
    elevation: 1,
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ism
          Row(
            children: [
              const Icon(Icons.person_outline, color: Colors.teal),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "${name} (Aktiv)",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Balans
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 6),
                  Text("Balans:", style: TextStyle(fontSize: 16)),
                ],
              ),
              Text(
                "${numberFormat.format(balans)} so'm",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // To‘lov turi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.payment_outlined, color: Colors.purple),
                  SizedBox(width: 6),
                  Text("To‘lov turi:", style: TextStyle(fontSize: 16)),
                ],
              ),
              Text(
                paymart_type == "day" ? "Kunlik" : "Oylik",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Ro'yxatga olingan sana
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.access_time_filled_outlined, color: Colors.blue),
                  SizedBox(width: 6),
                  Text("Ro'yxatga olindi:", style: TextStyle(fontSize: 16)),
                ],
              ),
              Text(
                start_time.split(' ')[0],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
