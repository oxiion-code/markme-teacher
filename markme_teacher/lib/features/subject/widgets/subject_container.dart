import 'package:flutter/material.dart';
import '../../../core/models/subject.dart';
class SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback? onTap;
  final VoidCallback onDelete;

  const SubjectCard({
    super.key,
    required this.subject,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final batchString = subject.batchId;
    final parts = batchString.split('_');
    final batch = "${parts[1]}-${parts[2]}";

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shadowColor: Colors.blue.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.blue.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circle avatar with first letter
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue.shade600,
                child: Text(
                  subject.subjectName.isNotEmpty
                      ? subject.subjectName[0].toUpperCase()
                      : "?",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Subject name styled
              Text(
                subject.subjectName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: Colors.blue.shade900,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Branch + Batch chips
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: [
                  Chip(
                    avatar: const Icon(Icons.school, size: 18, color: Colors.white),
                    label: Text(subject.branchId.toUpperCase()),
                    backgroundColor: Colors.blue.shade400,
                    labelStyle: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Chip(
                    avatar: const Icon(Icons.calendar_today, size: 18, color: Colors.white),
                    label: Text(batch),
                    backgroundColor: Colors.teal.shade400,
                    labelStyle: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Delete button as small rounded red button
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.shade100,
                  ),
                  child: IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red.shade700,
                      size: 26,
                    ),
                    tooltip: "Delete Subject",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
