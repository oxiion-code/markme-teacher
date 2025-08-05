import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/semester_bloc/semester_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/semester_bloc/semester_event.dart';
import 'package:markme_admin/features/academic_structure/bloc/semester_bloc/semester_state.dart';
import 'package:markme_admin/core/widgets/app_nav_bar.dart';
import 'package:markme_admin/features/academic_structure/widgets/semester_widget/add_new_semester_bottom_sheet.dart';
import 'package:markme_admin/features/academic_structure/widgets/semester_widget/edit_semester_bottom_sheet.dart';
import 'package:markme_admin/features/academic_structure/widgets/semester_widget/semester_container.dart';
import 'package:markme_admin/features/dashboard/widgets/app_bar.dart';

import '../../../core/utils/app_utils.dart';
import '../models/branch.dart';

class ManageSemesters extends StatefulWidget {
  const ManageSemesters({super.key});

  @override
  State<ManageSemesters> createState() => _ManageSemestersState();
}

class _ManageSemestersState extends State<ManageSemesters> {
  List<Branch>? branches;

  @override
  void initState() {
    super.initState();
    context.read<SemesterBloc>().add(LoadBranchesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppNavBar(
        title: 'Manage Semesters',
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (sheetContext) {
              if (branches != null) {
                return AddSemesterBottomSheet(
                  branches: branches!,
                  addSemester: (semester) {
                    context.read<SemesterBloc>().add(
                      AddNewSemesterEvent(semester),
                    );
                  },
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          );
        },
      ),
      body: BlocConsumer<SemesterBloc, SemesterState>(
        listener: (context, state) {
          if (state is SemesterLoading) {
            AppUtils.showCustomLoading(context);
          } else {
            Navigator.pop(context);
          }
          if (state is BranchesLoaded) {
            setState(() {
              branches = state.branches;
            });
            context.read<SemesterBloc>().add(LoadSemestersEvent());
          } else if (state is SemesterFailure) {
            AppUtils.showCustomSnackBar(context, state.message);
          } else if (state is SemesterSuccess) {
            AppUtils.showCustomSnackBar(context, "Operation Successful");
          }
        },
        builder: (context, state) {
          if (state is SemestersLoaded) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: state.semesters.length,
                itemBuilder: (context, index) {
                  return SemesterContainer(
                    semester: state.semesters[index],
                    onEdit: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return EditSemesterBottomSheet(
                            semester: state.semesters[index],
                            branches: branches!,
                            onSaveEdit: (semester) {
                              context.read<SemesterBloc>().add(
                                UpdateSemesterEvent(semester),
                              );
                            },
                          );
                        },
                      );
                    },
                    onDelete: () {
                      context.read<SemesterBloc>().add(
                        DeleteSemesterEvent(state.semesters[index]),
                      );
                    },
                  );
                },
              ),
            );
          }

          return Center(child: Text("No semester added yet..."));
        },
      ),
    );
  }
}
