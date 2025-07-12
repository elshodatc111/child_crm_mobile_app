import 'package:flutter/material.dart';

class ChildPage extends StatelessWidget {
  const ChildPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
                border: Border(left: BorderSide(color: Colors.green, width: 5)),
              ),
              child: ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green, size: 32),
                title: Text(
                  "Aktiv bolalar",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text("Hozirda faol bo'lganlar"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Kerakli sahifaga yo‘naltirish yoki funksiyani chaqirish
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
                border: Border(left: BorderSide(color: Colors.red, width: 5)),
              ),
              child: ListTile(
                leading: Icon(Icons.cancel, color: Colors.red, size: 32),
                title: Text(
                  "Tark etgan bolalar",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text("Bog‘chani tark etganlar"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Kerakli sahifaga yo‘naltirish yoki funksiyani chaqirish
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
                border: Border(left: BorderSide(color: Colors.orange, width: 5)),
              ),
              child: ListTile(
                leading: Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 32),
                title: Text(
                  "Qarzdorlar",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text("To‘lov qilmagan bolalar"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Kerakli sahifaga yo‘naltirish yoki funksiyani chaqirish
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
        border: Border(left: BorderSide(color: color, width: 5)),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Kerakli sahifaga yo‘naltirish yoki funksiyani chaqirish
        },
      ),
    );
  }
}
