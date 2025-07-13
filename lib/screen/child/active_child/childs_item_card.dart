import './child_show_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ChildsItemCard extends StatelessWidget {
  final int id;
  final String name;
  final String birthday;
  final String group_name;
  final int balans;
  final Color balansColor;
  const ChildsItemCard({super.key, required this.id, required this.name, required this.birthday, required this.group_name, required this.balans, required this.balansColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.blue, width: 1.2),
        ),
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        "Tug'ilgan kuni",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            birthday,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  group_name!='null'?Column(
                    children: [
                      Text(
                        "Guruh",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          const Icon(Icons.group, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            group_name,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ):SizedBox(),
                  Column(
                    children: [
                      Text(
                        "Balans",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.account_balance_wallet,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$balans so'm",
                            style: TextStyle(color: balansColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: (){
        Get.to(()=>ChildShowPage(id: id));
      },
    );
  }
}
