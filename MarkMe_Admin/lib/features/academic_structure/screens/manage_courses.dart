import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/features/academic_structure/bloc/course_bloc/course_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/course_bloc/course_state.dart';
import 'package:markme_admin/features/academic_structure/widgets/course_widgets/add_course_bottom_sheet.dart';
import 'package:markme_admin/features/academic_structure/widgets/course_widgets/course_container.dart';
import 'package:markme_admin/features/academic_structure/widgets/course_widgets/edit_course_bottom_sheet.dart';

import '../../../core/theme/color_scheme.dart';
import '../bloc/course_bloc/course_event.dart';

class ManageCourses extends StatefulWidget {
  const ManageCourses({super.key});

  @override
  State<ManageCourses> createState() => _ManageCoursesState();
}

class _ManageCoursesState extends State<ManageCourses> {
  @override
  void initState() {
    context.read<CourseBloc>().add(LoadCourses());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg, // use a soft light background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.secondary,
        iconTheme: IconThemeData(color: AppColors.primaryDark),
        title: Text(
          'Manage Courses',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDark,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: Colors.indigo, // Change as needed
              foregroundColor: Colors.white,
              elevation: 3,
            ),
            child: const Icon(Icons.add, size: 20),
            onPressed: () {
              final courseBloc = context
                  .read<CourseBloc>(); // get the bloc from the current context
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) {
                  return BlocProvider.value(
                    value: courseBloc,
                    child: AddCourseBottomSheet(
                      onAddClicked: (course) {
                        courseBloc.add(AddCourseEvent(course));
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocListener<CourseBloc, CourseState>(
        listener: (context, state) {
          if (state is CourseLoading) {
            AppUtils.showCustomLoading(context);
          } else if (state is CourseError) {
            Navigator.of(context).pop(); // close loader
            AppUtils.showCustomSnackBar(context, state.message);
          } else if (state is CourseLoaded) {
            Navigator.of(context).pop(); // close loader
          }
        },
        child: BlocBuilder<CourseBloc, CourseState>(
          builder: (context, state) {
            if (state is CourseLoading && state is! CourseLoaded) {
            } else if (state is CourseLoaded) {
              final courses = state.courses;

              if (courses.isEmpty) {
                return SizedBox.expand(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.eyeglasses,size: 70,),
                      Text("No courses added yet.",style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 20
                      ),)
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return CourseContainer(
                    course: course,
                    onEdit: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) {
                          return EditCourseBottomSheet(
                            onSaveEdit: (updatedCourse) {
                              context.read<CourseBloc>().add(
                                UpdateCourseEvent(updatedCourse),
                              );
                            },
                            course: course,
                          );
                        },
                      );
                    },
                    onDelete: () {
                      context.read<CourseBloc>().add(DeleteCourseEvent(course));
                    },
                  );
                },
              );
            } else if (state is CourseError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
