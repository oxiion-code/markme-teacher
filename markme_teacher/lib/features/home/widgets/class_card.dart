import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class ClassCard extends StatelessWidget {
  final String branchName;
  final String batchName;
  final String sectionName;
  final VoidCallback onPressed;

  const ClassCard({
    super.key,
    required this.branchName,
    required this.batchName,
    required this.sectionName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      margin: const EdgeInsets.all(8),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Class Icon
            CircleAvatar(
              radius: 22,
              backgroundColor: theme.primaryColor.withOpacity(0.15),
              child: Icon(
                MaterialCommunityIcons.google_classroom,
                size: 24,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            // Main Title
            Text(
              branchName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Details Vertical
            _DetailItem(
              icon: Icons.calendar_today,
              label: 'Batch',
              value: batchName,
            ),
            const SizedBox(height: 6),
            _DetailItem(
              icon: Icons.segment_rounded,
              label: 'Section',
              value: sectionName,
            ),
            const Spacer(),
            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  backgroundColor: theme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.play_circle_fill, size: 20),
                label: const Text(
                  "Start Class",
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: onPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper for vertically aligned details
class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.indigo.shade300),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
