import 'dart:convert';
import '../../../../const/api_const.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class GroupDavomadHistoryPage extends StatefulWidget {
  final int group_id;

  const GroupDavomadHistoryPage({super.key, required this.group_id});

  @override
  State<GroupDavomadHistoryPage> createState() =>
      _GroupDavomadHistoryPageState();
}

class _GroupDavomadHistoryPageState extends State<GroupDavomadHistoryPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  Map<String, dynamic> currentMonth = {};
  Map<String, dynamic> previousMonth = {};

  @override
  void initState() {
    super.initState();
    fetchDavomadHistory();
  }

  Future<void> fetchDavomadHistory() async {
    setState(() => isLoading = true);
    final token = GetStorage().read('token');
    final url = '${ApiConst().apiUrl}/groups/davomad/${widget.group_id}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            currentMonth = data['child'];
            previousMonth = data['otganOy'];
            isLoading = false;
          });
        }
      } else {
        throw Exception('Xatolik: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Xatolik: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget statusIcon(String status) {
    switch (status) {
      case "keldi":
        return const Icon(Icons.check_circle, color: Colors.green, size: 20);
      case "kelmadi":
        return const Icon(Icons.cancel, color: Colors.red, size: 20);
      case "kutilmoqda":
        return const Icon(Icons.access_time, color: Colors.orange, size: 20);
      default:
        return const Icon(Icons.help_outline, color: Colors.grey, size: 20);
    }
  }

  Widget buildFrozenTable(Map<String, dynamic> monthData) {
    final List<String> days = List<String>.from(monthData['days']);
    final List childs = monthData['childs'];
    const double cellHeight = 48.0;

    return RefreshIndicator(
      onRefresh: fetchDavomadHistory,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ismlar ustuni (qimirlamaydi)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: cellHeight,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(color: Colors.blue),
                    ),
                    child: const Text(
                      "Ism",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ...childs.map<Widget>((child) {
                    return Container(
                      width: 120,
                      height: cellHeight,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                          right: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Text(
                        child['child_name'],
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),
                ],
              ),
              // Qolgan kunlar ustunlari scrollable
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      Row(
                        children:
                            days.map((d) {
                              return Container(
                                width: 80,
                                height: cellHeight,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                child: Text(
                                  d,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      ...childs.map<Widget>((child) {
                        final Map<String, dynamic> natija =
                            Map<String, dynamic>.from(child['natija']);
                        return Row(
                          children:
                              days.map((day) {
                                final status = natija[day] ?? "";
                                return Container(
                                  width: 80,
                                  height: cellHeight,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                      right: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                  child: statusIcon(status),
                                );
                              }).toList(),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Davomad tarixi"),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text(
                  "Joriy oy davomadi",
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
              Tab(
                child: Text(
                  "O'tgan oy davomadi",
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                  children: [
                    buildFrozenTable(currentMonth),
                    buildFrozenTable(previousMonth),
                  ],
                ),
      ),
    );
  }
}
