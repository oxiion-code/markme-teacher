import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_teacher/core/models/student.dart';
import 'package:markme_teacher/core/theme/color_palette.dart';
import 'package:markme_teacher/core/utils/app_utils.dart';
import 'package:markme_teacher/features/attendance/bloc/attendance_bloc.dart';
import 'package:markme_teacher/features/attendance/bloc/attendance_event.dart';
import 'package:markme_teacher/features/attendance/bloc/attendance_state.dart';
import 'package:markme_teacher/features/lesson_plan/bloc/lesoon_bloc.dart';
import 'package:markme_teacher/features/lesson_plan/bloc/lesson_event.dart';
import 'package:markme_teacher/features/lesson_plan/bloc/lesson_state.dart';
import 'package:markme_teacher/features/lesson_plan/models/lesson_topic.dart';

import '../widgets/edit_lesson_topic_selector_sheet.dart';

class EditLiveAttendanceScreen extends StatefulWidget {
  final Map<String, bool> presentStudents;
  final List<Student> allStudents;
  final String attendanceId;
  final String teacherId;
  final String subjectId;
  final String sectionId;
  final LessonTopic lessonTopic;

  const EditLiveAttendanceScreen({
    super.key,
    required this.presentStudents,
    required this.allStudents,
    required this.attendanceId,
    required this.lessonTopic,
    required this.teacherId,
    required this.subjectId,
    required this.sectionId,
  });

  @override
  State<EditLiveAttendanceScreen> createState() =>
      _EditLiveAttendanceScreenState();
}

class _EditLiveAttendanceScreenState extends State<EditLiveAttendanceScreen> {
  late Map<String, bool> updatedSelection;
  LessonTopic? selectedLessonTopic;

  @override
  void initState() {
    super.initState();

    // ✅ Initialize updatedSelection with presentStudents pre-marked
    updatedSelection = {
      for (var student in widget.allStudents)
        student.id: widget.presentStudents[student.id] ?? false,
    };

    // ✅ Preselect the topic from widget
    selectedLessonTopic = widget.lessonTopic;
  }

  void selectAll() {
    setState(() {
      for (var id in updatedSelection.keys) {
        updatedSelection[id] = true;
      }
    });
  }

  void clearAll() {
    setState(() {
      for (var id in updatedSelection.keys) {
        updatedSelection[id] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AttendanceBloc, AttendanceState>(
          listener: (context, state) {
            if (state is AttendanceLoading) {
              AppUtils.showCustomLoading(context);
            } else {
              AppUtils.hideCustomLoading(context);
            }
            if (state is AttendanceMarkedForLiveClass) {
              AppUtils.showCustomSnackBar(
                context,
                "Updated attendance for class",
              );
              context.pop();
            } else if (state is AttendanceDeleted) {
              AppUtils.showCustomSnackBar(
                context,
                "Deleted attendance of current class",
              );
              context.pop();
            } else if (state is AttendanceMarkFailure) {
              AppUtils.showDialogMessage(context, state.message, "Sorry!");
            } else if (state is AttendanceDeletionFailure) {
              AppUtils.showDialogMessage(context, state.message, "Sorry!");
            }
          },
        ),
        BlocListener<LessonBloc, LessonState>(
          listener: (context, state) {
            if (state is LessonLoading) {
              AppUtils.showCustomLoading(context);
            } else {
              AppUtils.hideCustomLoading(context);
            }
            if (state is LessonPlanLoadedForAttendance) {
              final lessonPlan = state.lessonPlan;

              final totalStudents = updatedSelection.length;
              final presentStudents = updatedSelection.entries
                  .where((e) => e.value)
                  .map((e) => e.key)
                  .toList();
              final totalPresent = presentStudents.length;
              final totalAbsent = totalStudents - totalPresent;

              final parentContext = context;

              showModalBottomSheet<LessonTopic>(
                context: parentContext,
                isScrollControlled: true,
                builder: (context) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: LessonTopicSelectorSheet(
                      totalStudents: totalStudents,
                      totalPresent: totalPresent,
                      totalAbsent: totalAbsent,
                      topics: lessonPlan.topics,
                      initiallySelected: selectedLessonTopic, // ✅ highlight
                    ),
                  );
                },
              ).then((chosenTopic) {
                if (chosenTopic != null) {
                  // Store selection
                  setState(() {
                    selectedLessonTopic = chosenTopic;
                  });

                  // Fire attendance event
                  parentContext.read<AttendanceBloc>().add(
                    MarkAttendanceForLiveClass(
                      widget.attendanceId,
                      updatedSelection,
                      widget.teacherId,
                      "Manual",
                      chosenTopic,
                      widget.sectionId,
                    ),
                  );
                }
              });
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Live Attendance"),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'save') {
                  if (selectedLessonTopic == null) {
                    AppUtils.showDialogMessage(
                      context,
                      "Please select a topic before saving",
                      "Missing Topic",
                    );
                    return;
                  }
                  context.read<LessonBloc>().add(
                    LoadLessonPlanForAttendanceEvent(
                      teacherId: widget.teacherId,
                      sectionId: widget.sectionId,
                      subjectId: widget.subjectId,
                    ),
                  );
                } else if (value == 'delete') {
                  if (selectedLessonTopic == null) {
                    AppUtils.showDialogMessage(
                      context,
                      "No lesson topic found for deletion",
                      "Missing Topic",
                    );
                    return;
                  }
                  final uniquePart =
                  widget.attendanceId.replaceFirst("ATD-", "");
                  final classId = "CLS-$uniquePart";
                  context.read<AttendanceBloc>().add(
                    DeleteLiveAttendanceEvent(
                      sectionId: widget.sectionId,
                      teacherId: widget.teacherId,
                      attendanceId: widget.attendanceId,
                      classId: classId,
                      lessonNumber: selectedLessonTopic!.number
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'save',
                  child: Text('Save Attendance'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete Attendance'),
                ),
              ],
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Controls
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: selectAll,
                      icon: const Icon(Icons.select_all),
                      label: const Text("Select all"),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: clearAll,
                      icon: const Icon(Icons.clear),
                      label: const Text("Clear all"),
                    ),
                  ],
                ),
              ),
              // Students list
              Expanded(
                child: ListView.separated(
                  itemCount: widget.allStudents.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final student = widget.allStudents[index];
                    final isChecked = updatedSelection[student.id] ?? false;

                    return Card(
                      color: isChecked ? Colors.blue.shade100 : null,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 3,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            student.name[0].toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          student.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text("Roll No: ${student.rollNo}"),
                        trailing: Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.green,
                          value: isChecked,
                          onChanged: (val) {
                            setState(() {
                              updatedSelection[student.id] = val ?? false;
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            updatedSelection[student.id] = !isChecked;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
