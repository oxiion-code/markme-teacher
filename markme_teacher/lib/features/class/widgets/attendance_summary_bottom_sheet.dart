import 'package:flutter/material.dart';
import '../../lesson_plan/models/lesson_topic.dart';

class AttendanceSummaryBottomSheet extends StatefulWidget {
  final int totalStudents;
  final int presentStudents;
  final int absentStudents;
  final List<LessonTopic> topics;
  final LessonTopic? initiallySelected;
  final Function(LessonTopic selected) onConfirm;

  const AttendanceSummaryBottomSheet({
    super.key,
    required this.totalStudents,
    required this.presentStudents,
    required this.absentStudents,
    required this.topics,
    this.initiallySelected,
    required this.onConfirm,
  });

  @override
  State<AttendanceSummaryBottomSheet> createState() =>
      _AttendanceSummaryBottomSheetState();
}

class _AttendanceSummaryBottomSheetState
    extends State<AttendanceSummaryBottomSheet> {
  LessonTopic? selectedTopic;

  @override
  void initState() {
    super.initState();
    selectedTopic = widget.initiallySelected;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [BoxShadow(blurRadius: 18, color: Colors.black12)],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                // Handle bar
                Container(
                  height: 6,
                  width: 56,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                // Title
                Text(
                  "Attendance Summary",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),

                // Summary Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _modernSummaryCard(
                      Icons.people,
                      "Total",
                      widget.totalStudents,
                      [Colors.blue, Colors.blueAccent],
                    ),
                    _modernSummaryCard(
                      Icons.check_circle,
                      "Present",
                      widget.presentStudents,
                      [Colors.green, Colors.lightGreen],
                    ),
                    _modernSummaryCard(
                      Icons.cancel,
                      "Absent",
                      widget.absentStudents,
                      [Colors.redAccent, Colors.orange],
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Divider(color: theme.dividerColor, thickness: 1.2),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      "Select Lesson Topic",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.hintColor,
                      ),
                    ),
                  ),
                ),

                // Topics List (Scrollable)
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: widget.topics.length,
                    itemBuilder: (context, index) {
                      final topic = widget.topics[index];
                      final isSelected = selectedTopic == topic;
                      final isCompleted = topic.isCompleted;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: isCompleted
                                ? Colors.green
                                : (isSelected
                                ? theme.colorScheme.primary
                                : theme.dividerColor),
                            width: 2,
                          ),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isCompleted
                                ? Colors.green.shade200
                                : (isSelected
                                ? Colors.blue.shade200
                                : Colors.grey.shade300),
                            child: Text(
                              topic.number,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isCompleted
                                    ? Colors.green.shade900
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          title: Text(
                            topic.name, // ✅ full name shown
                            style: TextStyle(
                              fontWeight:
                              isCompleted ? FontWeight.w700 : FontWeight.w500,
                              color: isCompleted
                                  ? Colors.green.shade700
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          trailing: isCompleted
                              ? const Icon(Icons.check_circle,
                              color: Colors.green)
                              : (isSelected
                              ? const Icon(Icons.radio_button_checked,
                              color: Colors.blue)
                              : const Icon(Icons.radio_button_off,
                              color: Colors.grey)),
                          onTap: isCompleted
                              ? null
                              : () {
                            setState(() => selectedTopic = topic);
                          },
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Fixed Button at Bottom
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      backgroundColor: theme.colorScheme.primary,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    onPressed: selectedTopic == null
                        ? null
                        : () {
                      Navigator.of(context).pop();
                      widget.onConfirm(selectedTopic!);
                    },
                    icon: const Icon(Icons.check_circle,
                        size: 24, color: Colors.white),
                    label: const Text(
                      "Mark Attendance",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Gradient summary card
  Widget _modernSummaryCard(
      IconData icon,
      String label,
      int count,
      List<Color> gradientColors,
      ) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(height: 4),
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
