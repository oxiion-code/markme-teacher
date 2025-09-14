import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_teacher/core/models/section.dart';
import 'package:markme_teacher/core/models/subject.dart';
import 'package:markme_teacher/core/models/teacher.dart';
import 'package:markme_teacher/core/utils/app_utils.dart';
import 'package:markme_teacher/features/class/bloc/class_bloc.dart';
import 'package:markme_teacher/features/class/bloc/class_event.dart';
import 'package:markme_teacher/features/class/bloc/class_state.dart';
import 'package:markme_teacher/features/class/models/class_session.dart';

import '../../class/models/class_start_data.dart';

class StartClassBottomSheet extends StatefulWidget {
  final Section section;
  final List<Subject> subjects;
  final Teacher teacher;
  final Function(ClassSession) onStartClassClick;

  const StartClassBottomSheet({
    super.key,
    required this.section,
    required this.subjects,
    required this.teacher,
    required this.onStartClassClick,
  });

  @override
  State<StartClassBottomSheet> createState() => _StartClassBottomSheetState();
}

class _StartClassBottomSheetState extends State<StartClassBottomSheet> {
  List<Subject> filteredSubjects = [];
  Subject? selectedSubject;
  String? batch;
  late TextEditingController roomController;

  late DateTime selectedStartTime;
  double selectedDuration = 1;

  DateTime get endTime =>
      selectedStartTime.add(Duration(minutes: (selectedDuration * 60).toInt()));
  String selectedGroup = "All";

  @override
  void initState() {
    super.initState();

    // ✅ Filter subjects by batchId
    filteredSubjects = widget.subjects
        .where((sub) => sub.batchId == widget.section.batchId)
        .toList();

    if (filteredSubjects.isNotEmpty) {
      selectedSubject = filteredSubjects.first;
    }

    final parts = widget.section.batchId.split("_");
    batch = "${parts[1]}-${parts[2]}";
    roomController = TextEditingController(
      text: widget.section.defaultRoom ?? "",
    );

    // auto-select slot based on current time
    final slots = getTimeSlots();
    selectedStartTime = _getDefaultSlot(slots);
  }

  //// Generate time slots (8:00, 9:00, then only :30 slots after 10)
  List<DateTime> getTimeSlots() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    List<DateTime> slots = [];

    // Morning hours
    slots.add(DateTime(today.year, today.month, today.day, 8, 0));
    slots.add(DateTime(today.year, today.month, today.day, 9, 0));

    // From 10:30 onwards → only :30 slots
    for (int hour = 10; hour <= 13; hour++) {
      slots.add(DateTime(today.year, today.month, today.day, hour, 30));
    }

    return slots;
  }

  /// Pick default slot nearest to current time
  DateTime _getDefaultSlot(List<DateTime> slots) {
    final now = DateTime.now();
    for (final slot in slots) {
      if (slot.isAfter(now)) return slot;
    }
    return slots.last; // fallback
  }

  @override
  void dispose() {
    roomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slots = getTimeSlots();
    return SingleChildScrollView(
      child: BlocListener<ClassBloc, ClassState>(
        listener: (context, state) {
          if (state is ClassLoading) {
            AppUtils.showCustomLoading(context);
          } else {
            AppUtils.hideCustomLoading(context);
          }
          if (state is ClassStarted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              context.push(
                "/liveClass",
                extra: ClassStartData(
                  students: state.students,
                  classSession: state.classData,
                ),
              );
            });
            return;
          } else if (state is ClassFailure) {
            AppUtils.showDialogMessage(
              context,
              state.message,
              "Failed to start class",
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle
            Center(
              child: Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            // Section card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        MaterialCommunityIcons.google_classroom,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.section.sectionName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Batch: $batch   |   ${widget.section.branchId.toUpperCase()}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Subject chips
            Text(
              "Select Subject",
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            filteredSubjects.isEmpty
                ? const Text(
              "No subjects available for this batch",
              style: TextStyle(color: Colors.red, fontSize: 14),
            )
                : Wrap(
              spacing: 10,
              runSpacing: 10,
              children: filteredSubjects.map((subject) {
                final isSelected = subject == selectedSubject;
                return ChoiceChip(
                  label: Text(subject.subjectName),
                  selected: isSelected,
                  selectedColor: Colors.blue.shade600,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                  onSelected: (_) {
                    setState(() {
                      selectedSubject = subject;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Room input
            Text(
              "Classroom / Room",
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: roomController,
              decoration: InputDecoration(
                hintText:
                "Enter room (Default: ${widget.section.defaultRoom ?? "N/A"})",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.meeting_room_outlined),
              ),
            ),

            const SizedBox(height: 20),

            // Time slots
            Text(
              "Start Time Slot",
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: slots.map((slot) {
                final isSelected = slot == selectedStartTime;
                final slotText =
                    "${slot.hour.toString().padLeft(2, '0')}:${slot.minute.toString().padLeft(2, '0')}";
                return ChoiceChip(
                  label: Text(slotText),
                  selected: isSelected,
                  selectedColor: Colors.blue.shade600,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                  onSelected: (_) {
                    setState(() {
                      selectedStartTime = slot;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Duration + Group Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Duration Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Duration",
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [1, 2].map((d) {
                          final isSelected = selectedDuration == d.toDouble();
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ChoiceChip(
                              label: Text("$d hr"),
                              selected: isSelected,
                              selectedColor: Colors.blue.shade600,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              onSelected: (_) {
                                setState(() {
                                  selectedDuration = d.toDouble();
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // Group Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group",
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedGroup,
                        items: ["All", "GROUP 1", "GROUP 2"]
                            .map(
                              (g) => DropdownMenuItem(value: g, child: Text(g)),
                        )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedGroup = value!;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // End time
            Text(
              "End Time: ${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 30),

            // Start class button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  elevation: 3,
                ),
                onPressed: selectedSubject == null
                    ? null
                    : () {
                  // Prepare final values
                  final selectedRoom =
                  roomController.text.trim().isNotEmpty
                      ? roomController.text.trim()
                      : widget.section.defaultRoom ?? "Unknown";

                  final classSession = ClassSession(
                    semesterNo: widget.section.currentSemesterNumber,
                    classId: "",
                    subjectId: selectedSubject!.subjectId,
                    subjectName: selectedSubject!.subjectName,
                    sectionId: widget.section.sectionId,
                    sectionName: widget.section.sectionName,
                    teacherId: widget.teacher.teacherId,
                    teacherName: widget.teacher.teacherName,
                    roomName: selectedRoom,
                    date: DateTime.now(),
                    startTime: selectedStartTime,
                    endTime: endTime,
                    status: "live",
                    sessionType: selectedSubject!.subjectType,
                    group: selectedGroup,
                  );

                  if (widget.teacher.liveClassId == null) {
                    context.read<ClassBloc>().add(
                      StartClassEvent(classSession),
                    );
                  } else {
                    AppUtils.showDialogMessage(
                      context,
                      "You already have a live class in progress. Please end it before starting a new one.",
                      "Live Class Already Running",
                    );
                  }
                },
                child: const Text(
                  "🚀 Start Class",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
