import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/features/academic_structure/bloc/branch_bloc/branch_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/branch_bloc/branch_event.dart';
import 'package:markme_admin/features/academic_structure/bloc/branch_bloc/branch_state.dart';
import 'package:markme_admin/features/academic_structure/models/course.dart';
import 'package:markme_admin/core/widgets/app_nav_bar.dart';
import 'package:markme_admin/features/academic_structure/widgets/branch_widgets/add_branch_bottom_sheet.dart';
import 'package:markme_admin/features/academic_structure/widgets/branch_widgets/branch_container.dart';
import 'package:markme_admin/features/academic_structure/widgets/branch_widgets/edit_branch_bottom_sheet.dart';

class ManageBranches extends StatefulWidget {
  const ManageBranches({super.key});

  @override
  State<ManageBranches> createState() => _ManageBranchesState();
}

class _ManageBranchesState extends State<ManageBranches> {
  @override
  void initState() {
    super.initState();
    context.read<BranchBloc>().add(LoadCourseForBranchEvent());
  }

  final TextEditingController branchId = TextEditingController();
  final TextEditingController branchName = TextEditingController();
  late List<Course>? courses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppNavBar(
        title: 'Manage Branches',
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) {
              if (courses != null) {
                return AddBranchBottomSheet(
                  branchIdController: branchId,
                  branchNameController: branchName,
                  onAddClick: (branch) {
                    context.read<BranchBloc>().add(AddNewBranchEvent(branch));
                    branchId.clear();
                    branchName.clear();
                    Navigator.pop(context);
                  },
                  courses: courses!,
                );
              } else {
                return Column(children: [Text("Please add a course")]);
              }
            },
          );
        },
      ),
      body: BlocConsumer<BranchBloc, BranchState>(
        listener: (context, state) {
          if (state is BranchDataLoadingState) {
            AppUtils.showCustomLoading(context);
          } else {
            Navigator.pop(context); // close loading or bottom sheet
          }

          if (state is BranchFailureState) {
            AppUtils.showCustomSnackBar(context, state.errorMessage);
          }

          if (state is LoadedCoursesForBranchState) {
            setState(() {
              courses = state.courses;
            });
            context.read<BranchBloc>().add(LoadBranchesEvent());
          }

          if (state is BranchSuccess) {
            AppUtils.showCustomSnackBar(context, "Operation successful");
            context.read<BranchBloc>().add(
              LoadBranchesEvent(),
            ); // reload after success
          }
        },
        builder: (context, state) {
          if (state is BranchesLoaded) {
            if (state.branches.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: Text('No Branches added yet')),
              );
            } else {
              return Padding(
                padding: EdgeInsets.all(20),
                child: ListView.builder(
                  itemCount: state.branches.length,
                  itemBuilder: (context, index) {
                    final branch = state.branches[index];
                    return BranchContainer(
                      onDelete: () {
                        context.read<BranchBloc>().add(DeleteBranchEvent(branch));
                      },
                      onEdit: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => EditBranchBottomSheet(
                            onSaveEdit: (branch) {
                              context.read<BranchBloc>().add(UpdateBranchEvent(branch));
                            },
                            branch: branch,
                            courses: courses!,
                          ),
                        );
                      },
                      branch: branch,
                    );
                  },
                ),
              );
            }
          }
          return Center(child: Text('No Branches added yet'));
        },
      ),
    );
  }
}
