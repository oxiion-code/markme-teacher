import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:markme_teacher/core/utils/app_utils.dart';
import 'package:markme_teacher/features/attendance/bloc/attendance_bloc.dart';
import 'package:markme_teacher/features/attendance/bloc/attendance_event.dart';
import 'package:markme_teacher/features/attendance/bloc/attendance_state.dart';
import 'package:markme_teacher/features/attendance/models/attendance_data.dart';
import 'package:markme_teacher/features/attendance/models/attendance_edit_data.dart';
import 'package:markme_teacher/features/class/bloc/class_bloc.dart';
import 'package:markme_teacher/features/class/bloc/class_event.dart';
import 'package:markme_teacher/features/class/bloc/class_state.dart';
import 'package:markme_teacher/features/class/models/class_session.dart';
import 'package:markme_teacher/features/class/widgets/class_ended_animation.dart';
import '../../../core/models/student.dart';

class LiveClassScreen extends StatelessWidget {
  final List<Student> students;
  final ClassSession classSession;

  const LiveClassScreen({
    super.key,
    required this.students,
    required this.classSession,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "${classSession.subjectName} - ${classSession.sectionName}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ClassBloc, ClassState>(
            listener: (context, state) {
              if (state is ClassLoading) {
                AppUtils.showCustomLoading(context);
              } else {
                AppUtils.hideCustomLoading(context);
              }
              if (state is EndedLiveClass) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return ClassEndAnimation();
                  },
                );
              } else if (state is ClassFailure) {
                AppUtils.showDialogMessage(context, state.message, "Sorry!");
              }
            },
          ),
          BlocListener<AttendanceBloc, AttendanceState>(
            listener: (context, state) {
              if (state is AttendanceLoading) {
                AppUtils.showCustomLoading(context);
              } else {
                AppUtils.hideCustomLoading(context);
              }
              if (state is AttendanceForClassCreated) {
                final attendance = AttendanceData(
                  attendanceId: state.attendanceId,
                  students: students,
                  teacherId: classSession.teacherId,
                  sectionId: classSession.sectionId,
                  subjectId: classSession.subjectId
                );
                context.push("/takeAttendance", extra: attendance);
              } else if (state is AttendanceAlreadyTaken) {
                final uniquePart = classSession.classId.replaceFirst("CLS-", "");
                final attendanceId = "ATD-$uniquePart";
                final lessonTopic=state.lessonTopic;
                final studentsData = AttendanceEditData(
                  sectionId: classSession.sectionId,
                  subjectId: classSession.subjectId,
                  students: students,
                  presentStudents: state.presentStudents,
                  attendanceId: attendanceId,
                  teacherId: classSession.teacherId,
                  lessonTopic: lessonTopic
                );
                context.push("/editLiveAttendance", extra: studentsData);
              } else if (state is AttendanceCreationFailure) {
                AppUtils.showDialogMessage(
                  context,
                  state.message,
                  "Some Issues!",
                );
              }
            },
          ),
        ],
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: _ClassDetailsCard(classSession: classSession),
              ),
              Expanded(
                child: students.isEmpty
                    ? const Center(
                        child: Text(
                          "No students found",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        itemCount: students.length,
                        separatorBuilder: (_, __) => const Divider(height: 0),
                        itemBuilder: (context, index) {
                          final student = students[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 4,
                              ),
                              leading: CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.blueGrey,
                                backgroundImage:
                                    student.profilePhotoUrl.isNotEmpty
                                    ? NetworkImage(student.profilePhotoUrl)
                                    : null,
                                child: student.profilePhotoUrl.isEmpty
                                    ? Icon(
                                        Icons.person,
                                        color: Colors.blueGrey,
                                        size: 28,
                                      )
                                    : null,
                              ),
                              title: Text(
                                student.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                "Roll No: ${student.rollNo}",
                                style: const TextStyle(fontSize: 13),
                              ),
                              trailing: Icon(
                                Icons.check_circle_rounded,
                                color: Colors.green,
                                size: 28,
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          context.read<AttendanceBloc>().add(
                            CreateOrGetAttendanceForLiveClass(
                              students,
                              classSession,
                            ),
                          );
                        },
                        icon: const Icon(Icons.fact_check),
                        label: const Text(
                          "Take Attendance",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          AppUtils.showEndClassConfirmation(
                            context: context,
                            onConfirmDelete: () {
                              context.read<ClassBloc>().add(
                                EndClassEvent(
                                  classSession.classId,
                                  classSession.teacherId,
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.stop_circle),
                        label: const Text(
                          "End Class",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClassDetailsCard extends StatelessWidget {
  final ClassSession classSession;

  const _ClassDetailsCard({required this.classSession});

  @override
  Widget build(BuildContext context) {
    final startTime = DateTime.parse("${classSession.startTime}");
    final endTime = DateTime.parse("${classSession.endTime}");
    final timeFormat12 = DateFormat('h:mm a');
    final formattedTime =
        '${timeFormat12.format(startTime)} - ${timeFormat12.format(endTime)}';
    final date = DateTime.parse(classSession.date.toString().split(" ")[0]);
    final formattedDate = DateFormat('dd-MM-yyyy').format(date);
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text(
                  "Class Details",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    classSession.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: classSession.status.toLowerCase() == 'active'
                      ? Colors.green
                      : Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDetail(
                    icon: Icons.book_outlined,
                    label: "Subject",
                    value: classSession.subjectName,
                  ),
                ),
                Expanded(
                  child: _buildDetail(
                    icon: Icons.group_outlined,
                    label: "Section",
                    value: classSession.sectionName,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _buildDetail(
                    icon: Icons.person_outline,
                    label: "Teacher",
                    value: classSession.teacherName,
                  ),
                ),
                Expanded(
                  child: _buildDetail(
                    icon: Icons.meeting_room_outlined,
                    label: "Room",
                    value: classSession.roomName,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Column(
              children: [
                _buildDetail(
                  icon: Icons.calendar_today_outlined,
                  label: "Date",
                  value: formattedDate,
                ),
                _buildDetail(
                  icon: Icons.access_time_outlined,
                  label: "Time",
                  value: formattedTime,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 6),
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
