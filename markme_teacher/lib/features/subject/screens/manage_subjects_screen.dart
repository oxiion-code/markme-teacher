import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_teacher/core/models/teacher.dart';
import 'package:markme_teacher/core/utils/app_utils.dart';
import 'package:markme_teacher/core/widgets/app_nav_bar.dart';
import 'package:markme_teacher/features/subject/blocs/subject_bloc.dart';
import 'package:markme_teacher/features/subject/blocs/subject_event.dart';
import 'package:markme_teacher/features/subject/blocs/subject_state.dart';

import '../../../core/models/subject.dart';
import '../widgets/subject_container.dart';
class ManageSubjectsScreen extends StatefulWidget {
  final Teacher teacher;

  const ManageSubjectsScreen({super.key, required this.teacher});

  @override
  State<ManageSubjectsScreen> createState() => _ManageSubjectsScreenState();
}

class _ManageSubjectsScreenState extends State<ManageSubjectsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SubjectBloc>().add(
      GetAllSubjectsForTeacherEvent(widget.teacher.teacherId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppNavBar(
        title: "Manage Subjects",
        onTap: () {
          // Navigate to AddSubjectScreen
          context.push('/addSubject', extra: widget.teacher).whenComplete(() {
            // This will run no matter what, even if the user didn't add a subject
            context.read<SubjectBloc>().add(
              GetAllSubjectsForTeacherEvent(widget.teacher.teacherId),
            );
          });

        },
      ),
      body: BlocConsumer<SubjectBloc, SubjectState>(
        listener: (context, state) {
          if (state is SubjectLoading) {
            AppUtils.showCustomLoading(context);
          }
          else if (state is SubjectSuccess) {
            String msg = state.action == SubjectAction.add
                ? "Subject added successfully"
                : "Subject deleted successfully";
            AppUtils.showCustomSnackBar(context, msg);
            context.read<SubjectBloc>().add(
              GetAllSubjectsForTeacherEvent(widget.teacher.teacherId),
            );
          }
          else{
            AppUtils.hideCustomLoading(context);
          }

          if (state is SubjectFailure) {
            AppUtils.showCustomSnackBar(context, state.message);
          }

        },
        builder: (context, state) {
         if (state is SubjectsLoadedForTeacher) {
            final subjects = state.subjects;
            if (subjects.isEmpty) {
              return const Center(child: Text("No subjects added yet"));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 12,
                childAspectRatio: 0.63,
              ),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                return SubjectCard(
                  subject: subjects[index],
                  onDelete: () {
                    context.read<SubjectBloc>().add(
                      DeleteSubjectEvent(
                        subjects[index],
                        widget.teacher.teacherId,
                      ),
                    );
                  },
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
