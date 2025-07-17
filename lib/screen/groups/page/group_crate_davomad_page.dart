import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../const/api_const.dart';

class GroupCrateDavomadPage extends StatefulWidget {
  final int group_id;

  const GroupCrateDavomadPage({super.key, required this.group_id});

  @override
  State<GroupCrateDavomadPage> createState() => _GroupCrateDavomadPageState();
}

class _GroupCrateDavomadPageState extends State<GroupCrateDavomadPage> {
  List<Map<String, dynamic>> children = [];
  Map<int, bool> attendance = {};
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    fetchChildren();
  }

  Future<void> fetchChildren() async {
    setState(() {
      isLoading = true;
    });

    final baseUrl = ApiConst().apiUrl;
    final token = GetStorage().read('token');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/groups/child/${widget.group_id}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          List<dynamic> childList = data['child'];
          List<Map<String, dynamic>> filtered = childList
              .where((item) => item["status"] == "true")
              .map<Map<String, dynamic>>(
                (item) => {
              "id": item["id"],
              "child": item["child"],
              "balans": item["balans"],
              "paymart_type":
              item["paymart_type"] == "day" ? "Kunlik" : "Oylik",
            },
          )
              .toList();

          setState(() {
            children = filtered;
            attendance = {
              for (var item in filtered) item['id']: false,
            };
            isLoading = false;
          });
        } else {
          showMessage(data['message'] ?? 'Xatolik yuz berdi');
        }
      } else {
        showMessage('Tarmoqli xatolik: ${response.statusCode}');
      }
    } catch (e) {
      showMessage('Xatolik: $e');
    }

    setState(() => isLoading = false);
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  void saveAttendance() async {
    setState(() {
      isSaving = true;
    });

    Map<String, String> attendanceData = {};
    attendance.forEach((key, value) {
      attendanceData[key.toString()] = value ? "keldi" : "kelmadi";
    });

    Map<String, dynamic> payload = {
      "group_id": widget.group_id,
      "attendance": attendanceData,
    };

    final token = GetStorage().read('token');
    final url = Uri.parse('${ApiConst().apiUrl}/groups/create/davomad');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Davomad saqlandi")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Xatolik yuz berdi: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Serverga ulanishda xatolik: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  String formatNumber(dynamic number) {
    if (number == null) return "0";
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Davomad olish")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: children.length,
              itemBuilder: (context, index) {
                final child = children[index];
                final isPresent = attendance[child['id']] ?? true;
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.green,width: 1.2),
                      borderRadius: BorderRadius.all(Radius.circular(12))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(child['child'],style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20.0),),
                            SizedBox(height: 4.0,),
                            Row(
                              children: [
                                Text("Balans:",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                SizedBox(width: 4.0,),
                                Text("${formatNumber(child['balans'])} so'm",),
                              ],
                            ),
                            SizedBox(height: 2.0,),
                            Row(
                              children: [
                                Text("To'lov turi:",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                SizedBox(width: 4.0,),
                                Text("${child['paymart_type']}",),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Switch(
                              value: isPresent,
                              activeColor: Colors.green,
                              inactiveThumbColor: Colors.red,
                              onChanged: (value) {
                                setState(() {
                                  attendance[child['id']] = value;
                                });
                              },
                            ),
                            Text(
                              isPresent ? "Keldi" : "Kelmadi",
                              style: TextStyle(
                                color: isPresent ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: attendance.isEmpty || isSaving ? null : saveAttendance,
                    icon: isSaving
                        ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Icon(Icons.save, color: Colors.white),
                    label: Text(
                      isSaving ? "Saqlanmoqda..." : "Saqlash",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      (attendance.isEmpty || isSaving) ? Colors.grey : Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: attendance.isEmpty
                        ? null
                        : () => Navigator.pop(context),
                    icon: Icon(Icons.cancel,color: Colors.white),
                    label: Text("Bekor qilish",style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      attendance.isEmpty ? Colors.grey : Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
