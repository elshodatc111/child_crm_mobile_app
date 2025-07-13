import '../active_child/childs_item_card.dart';
import '../../../const/api_const.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
class DebitChildPage extends StatefulWidget {
  const DebitChildPage({super.key});

  @override
  State<DebitChildPage> createState() => _DebitChildPageState();
}

class _DebitChildPageState extends State<DebitChildPage> {
  List<dynamic> allChildren = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChildren();
  }

  Future<void> fetchChildren() async {
    final baseUrl = ApiConst().apiUrl;
    final token = GetStorage().read('token');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/childs/debet'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            allChildren = data['children'];
            isLoading = false;
          });
        } else {
          showMessage(data['message'] ?? 'Xatolik yuz berdi');
        }
      } else {
        showMessage("Tarmoqli xatolik: ${response.statusCode}");
      }
    } catch (e) {
      showMessage("Xatolik: $e");
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
    setState(() => isLoading = false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Qarzdor Bolalar"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child:ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: allChildren.length,
              itemBuilder: (context, index) {
                final child = allChildren[index];
                final balansColor =
                child['balans'] >= 0
                    ? Colors.green
                    : Colors.red;
                return ChildsItemCard(
                  id: child['id'],
                  name: child['name'],
                  birthday: child['birthday'],
                  group_name: 'null',
                  balans: child['balans'],
                  balansColor: balansColor,
                );
              },
            ),
          ),
        ],
      ),
    );;
  }
}
