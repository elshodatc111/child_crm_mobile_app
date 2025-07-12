import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class HistoryItem extends StatelessWidget {
  final Map item;

  const HistoryItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'uz_UZ');

    final String status = item['status'] ?? '';
    final String title =
        status == 'balans_plastik_daromad'
            ? "Daromad(Naqt)"
            : status == 'balans_naqt_daromad'
            ? "Daromad(Plastik)"
            : status == 'balans_plastik_xarajat'
            ? "Balansdan xarajat(Plastik)"
            : status == 'balans_naqt_xarajat'
            ? "Balansdan xarajat(Naqt)"
            : status == 'plastik_qaytar'
            ? "Qaytarilgan to'lov(Plastik)"
            : status == 'naqt_qaytar'
            ? "Qaytarilgan to'lov(Naqt)"
            : status == 'plastik_xarajat'
            ? "Kassadan Xarajat(Plastik)"
            : status == 'naqt_xarajat'
            ? "Kassadan Xarajat(Naqt)"
            : status == 'plastik_chiqim'
            ? "Kassadan Chiqim(Plastik)"
            : status == 'naqt_chiqim'
            ? "Kassadan Chiqim(Naqt)"
            : status == 'naqt_ish_haqi'
            ? "Ish haqi(Naqt)"
            : status == 'plastik_ish_haqi'
            ? "Ish haqi(Plastik)"
            : status;
    final String amount = item['amount'].toString();
    final String comment = item['start_comment'].toString();
    final String user = item['start_user_id'].toString();
    final String date = item['created_at'].toString();

    Color cardColor = Colors.grey.shade100;
    Color textColor = Colors.white60;
    IconData iconData = Icons.receipt_long;
    Color iconColor = Colors.grey;

    if (status.contains("daromad")) {
      cardColor = Colors.green.shade500;
      textColor = Colors.black45;
      iconData = Icons.arrow_downward;
      iconColor = Colors.green.shade500;
    } else if (status.contains("qaytar")) {
      cardColor = Colors.red;
      textColor = Colors.black45;
      iconData = Icons.undo;
      iconColor = Colors.red;
    } else if (status.contains("chiqim")) {
      cardColor = Colors.green.shade500;
      textColor = Colors.black45;
      iconData = Icons.arrow_upward;
      iconColor = Colors.green.shade500;
    } else if (status.contains("haqi")) {
      cardColor = Colors.orangeAccent;
      textColor = Colors.black45;
      iconData = Icons.payments;
      iconColor = Colors.orangeAccent;
    } else if (status.contains("xarajat")) {
      cardColor = Colors.deepOrangeAccent;
      textColor = Colors.black45;
      iconData = Icons.money_off;
      iconColor = Colors.deepOrangeAccent;
    }

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: cardColor, // bu yerda border rangi
          width: 1.2, // chegaraning qalinligi
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: ListTile(
        leading: Icon(iconData, size: 30, color: iconColor),
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Menejer: $user",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  "${formatter.format(int.tryParse(amount) ?? 0)} so'm",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Izoh: $comment",
              style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
