import 'package:flutter/material.dart';

class HodimDavomadPage extends StatelessWidget {
  const HodimDavomadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCard(
              icon: Icons.manage_accounts,
              title: "Menegerlar",
              subtitle: "Menegerlar davomati",
              color: Colors.deepPurple,
              onTap: () {
                // Menegerlar davomad sahifasiga o'tish
              },
            ),
            const SizedBox(height: 16),
            _buildCard(
              icon: Icons.school,
              title: "Tarbiyachilar",
              subtitle: "Tarbiyachi xodimlar davomati",
              color: Colors.teal,
              onTap: () {
                // Tarbiyachilar davomad sahifasiga o'tish
              },
            ),
            const SizedBox(height: 16),
            _buildCard(
              icon: Icons.people_alt_rounded,
              title: "Hodimlar",
              subtitle: "Umumiy xodimlar davomati",
              color: Colors.indigo,
              onTap: () {
                // Hodimlar davomad sahifasiga o'tish
              },
            ),
            const SizedBox(height: 16),
            _buildCard(
              icon: Icons.restaurant,
              title: "Oshpazlar",
              subtitle: "Oshpazlar davomati",
              color: Colors.orange,
              onTap: () {
                // Oshpazlar davomad sahifasiga o'tish
              },
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
        leading: Icon(icon, color: color, size: 32),
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
