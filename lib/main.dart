import '../screen/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Muhim
  await GetStorage.init(); // Mahalliy xotirani ishga tushurish
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Child Drektor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w700),
          centerTitle: true,
          backgroundColor: Colors.blue
        ),
        scaffoldBackgroundColor: Colors.white
      ),
      home:  SplashPage(),
    );
  }
}
