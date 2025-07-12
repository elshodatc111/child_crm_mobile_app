import 'package:flutter/material.dart';

class HodimPage extends StatelessWidget {
  const HodimPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildCard(
              icon: Icons.manage_accounts,
              title: "Direktor & Menejerlar",
              subtitle: "Rahbariyat xodimlari",
              color: Colors.deepPurple,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildCard(
              icon: Icons.menu_book,
              title: "O'qituvchilar",
              subtitle: "Fan o'qituvchilari",
              color: Colors.teal,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildCard(
              icon: Icons.child_care,
              title: "Tarbiyachilar",
              subtitle: "Bog‘cha tarbiyachilari",
              color: Colors.indigo,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildCard(
              icon: Icons.restaurant_menu,
              title: "Oshpazlar",
              subtitle: "Oshxona xodimlari",
              color: Colors.orange,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildCard(
              icon: Icons.people,
              title: "Hodimlar",
              subtitle: "Yordamchi xodimlar",
              color: Colors.blue,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildCard(
              icon: Icons.work_outline,
              title: "Vakansiyalar",
              subtitle: "Bo‘sh ish o‘rinlari",
              color: Colors.green,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildCard(
              icon: Icons.add_box,
              title: "Yangi Vakansiya",
              subtitle: "Vakansiya qo‘shish",
              color: Colors.redAccent,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: color, width: 5)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
