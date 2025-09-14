// add_section_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_teacher/core/models/academic_batch.dart';
import 'package:markme_teacher/core/models/branch.dart';
import 'package:markme_teacher/core/models/course.dart';
import 'package:markme_teacher/core/utils/app_utils.dart';
import 'package:markme_teacher/features/section/blocs/section_event.dart';

import '../blocs/section_bloc.dart';
import '../blocs/section_state.dart';
class AddSectionBottomSheet extends StatefulWidget {
  final List<Course> courses;
  final String teacherId;
  final SectionBloc sectionBloc;
  const AddSectionBottomSheet({
    super.key,
    required this.teacherId,
    required this.courses,
    required this.sectionBloc,
  });

  @override
  State<AddSectionBottomSheet> createState() => _AddSectionBottomSheetState();
}

class _AddSectionBottomSheetState extends State<AddSectionBottomSheet> {
  List<AcademicBatch>? batches;
  List<Branch>? branches;
  List<String>? sections;
  String? selectedCourseId;
  String? selectedBranchId;
  String? selectedBatchId;
  String? selectedSection;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    Widget buildDropdown<T>({
      required String hint,
      required T? value,
      required List<DropdownMenuItem<T>> items,
      required Function(T?) onChanged,
    }) {
      return DropdownButtonFormField<T>(
        decoration: InputDecoration(
          labelText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        isExpanded: true,
        value: value,
        items: items,
        onChanged: onChanged,
      );
    }

    return BlocListener<SectionBloc, SectionState>(
      bloc: widget.sectionBloc,
      listener: (context, state) {
        if (state is BranchesLoadedForSection) {
          if (!mounted) return;
          setState(() => branches = state.branches);
        } else if (state is BatchesLoadedForSection) {
          if (!mounted) return;
          setState(() => batches = state.batches);
        } else if (state is SectionsLoaded) {
          if (!mounted) return;
          setState(() => sections = state.sections);
        } else if (state is SectionFailure) {
          AppUtils.showCustomSnackBar(context, state.message);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          top: 24,
          left: 24,
          right: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  "Add Section",
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 24),

              buildDropdown<String>(
                hint: "Select Course",
                value: widget.courses.any((c) => c.courseId == selectedCourseId) ? selectedCourseId : null,
                items: widget.courses
                    .map((course) => DropdownMenuItem<String>(
                  value: course.courseId,
                  child: Text(course.courseName),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCourseId = value;
                    selectedBranchId = null;
                    selectedBatchId = null;
                    selectedSection = null;
                    branches = null;
                    batches = null;
                    sections = null;
                  });
                  if (value != null) {
                    widget.sectionBloc.add(GetBranchesForSectionEvent(value));
                  }
                },
              ),
              if (branches != null) ...[
                const SizedBox(height: 18),
                buildDropdown<String>(
                  hint: "Select Branch",
                  value: branches!.any((b) => b.branchId == selectedBranchId) ? selectedBranchId : null,
                  items: branches!
                      .map((branch) => DropdownMenuItem<String>(
                    value: branch.branchId,
                    child: Text(branch.branchName),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBranchId = value;
                      selectedBatchId = null;
                      selectedSection = null;
                      batches = null;
                      sections = null;
                    });
                    if (value != null) {
                      widget.sectionBloc.add(GetBatchesForSectionEvent(value));
                    }
                  },
                ),
              ],
              const SizedBox(height: 4,),
              if (batches != null) ...[
                const SizedBox(height: 18),
                buildDropdown<String>(
                  hint: "Select Batch",
                  value: batches!.any((b) => b.batchId == selectedBatchId) ? selectedBatchId : null,
                  items: batches!
                      .map((batch) => DropdownMenuItem<String>(
                    value: batch.batchId,
                    child: Text("${batch.startYear} - ${batch.endYear}"),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBatchId = value;
                      selectedSection = null;
                      sections = null;
                    });
                    if (value != null && selectedCourseId != null && selectedBranchId != null) {
                      widget.sectionBloc.add(GetSectionsByFilterEvent(
                        selectedCourseId!,
                        selectedBranchId!,
                        value,
                      ));
                    }
                  },
                ),
              ],
              const SizedBox(height: 4,),
              if (sections != null) ...[
                const SizedBox(height: 18),
                buildDropdown<String>(
                  hint: "Select Section",
                  value: sections!.any((section) => section == selectedSection) ? selectedSection : null,
                  items: sections!
                      .map((section) => DropdownMenuItem<String>(
                    value: section,
                    child: Text(section),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSection = value;
                    });
                  },
                ),
              ],

              const SizedBox(height: 28),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    if (selectedCourseId != null &&
                        selectedBranchId != null &&
                        selectedBatchId != null &&
                        selectedSection != null) {
                      widget.sectionBloc.add(
                        AddSectionEvent(widget.teacherId, selectedSection!),
                      );
                    } else {
                      AppUtils.showDialogMessage(
                        context,
                        "Please select course, branch, batch, and section before adding.",
                        "Missing Information",
                      );
                    }
                  },
                  child: const Text("Add Section"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
