import 'package:child_app_drektor/screen/chart/chart_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:child_app_drektor/screen/child/child_page.dart';
import 'package:child_app_drektor/screen/davomad_hodim/hodim_davomad_page.dart';
import 'package:child_app_drektor/screen/groups/groups_page.dart';
import 'package:child_app_drektor/screen/hodim/hodim_page.dart';
import 'package:child_app_drektor/screen/home/home_page.dart';
import 'package:child_app_drektor/screen/kassa/kassa_page.dart';
import 'package:child_app_drektor/screen/moliya/moliya_page.dart';
import 'package:child_app_drektor/screen/profile/profile_page.dart';
import 'package:child_app_drektor/screen/report/report_page.dart';
import 'package:child_app_drektor/screen/setting/setting_page.dart';
import 'package:child_app_drektor/screen/vizet/vizet_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  List<Widget> pages = [];
  List<String> menuTitles = [];
  List<IconData> menuIcons = [];

  @override
  void initState() {
    super.initState();
    _loadMenuForUserType();
  }

  void _loadMenuForUserType() {
    final box = GetStorage();
    final user = box.read('user') ?? {};
    final String type = user['type'] ?? '';

    final allPages = [
      const HomePage(),
      const ChildPage(),
      const VizetPage(),
      const GroupsPage(),
      const HodimDavomadPage(),
      const KassaPage(),
      const MoliyaPage(),
      const ChartPage(), // Statistika
      const ReportPage(),
      const HodimPage(),
      const SettingPage(),
    ];

    final allTitles = [
      "Bosh sahifa",
      "Bolalar",
      "Tashriflar",
      "Guruhlar",
      "Hodimlar Davomadi",
      "Kassa",
      "Moliya",
      "Statistika",
      "Hisobotlar",
      "Hodimlar",
      "Sozlamalar",
    ];

    final allIcons = [
      Icons.dashboard,
      Icons.emoji_emotions,
      Icons.apartment,
      Icons.account_tree,
      Icons.event_note,
      Icons.account_balance_wallet,
      Icons.bar_chart,
      Icons.pie_chart_outline,
      Icons.insert_drive_file,
      Icons.people,
      Icons.settings,
    ];

    List<int> allowedIndexes = [];

    if (type == 'direktor') {
      allowedIndexes = List.generate(allPages.length, (index) => index); // Hammasi
    } else if (type == 'menejer') {
      allowedIndexes = [0, 1, 2, 3, 4, 5, 9]; // Tanlanganlar
    } else if (type == 'tarbiyachi' || type == 'kichik_tarbiyachi') {
      allowedIndexes = [0, 1, 2, 3]; // Faqat zarurlari
    } else {
      allowedIndexes = [0]; // Default: faqat bosh sahifa va sozlamalar
    }

    // Filterlash
    pages = allowedIndexes.map((i) => allPages[i]).toList();
    menuTitles = allowedIndexes.map((i) => allTitles[i]).toList();
    menuIcons = allowedIndexes.map((i) => allIcons[i]).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: buildMenu()),
      appBar: AppBar(
        title: Text(menuTitles[selectedIndex]),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const ProfilePage()),
            icon: const Icon(Icons.person),
          )
        ],
      ),
      body: pages[selectedIndex],
    );
  }

  Widget buildMenu() {
    final box = GetStorage();
    final user = box.read('user') ?? {};
    final String name = user['name'] ?? 'Foydalanuvchi';
    final String email = user['email'] ?? 'Email yo‘q';
    final String type = user['type'] == 'direktor' ? 'Direktor' : user['type'] == 'menejer' ? 'Meneger' : 'Tarbiyachi';

    return Container(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40),
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                const SizedBox(height: 4),
                Text(email, style: const TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 4),
                Text(type, style: const TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
          for (int i = 0; i < menuTitles.length; i++)
            buildMenuItem(i, menuIcons[i], menuTitles[i]),
        ],
      ),
    );
  }

  Widget buildMenuItem(int index, IconData icon, String title) {
    final isSelected = selectedIndex == index;

    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blueAccent : Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blueAccent : Colors.grey[800],
          fontWeight: FontWeight.w500,
        ),
      ),
      tileColor: isSelected ? Colors.indigo[600] : Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        Navigator.pop(context); // Drawer yopiladi
      },
    );
  }
}
