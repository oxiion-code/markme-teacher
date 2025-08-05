import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/core/widgets/app_nav_bar.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/teacher/bloc/teacher_bloc.dart';
import 'package:markme_admin/features/teacher/bloc/teacher_event.dart';
import 'package:markme_admin/features/teacher/bloc/teacher_state.dart';
import 'package:markme_admin/features/teacher/widgets/teacher_card.dart';

import '../models/teacher.dart';
import '../widgets/add_teacher_bottom_sheet.dart';

class ManageTeachers extends StatefulWidget {
  const ManageTeachers({super.key});

  @override
  State<ManageTeachers> createState() => _ManageTeachersState();
}

class _ManageTeachersState extends State<ManageTeachers> {
  List<Branch>? branches;

  @override
  void initState() {
    super.initState();
    context.read<TeacherBloc>().add(LoadBranchesForTeacherEvent());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppNavBar(
        title: "Manage Teachers",
        onTap: () {
          if (branches != null) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => AddTeacherBottomSheet(
                branches: branches!,
                onAddTeacherClick: ({
                  required teacherId,
                  required name,
                  required email,
                  required branchId,
                }) {
                  final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
                  context.read<TeacherBloc>().add(
                    AddTeacherEvent(
                      Teacher(
                        teacherId: teacherId,
                        teacherName: name,
                        email: email,
                        branchId: branchId,
                        phoneNumber: "",
                        profilePhotoUrl: "",
                        gender: "",
                        assignedClasses: [],
                        dateOfJoining: currentDate,
                        designation: "",
                        role: "",
                        subjects: [],
                        totalPoints: "",
                        deviceToken: ""
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            AppUtils.showDialogMessage(
              context,
              "Branches not loaded",
              "Please wait a moment.",
            );
          }
        },
      ),
      body: BlocConsumer<TeacherBloc, TeacherState>(
        listener: (context, state) {
          if (state is TeacherLoading) {
            AppUtils.showCustomLoading(context);
          } else {
            Navigator.of(context, rootNavigator: true).maybePop();
          }

          if (state is TeacherSuccess) {
            AppUtils.showCustomSnackBar(context, "Operation successful");
          }else if (state is LoadBranchesForTeacher) {
            setState(() {
              branches = state.branches;
            });
            context.read<TeacherBloc>().add(LoadTeachersEvent());
          }else if (state is TeacherError) {
            AppUtils.showCustomSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is TeachersLoaded) {
            final teachers = state.teachers;
            if (teachers.isEmpty) {
              return const Center(child: Text("No teachers added yet"));
            }

            return Padding(
              padding: EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: teachers.length,
                itemBuilder: (context, index) {
                  final reversedTeachers = teachers.reversed.toList();
                  final teacher = reversedTeachers[index];
                  return TeacherCard(
                    teacher: teacher,
                    onDelete: () => AppUtils.showDeleteConfirmation(context: context, onConfirmDelete: (){
                      context.read<TeacherBloc>().add(DeleteTeacherEvent(teacher));
                    }),
                  );
                },
              ),
            );
          }

          return const Center(child: Text("No teachers added yet"));
        },
      ),
    );
  }
}
