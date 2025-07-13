import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TashrifShowComments extends StatelessWidget {
  final List<dynamic> comments;

  const TashrifShowComments({super.key, required this.comments});

  String formatDate(String rawDate) {
    try {
      final dateTime = DateTime.parse(rawDate);
      return DateFormat('dd.MM.yyyy – HH:mm').format(dateTime);
    } catch (e) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          "Hozircha eslatmalar mavjud emas",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 2),
          elevation: 2,
          shadowColor: Colors.black45,
          color: Colors.white, // Orqa fonni oq rangda qilish
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.0,vertical: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(4), // Card ichidagi radiusga mos keladi
            ),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(comment['meneger'] ?? '',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                  Text(comment['created_at'] ?? ''),
                ],
              ),
              subtitle: Text("${comment['description'] ?? ''}"),
            ),
          ),
        );
      },
    );
  }
}
