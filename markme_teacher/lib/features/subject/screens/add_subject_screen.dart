import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_teacher/core/models/academic_batch.dart';
import 'package:markme_teacher/core/models/course.dart';
import 'package:markme_teacher/core/models/subject.dart';
import 'package:markme_teacher/core/utils/app_utils.dart';
import 'package:markme_teacher/core/widgets/app_nav_bar_wadd.dart';

import 'package:markme_teacher/features/subject/blocs/subject_bloc.dart';
import 'package:markme_teacher/features/subject/blocs/subject_event.dart';
import 'package:markme_teacher/features/subject/blocs/subject_state.dart';

import '../../../core/models/branch.dart';
import '../../../core/models/teacher.dart';

class AddSubjectScreen extends StatefulWidget {
  final Teacher teacher;

  const AddSubjectScreen({super.key, required this.teacher});

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  List<Course>? courses;
  List<Branch>? branches;
  List<AcademicBatch>? batches;
  List<Subject>? subjects;

  String? _selectedCourse;
  String? _selectedBranch;
  String? _selectedBatch;
  String? _selectedSubject;

  @override
  void initState() {
    super.initState();
    context.read<SubjectBloc>().add(GetAllCoursesEvent());
  }

  Widget _buildDropdown<T>({
    required String hintText,
    required List<DropdownMenuItem<T>> items,
    required T? selectedValue,
    required ValueChanged<T?> onChanged,
  }) => DropdownButtonFormField<T>(
    decoration: InputDecoration(
      labelText: hintText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    isExpanded: true,
    value: selectedValue,
    items: items,
    onChanged: onChanged,
  );

  void _addSubject() {
    if (_selectedSubject == null) {
      AppUtils.showDialogMessage(
        context,
        "Please select a subject before adding.",
        "Missing Information",
      );
      return;
    }

    final selected = subjects!.firstWhere(
      (s) => s.subjectId == _selectedSubject,
    );

    // Add subject to backend
    context.read<SubjectBloc>().add(
      AddSubjectEvent(selected, widget.teacher.teacherId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppNavBarNadd(title: "Add Subject"),
      body: BlocListener<SubjectBloc, SubjectState>(
        listener: (context, state) {
          if (state is SubjectLoading) {
            AppUtils.showCustomLoading(context);
          } else {
            Navigator.pop(context);
          }
          if (state is SubjectFailure) {
            AppUtils.showCustomSnackBar(context, state.message);
          } else if (state is CoursesLoadedForSubject) {
            setState(() => courses = state.courses);
          } else if (state is BranchesLoadedForSubject) {
            setState(() => branches = state.branches);
          } else if (state is BatchesLoadedForSubject) {
            setState(() => batches = state.batches);
          } else if (state is SubjectsLoaded) {
            setState(() => subjects = state.subjects);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (courses != null)
                        _buildDropdown<String>(
                          hintText: "Select Course",
                          items: courses!
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c.courseId,
                                  child: Text(c.courseName),
                                ),
                              )
                              .toList(),
                          selectedValue: _selectedCourse,
                          onChanged: (v) {
                            setState(() {
                              _selectedCourse = v;
                              _selectedBranch = null;
                              _selectedBatch = null;
                              _selectedSubject = null;
                              branches = null;
                              batches = null;
                              subjects = null;
                            });
                            if (v != null) {
                              context.read<SubjectBloc>().add(
                                GetBranchesForCourseEvent(v),
                              );
                            }
                          },
                        ),
                      if (branches != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: _buildDropdown<String>(
                            hintText: "Select Branch",
                            items: branches!
                                .map(
                                  (b) => DropdownMenuItem(
                                    value: b.branchId,
                                    child: Text(b.branchName),
                                  ),
                                )
                                .toList(),
                            selectedValue: _selectedBranch,
                            onChanged: (v) {
                              setState(() {
                                _selectedBranch = v;
                                _selectedBatch = null;
                                _selectedSubject = null;
                                batches = null;
                                subjects = null;
                              });
                              if (v != null) {
                                context.read<SubjectBloc>().add(
                                  GetBatchesForBranchEvent(v),
                                );
                              }
                            },
                          ),
                        ),
                      if (batches != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: _buildDropdown<String>(
                            hintText: "Select Batch",
                            items: batches!
                                .map(
                                  (b) => DropdownMenuItem(
                                    value: b.batchId,
                                    child: Text("${b.startYear}-${b.endYear}"),
                                  ),
                                )
                                .toList(),
                            selectedValue: _selectedBatch,
                            onChanged: (v) {
                              setState(() {
                                _selectedBatch = v;
                                _selectedSubject = null;
                                subjects = null;
                              });
                              if (v != null) {
                                context.read<SubjectBloc>().add(
                                  GetSubjectsForBatchEvent(v),
                                );
                              }
                            },
                          ),
                        ),
                      if (subjects != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: _buildDropdown<String>(
                            hintText: "Select Subject",
                            items: subjects!
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s.subjectId,
                                    child: Text(s.subjectName),
                                  ),
                                )
                                .toList(),
                            selectedValue: _selectedSubject,
                            onChanged: (v) =>
                                setState(() => _selectedSubject = v),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text("Add Subject"),
                  onPressed: _addSubject,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
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
