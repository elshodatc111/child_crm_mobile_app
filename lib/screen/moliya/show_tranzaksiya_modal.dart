import '../../screen/moliya/tranzaksiya_modal.dart';
import 'package:flutter/material.dart';

void showTranzaksiyaModal(BuildContext context, VoidCallback onSuccess) {
  showDialog(
    context: context,
    builder: (_) => TranzaksiyaModal(onSuccess: onSuccess),
  );
}