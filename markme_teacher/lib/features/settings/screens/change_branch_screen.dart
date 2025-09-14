import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_teacher/core/models/teacher.dart';
import 'package:markme_teacher/core/utils/app_utils.dart';
import 'package:markme_teacher/features/settings/bloc/setting_bloc.dart';
import 'package:markme_teacher/features/settings/bloc/setting_event.dart';
import 'package:markme_teacher/features/settings/bloc/setting_state.dart';
import 'package:markme_teacher/features/auth/bloc/auth_bloc.dart';
import 'package:markme_teacher/features/auth/bloc/auth_event.dart';
import 'package:markme_teacher/features/auth/bloc/auth_state.dart';

class ChangeBranchScreen extends StatefulWidget {
  final Teacher teacher;
  const ChangeBranchScreen({super.key, required this.teacher});

  @override
  State<ChangeBranchScreen> createState() => _ChangeBranchScreenState();
}

class _ChangeBranchScreenState extends State<ChangeBranchScreen> {
  String? selectedBranch;

  @override
  void initState() {
    super.initState();
    context.read<SettingBloc>().add(LoadBranchesEvent());
    selectedBranch = widget.teacher.branchId; // default
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// 🔹 Listen to AuthBloc state changes
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              AppUtils.showCustomLoading(context);
            } else if (state is TeacherUpdateSuccess) {
              AppUtils.showCustomSnackBar(context,"Branch updated successfully ✅", isError: false );
              //"Branch updated successfully ✅"
            } else if (state is AuthError) {
              AppUtils.showCustomSnackBar(context,state.error);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Change Branch"),
          elevation: 2,
          backgroundColor: Colors.blueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<SettingBloc, SettingState>(
            builder: (context, state) {
              if (state is SettingLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SettingBranchesLoaded) {
                final branches = state.branches;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current Branch
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.school, color: Colors.blueAccent),
                        title: const Text("Current Branch"),
                        subtitle: Text(
                          widget.teacher.branchId,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Select New Branch
                    const Text(
                      "Select New Branch",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedBranch,
                          isExpanded: true,
                          items: branches
                              .map(
                                (branch) => DropdownMenuItem(
                              value: branch.branchId, // branchId = value
                              child: Text(branch.branchName), // display
                            ),
                          )
                              .toList(),
                          onChanged: (value) {
                            setState(() => selectedBranch = value);
                          },
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              if (selectedBranch != null &&
                                  selectedBranch != widget.teacher.branchId) {
                                final teacher= widget.teacher.copyWith(branchId: selectedBranch);
                                context.read<AuthBloc>().add(
                                  UpdateDataEvent(
                                   teacher,
                                    null
                                  ),
                                );
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: const Text("Save Changes"),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else if (state is SettingError) {
                return Center(child: Text("Error: ${state.message}"));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
