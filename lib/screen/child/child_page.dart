import 'package:child_app_drektor/screen/child/active_child/active_child_page.dart';
import 'package:child_app_drektor/screen/child/davomad/hodim_davomad_page.dart';
import 'package:child_app_drektor/screen/child/qarz_child/debit_child_page.dart';
import 'package:child_app_drektor/screen/child/tashriv_child/create_tashrif_page.dart';
import 'package:child_app_drektor/screen/child/tashriv_child/tashriflar_page.dart';
import 'package:child_app_drektor/screen/child/vacancy/hodim_vacansy_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                  Get.to(()=>ActiveChildPage());
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
                  Get.to(()=>DebitChildPage());
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
                border: Border(left: BorderSide(color: Colors.blue, width: 5)),
              ),
              child: ListTile(
                leading: Icon(Icons.people_alt_rounded, color: Colors.blue, size: 32),
                title: Text(
                  "Tashriflar",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text("Tashriflar"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.to(()=>TashriflarPage());
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
                border: const Border(left: BorderSide(color: Colors.green, width: 5)),
              ),
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.green, size: 32),
                title: const Text(
                  "Hodimlar",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: const Text("Hodimlar kunlik davomadi"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.to(()=>HodimDavomadPage());
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
                border: const Border(left: BorderSide(color: Colors.orange, width: 5)),
              ),
              child: ListTile(
                leading: const Icon(Icons.work_outline, color: Colors.orange, size: 32),
                title: const Text(
                  "Hodimlar Vakansiya",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: const Text("Bo'sh ish o'rinlari uchun nomzodlar"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.to(()=>HodimVacansyPage());
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
