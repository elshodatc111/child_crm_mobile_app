import 'package:flutter/material.dart';

Widget BlockTarbiyachiWidget(
    String tarbiyachi,
    String start_time,
    String end_time,
    String type,
    ) {
  final isTarbiyachi = type == 'tarbiyachi';

  return Card(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: Colors.red,width: 1.2)
    ),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Turi (Tarbiyachi yoki yordamchi)
          Row(
            children: [
              Icon(
                isTarbiyachi ? Icons.person_outline : Icons.group_outlined,
                color: isTarbiyachi ? Colors.indigo : Colors.orange,
              ),
              const SizedBox(width: 8),
              Text(
                tarbiyachi,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isTarbiyachi ? Colors.indigo.shade100 : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isTarbiyachi ? "Tarbiyachi" : "Yordamchi",
                  style: TextStyle(
                    color: isTarbiyachi ? Colors.indigo : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 12),

          // Start va End Time
          Row(
            children: [
              const Icon(Icons.play_circle_outline, size: 20, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(
                child: Text("Boshlanish: ${start_time.split(' ')[0]}"),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.stop_circle_outlined, size: 20, color: Colors.redAccent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  end_time.isEmpty || end_time == "null"
                      ? "Tugash vaqti: —"
                      : "Tugash: ${end_time.split(' ')[0]}",
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
