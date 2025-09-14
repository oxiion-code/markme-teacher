import 'package:flutter/material.dart';
import 'package:markme_teacher/features/lesson_plan/models/lesson_topic.dart';


class LessonTopicSelectorSheet extends StatefulWidget {
  final int totalStudents;
  final int totalPresent;
  final int totalAbsent;
  final List<LessonTopic> topics;
  final LessonTopic? initiallySelected;

  const LessonTopicSelectorSheet({
    super.key,
    required this.totalStudents,
    required this.totalPresent,
    required this.totalAbsent,
    required this.topics,
    this.initiallySelected,
  });

  @override
  State<LessonTopicSelectorSheet> createState() =>
      _LessonTopicSelectorSheetState();
}

class _LessonTopicSelectorSheetState extends State<LessonTopicSelectorSheet> {
  LessonTopic? selectedTopic;

  @override
  void initState() {
    super.initState();
    selectedTopic = widget.initiallySelected;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const Text(
              "Attendance Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryCard("Total", widget.totalStudents, Colors.blue),
                _buildSummaryCard("Present", widget.totalPresent, Colors.green),
                _buildSummaryCard("Absent", widget.totalAbsent, Colors.red),
              ],
            ),
            const SizedBox(height: 16),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select Lesson Topic",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.separated(
                itemCount: widget.topics.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final topic = widget.topics[index];
                  final isSelected = selectedTopic?.number == topic.number; // ✅ compare by number

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    leading: CircleAvatar(
                      backgroundColor: isSelected
                          ? Colors.green.withOpacity(0.2)
                          : Colors.grey.shade200,
                      child: Text(
                        "${topic.number}", // ✅ make sure it's string
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.green : Colors.black,
                        ),
                      ),
                    ),
                    title: Text(topic.name),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedTopic = topic;
                      });
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: selectedTopic == null
                  ? null
                  : () => Navigator.of(context).pop(selectedTopic),
              icon: const Icon(Icons.check_circle),
              label: const Text("Mark Attendance"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String label, int count, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: Column(
          children: [
            Text(
              "$count",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
