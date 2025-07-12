import 'dart:async';
import 'dart:io';
import 'package:child_app_drektor/screen/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:child_app_drektor/screen/main_page.dart';
import 'package:child_app_drektor/screen/connect/connect_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    // 3 soniyadan keyin tekshiruvlar
    Future.delayed(const Duration(seconds: 3), () {
      checkConnectionAndNavigate();
    });
  }

  Future<void> checkConnectionAndNavigate() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final storage = GetStorage();
        final token = storage.read('token');

        if (token != null && token != '') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const MainPage()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const LoginPage()));
        }
      }
    } on SocketException catch (_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const ConnectPage()));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset('assets/images/logo.png', width: 300),
        ),
      ),
    );
  }
}
