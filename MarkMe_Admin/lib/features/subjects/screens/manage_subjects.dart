import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/core/widgets/app_nav_bar.dart';

import '../../../core/utils/app_utils.dart';
import '../../academic_structure/models/academic_batch.dart';
import '../../academic_structure/models/branch.dart';
import '../bloc/subject_bloc.dart';
import '../bloc/subject_event.dart';
import '../bloc/subject_state.dart';
import '../widgets/add_subject_bottom_sheet.dart';
import '../widgets/subject_card.dart';

class ManageSubjects extends StatefulWidget {
  const ManageSubjects({super.key});

  @override
  State<ManageSubjects> createState() => _ManageSubjectsState();
}

class _ManageSubjectsState extends State<ManageSubjects> {
  List<Branch>? branches;
  List<AcademicBatch>? batches;

  @override
  void initState() {
    super.initState();
    context.read<SubjectBloc>().add(GetAllBranches());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppNavBar(
        title: "Manage Subjects",
        onTap: () {
          if (branches == null || batches == null) {
            AppUtils.showCustomSnackBar(context, "Please wait, still loading...");
            return;
          }
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) {
              return AddSubjectBottomSheet(
                branches: branches!,
                batches: batches!,
                onAddSubjectClick: (subject) {
                  context.read<SubjectBloc>().add(AddSubjectEvent(subject));
                },
              );
            },
          );
        },
      ),
      body: BlocConsumer<SubjectBloc, SubjectState>(
        listener: (context, state) {
          if (state is SubjectLoading) {
            AppUtils.showCustomLoading(context);
          } else {
            if (Navigator.canPop(context)) Navigator.pop(context);
          }

          if (state is SubjectError) {
            AppUtils.showCustomSnackBar(context, state.message);
          }else if(state is SubjectSuccess){
            AppUtils.showCustomSnackBar(context,"Operation Success");
          }else if (state is BranchesLoaded) {
            setState(() {
              branches = state.branches;
            });
            context.read<SubjectBloc>().add(GetAllBatches());
          } else if (state is BatchesLoaded) {
            setState(() {
              batches = state.batches;
            });
            context.read<SubjectBloc>().add(GetAllSubjects());
          }
        },
        builder: (context, state) {
          if (state is SubjectLoaded) {
            final subjects = state.subjects;

            if (subjects.isEmpty) {
              return const Center(child: Text("No subjects found."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return SubjectCard(
                  subject: subject,
                  onDelete: () {
                    context.read<SubjectBloc>().add(DeleteSubjectEvent(subject));
                  },
                );
              },
            );
          } else if (state is SubjectError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const Center(child: Text("No subjects added yet..."));
        },
      ),
    );
  }
}

