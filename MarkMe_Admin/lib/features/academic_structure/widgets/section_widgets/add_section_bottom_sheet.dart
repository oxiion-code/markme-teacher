import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/core/widgets/custom_textbox.dart';
import 'package:markme_admin/features/academic_structure/models/academic_batch.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/academic_structure/models/section.dart';

import '../../models/semester.dart';

class AddSectionBottomSheet extends StatefulWidget {
  final List<AcademicBatch> batches;
  final List<Branch> branches;
  final Function(Section) onAddSectionClick;

  const AddSectionBottomSheet({
    super.key,
    required this.batches,
    required this.branches,
    required this.onAddSectionClick,
  });

  @override
  State<AddSectionBottomSheet> createState() => _AddSectionBottomSheetState();
}

class _AddSectionBottomSheetState extends State<AddSectionBottomSheet> {
  String? selectedBatchId;
  String? selectedBranchId;
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text("Add section"),
            const SizedBox(height: 16),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedBatchId,
              hint: Text('Select a batch'),
              items: widget.batches.map((batch) {
                return DropdownMenuItem<String>(
                  value: batch.batchId,
                  child: Text(batch.batchId),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBatchId = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedBranchId,
              hint: Text('Select a branch'),
              items: widget.branches.map((branch) {
                return DropdownMenuItem<String>(
                  value: branch.branchId,
                  child: Text(branch.branchName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBranchId = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            CustomTextbox(
              controller: nameController,
              icon: Icons.abc_outlined,
              hint: 'eg:section k, CSE I',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (selectedBranchId != null &&
                    selectedBatchId != null &&
                    name.isNotEmpty) {
                  widget.onAddSectionClick(
                    Section(
                      sectionId:
                          "${selectedBranchId}_${selectedBatchId!}_$name",
                      sectionName: name,
                      batchId: selectedBatchId!,
                      branchId: selectedBranchId!,
                      studentIds: []
                    ),
                  );
                  Navigator.pop(context);
                } else {
                  AppUtils.showDialogMessage(
                    context,
                    "Select all fields and enter values",
                    "Sorry...",
                  );
                }
              },
              child: Text("Add section"),
            ),
          ],
        ),
      ),
    );
  }
}
