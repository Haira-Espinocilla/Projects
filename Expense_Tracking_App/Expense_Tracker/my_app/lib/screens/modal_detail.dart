import 'package:flutter/material.dart';
import '../../../../models/todo_model.dart';

//to display the full details of an entry
class DetailModal extends StatelessWidget {
  final Todo item;

  const DetailModal({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Expense Details"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Name: ${item.title}"),
          const SizedBox(height: 8),
          Text("Description: ${item.description ?? 'N/A'}"),
          const SizedBox(height: 8),
          Text("Category: ${item.category ?? 'N/A'}"),
          const SizedBox(height: 8),
          Text("Amount: Php ${item.amount?.toStringAsFixed(2) ?? '0.00'}"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
      ],
    );
  }
}
