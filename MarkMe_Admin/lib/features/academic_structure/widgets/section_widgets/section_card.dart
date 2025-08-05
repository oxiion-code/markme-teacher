import 'package:flutter/material.dart';

import '../../models/section.dart';
 // update the import path as per your model

class SectionCard extends StatelessWidget {
  final Section section;
  final VoidCallback onDelete;

  const SectionCard({
    super.key,
    required this.section,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text("Section: ${section.sectionName}"),
        subtitle: Text("Batch: ${section.batchId},\nBranch: ${section.branchId}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
