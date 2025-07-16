import '../screen/chart/chart_page.dart';
import '../screen/child/child_page.dart';
import '../screen/groups/groups_page.dart';
import '../screen/kassa/kassa_page.dart';
import '../screen/moliya/moliya_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../screen/profile/profile_page.dart';

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
      const ChildPage(),
      const GroupsPage(),
      const KassaPage(),
      const MoliyaPage(),
      const ChartPage(),
    ];

    final allTitles = [
      "Bolalar",
      "Guruhlar",
      "Kassa",
      "Moliya",
      "Statistika",
    ];

    final allIcons = [
      Icons.home,
      Icons.groups_sharp,
      Icons.balance_sharp,
      Icons.request_quote,
      Icons.bar_chart,
    ];

    List<int> allowedIndexes = [];

    if (type == 'direktor') {
      allowedIndexes = List.generate(allPages.length, (index) => index);
    } else if (type == 'menejer') {
      allowedIndexes = [0, 1, 2];
    } else if (type == 'tarbiyachi' || type == 'kichik_tarbiyachi') {
      allowedIndexes = [0, 1];
    } else {
      allowedIndexes = [0];
    }

    pages = allowedIndexes.map((i) => allPages[i]).toList();
    menuTitles = allowedIndexes.map((i) => allTitles[i]).toList();
    menuIcons = allowedIndexes.map((i) => allIcons[i]).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final selectedTitle = menuTitles.isNotEmpty ? menuTitles[selectedIndex] : "Menu";

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(selectedTitle),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const ProfilePage()),
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: pages.isNotEmpty
          ? pages[selectedIndex]
          : const Center(child: CircularProgressIndicator()),

      bottomNavigationBar: menuTitles.length <= 1
          ? null
          : Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade400,
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(menuTitles.length, (index) {
            final isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.only(left: 12,right: 12, top: 12,bottom: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  menuIcons[index],
                  color: isSelected ? Colors.blue : Colors.white,
                  size: 24,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
