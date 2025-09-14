import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/cupertino.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_teacher/core/models/teacher.dart';
import 'package:markme_teacher/core/utils/app_utils.dart';
import 'package:markme_teacher/features/lesson_plan/bloc/lesoon_bloc.dart';
import 'package:markme_teacher/features/lesson_plan/bloc/lesson_event.dart';
import 'package:markme_teacher/features/lesson_plan/bloc/lesson_state.dart';
import 'package:markme_teacher/features/lesson_plan/models/lesson_plan_details.dart';

import '../models/lesson_plan.dart';

class LessonPlans extends StatefulWidget {
  final Teacher teacher;
  const LessonPlans({super.key, required this.teacher});

  @override
  State<LessonPlans> createState() => _LessonPlansState();
}

class _LessonPlansState extends State<LessonPlans> {
  @override
  void initState() {
    super.initState();
    context.read<LessonBloc>().add(
      LoadAllLessonsForTeacherEvent(widget.teacher.teacherId),
    );
  }

  List<LessonPlan> lessonPlans = [];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LessonBloc, LessonState>(
      listener: (context, state) {
        if (state is LessonLoading) {
          AppUtils.showCustomLoading(context);
        } else {
          AppUtils.hideCustomLoading(context);
        }
        if (state is LessonsLoadedForTeacher) {
          setState(() {
            lessonPlans = state.lessons;
          });
        } else if (state is LessonFailure) {
          AppUtils.showDialogMessage(context, state.message, "Sorry!!!");
        } else if (state is LessonDeletedForSubject) {
          AppUtils.showCustomSnackBar(context, "Lesson deleted");
          context.read<LessonBloc>().add(
            LoadAllLessonsForTeacherEvent(widget.teacher.teacherId),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Lesson Plans"),
            centerTitle: true,
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == "add") {
                    context
                        .push("/addLessonPlan", extra: widget.teacher)
                        .whenComplete(() {
                          context.read<LessonBloc>().add(
                            LoadAllLessonsForTeacherEvent(
                              widget.teacher.teacherId,
                            ),
                          );
                        });
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: "add",
                    child: Text("Add lesson plan"),
                  ),
                ],
              ),
            ],
          ),
          body: _buildLessons(lessonPlans, widget.teacher),
        );
      },
    );
  }
}

Widget _buildLessons(List<LessonPlan> lessonPlans, Teacher teacher) {
  if (lessonPlans.isEmpty) {
    return const Center(child: Text("No lesson plans added yet"));
  }
  return ListView.builder(
    itemCount: lessonPlans.length,
    itemBuilder: (context, index) {
      final lessonPlan = lessonPlans[index];
      final section = lessonPlan.sectionId.split("_").join("-").toUpperCase();
      return Card(
        color: Colors.blue.shade50,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          onTap: (){
            context.push("/lessonDetails",extra:LessonPlanDetails(teacher: teacher, lessonPlan: lessonPlan ));
          },
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Text(
              lessonPlan.subjectName[0].toUpperCase(),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              context.read<LessonBloc>().add(
                DeleteLessonFoeSubjectEvent(teacher.teacherId, lessonPlan),
              );
            },
            icon: Icon(Icons.delete, color: Colors.red),
          ),
          title: Text(lessonPlan.subjectName),
          subtitle: Text(section,style: Theme.of(context).textTheme.titleSmall,),
        ),
      );
    },
  );
}
