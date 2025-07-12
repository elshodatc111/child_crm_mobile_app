import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../splash/splash_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void logout(BuildContext context) {
    final box = GetStorage();
    box.erase();
    Get.offAll(() => const SplashPage());
  }

  void showChangePasswordDialog(BuildContext context) {
    final oldController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Parolni yangilash",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 20),

              // Eski parol
              TextField(
                controller: oldController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Eski parol",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Yangi parol
              TextField(
                controller: newController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Yangi parol",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Parol tasdiqlash
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Parolni tasdiqlash",
                  prefixIcon: const Icon(Icons.lock_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text("Bekor qilish"),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Saqlash"),
                    onPressed: () {
                      if (newController.text != confirmController.text) {
                        Get.snackbar(
                          "Xatolik",
                          "Parollar mos emas",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      } else {
                        // Parolni o‘zgartirish backendga yuborilsa, shu yerga yoziladi
                        Get.back();
                        Get.snackbar(
                          "Muvaffaqiyatli",
                          "Parol yangilandi",
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final user = box.read('user') ?? {};
    final name = user['name'] ?? 'Foydalanuvchi';
    final email = user['email'] ?? 'Email yo‘q';
    final type = user['type'] == 'direktor'
        ? 'Direktor'
        : user['type'] == 'menejer'
        ? 'Menejer'
        : 'Tarbiyachi';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue[100],
                child: const Icon(Icons.person, size: 40, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(name,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 4),
            Center(child: Text(email)),
            const SizedBox(height: 4),
            Center(child: Text(type)),


            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => showChangePasswordDialog(context),
              icon: const Icon(Icons.lock_reset),
              label: const Text("Parolni yangilash"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => logout(context),
              icon: const Icon(Icons.logout),
              label: const Text("Chiqish"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
