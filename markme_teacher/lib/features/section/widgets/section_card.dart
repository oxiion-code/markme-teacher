import 'package:flutter/material.dart';
class SectionCard extends StatelessWidget {
  final String sectionData;
  final VoidCallback onDelete;

  const SectionCard({
    super.key,
    required this.sectionData,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final parts = sectionData.split("_");

    final branch = parts.isNotEmpty ? parts[0].toUpperCase() : "";
    final startYear = parts.length > 1 ? parts[1] : "";
    final endYear = parts.length > 2 ? parts[2] : "";
    final sectionName = parts.length > 3 ? parts[3].toUpperCase() : "";

    final theme = Theme.of(context);

    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black26,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Branch Circle Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(2, 3),
                  )
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                branch.isNotEmpty ? branch[0] : "",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Branch Name
            Text(
              branch,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 6),

            // Section
            Text(
              "Section: $sectionName",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 6),

            // Year range chip
            Chip(
              label: Text(
                "$startYear - $endYear",
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.primaryColor,
                ),
              ),
              backgroundColor: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            const Spacer(),

            // Delete button
            ElevatedButton.icon(
              onPressed: onDelete,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade500,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
              icon: const Icon(Icons.delete_outline, size: 20),
              label: const Text("Delete"),
            ),
          ],
        ),
      ),
    );
  }
}
