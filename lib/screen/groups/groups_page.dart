import 'package:flutter/material.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCard(
              icon: Icons.groups_rounded,
              title: "Aktiv guruhlar",
              subtitle: "Faol guruhlar ro‘yxati",
              color: Colors.blue,
              onTap: () {
                // Aktiv guruhlar sahifasiga o'tish
              },
            ),
            const SizedBox(height: 16),
            _buildCard(
              icon: Icons.archive_rounded,
              title: "Arxiv guruhlar",
              subtitle: "Oldingi guruhlar ro‘yxati",
              color: Colors.orange,
              onTap: () {
                // Arxiv sahifasiga o'tish
              },
            ),
            const SizedBox(height: 16),
            _buildCard(
              icon: Icons.group_add_rounded,
              title: "Yangi guruh",
              subtitle: "Yangi guruh yaratish",
              color: Colors.green,
              onTap: () {
                // Yangi guruh sahifasiga o'tish
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
