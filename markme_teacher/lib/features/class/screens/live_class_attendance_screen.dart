import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:markme_teacher/core/models/student.dart';
import 'package:markme_teacher/core/theme/color_palette.dart';
import 'package:markme_teacher/core/utils/app_utils.dart';
import 'package:markme_teacher/features/attendance/bloc/attendance_bloc.dart';
import 'package:markme_teacher/features/attendance/bloc/attendance_event.dart';
import 'package:markme_teacher/features/attendance/bloc/attendance_state.dart';
import 'package:markme_teacher/features/lesson_plan/bloc/lesson_event.dart';
import 'package:markme_teacher/features/lesson_plan/bloc/lesson_state.dart';

import '../../lesson_plan/bloc/lesoon_bloc.dart';
import '../../lesson_plan/models/lesson_topic.dart';
import '../widgets/attendance_summary_bottom_sheet.dart';

class LiveClassAttendanceScreen extends StatefulWidget {
  final String attendanceId;
  final String teacherId;
  final String sectionId;
  final String subjectId;
  final List<Student> students;

  const LiveClassAttendanceScreen({
    super.key,
    required this.attendanceId,
    required this.students,
    required this.teacherId,
    required this.sectionId,
    required this.subjectId,
  });

  @override
  State<LiveClassAttendanceScreen> createState() =>
      _LiveClassAttendanceScreenState();
}

class _LiveClassAttendanceScreenState extends State<LiveClassAttendanceScreen> {
  String mode = "Manual";
  final Map<String, bool> selectedStudents = {};
  LessonTopic? selectedTopic;

  @override
  void initState() {
    super.initState();
    for (var student in widget.students) {
      selectedStudents[student.id] = false;
    }
  }

  void selectAll() {
    setState(() {
      for (var id in selectedStudents.keys) {
        selectedStudents[id] = true;
      }
    });
  }

  void clearAll() {
    setState(() {
      for (var id in selectedStudents.keys) {
        selectedStudents[id] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// Attendance Listener
        BlocListener<AttendanceBloc, AttendanceState>(
          listener: (context, state) {
            if (state is AttendanceLoading) {
              AppUtils.showCustomLoading(context);
            } else {
              AppUtils.hideCustomLoading(context);
            }

            if (state is AttendanceMarkedForLiveClass) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset(
                          "assets/animations/Success.json",
                          repeat: false,
                          onLoaded: (composition) async {
                            await Future.delayed(
                              composition.duration + const Duration(seconds: 1),
                            );
                            if (mounted) {
                              Navigator.of(context).pop(); // close dialog
                              Navigator.of(context).pop();
                              // go back
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Attendance Marked Successfully!",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is AttendanceMarkFailure) {
              AppUtils.showDialogMessage(context, state.message, "Sorry!");
            }
          },
        ),

        /// Lesson Listener
        BlocListener<LessonBloc, LessonState>(
          listener: (context, state) {
            if (state is LessonLoading) {
              AppUtils.showCustomLoading(context);
            } else {
              AppUtils.hideCustomLoading(context);
            }

            if (state is LessonPlanLoadedForAttendance) {
              debugPrint("✅ LessonPlanLoadedForAttendance triggered");

              final lessonPlan = state.lessonPlan;

              final totalStudents = selectedStudents.length;
              final presentStudents = selectedStudents.entries
                  .where((e) => e.value)
                  .map((e) => e.key)
                  .toList();
              final totalPresent = presentStudents.length;
              final totalAbsent = totalStudents - totalPresent;
              final parentContext=context;

              showModalBottomSheet(
                context:parentContext,
                isScrollControlled: true,
                builder: (context) {
                  return AttendanceSummaryBottomSheet(
                    totalStudents: totalStudents,
                    presentStudents: totalPresent,
                    absentStudents: totalAbsent,
                    topics: lessonPlan.topics,
                    initiallySelected: selectedTopic,
                    onConfirm: (chosenTopic) {
                      parentContext.read<AttendanceBloc>().add(
                        MarkAttendanceForLiveClass(
                          widget.attendanceId,
                          selectedStudents,
                          widget.teacherId,
                          mode,
                          chosenTopic,
                          widget.sectionId,
                        ),
                      );
                    },
                  );
                },
              );
            }

          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Live Class Attendance"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              /// Mode Selection
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      selectedColor: AppColors.primaryDark,
                      label: const Text("Manual"),
                      selected: mode == "Manual",
                      onSelected: (_) => setState(() => mode = "Manual"),
                    ),
                    const SizedBox(width: 12),
                    ChoiceChip(
                      selectedColor: AppColors.primaryDark,
                      label: const Text("Bluetooth"),
                      selected: mode == "Bluetooth",
                      onSelected: (_) => setState(() => mode = "Bluetooth"),
                    ),
                  ],
                ),
              ),

              /// Select / Clear All
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 4.0,
                ),
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

              /// Students List
              Expanded(
                child: ListView.separated(
                  itemCount: widget.students.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final student = widget.students[index];
                    final isChecked = selectedStudents[student.id] ?? false;

                    return Card(
                      color: isChecked ? Colors.blue.shade100 : null,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            student.name[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(student.name),
                        subtitle: Text("Roll No: ${student.rollNo}"),
                        trailing: Checkbox(
                          value: isChecked,
                          onChanged: (val) {
                            setState(() {
                              selectedStudents[student.id] = val ?? false;
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            selectedStudents[student.id] = !isChecked;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),

              /// Confirm Button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<LessonBloc>().add(
                        LoadLessonPlanForAttendanceEvent(
                          teacherId: widget.teacherId,
                          sectionId: widget.sectionId,
                          subjectId: widget.subjectId,
                        ),
                      );
                      debugPrint("ok till here");
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text("Confirm Attendance",style: TextStyle(
                      fontSize: 18
                    ),),
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
