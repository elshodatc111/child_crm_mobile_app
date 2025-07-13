import 'package:child_app_drektor/screen/child/new_tashrif/create_tashrif_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class TashriflarPage extends StatelessWidget {
  const TashriflarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tashriflar"),
        actions: [
          IconButton(onPressed: (){
            Get.to(()=>CreateTashrifPage());
          }, icon: Icon(Icons.person_add))
        ],
      ),
    );
  }
}
