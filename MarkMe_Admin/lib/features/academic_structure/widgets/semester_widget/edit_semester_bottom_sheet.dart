import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/core/widgets/custom_textbox.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';


import '../../models/semester.dart';
class EditSemesterBottomSheet extends StatefulWidget {
  final Semester semester;
  final List<Branch> branches;
  final Function(Semester) onSaveEdit;

  const EditSemesterBottomSheet({
    super.key,
    required this.onSaveEdit,
    required this.semester,
    required this.branches,
  });

  @override
  State<EditSemesterBottomSheet> createState() => _EditSemesterBottomSheetState();
}

class _EditSemesterBottomSheetState extends State<EditSemesterBottomSheet> {
  late TextEditingController nameController;
  String? selectedText;

  @override
  void initState() {
    super.initState();
    selectedText = widget.semester.branchId;
    nameController = TextEditingController(text: widget.semester.semesterNumber);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Edit Branch",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 20),
          DropdownButton<String>(
            value: selectedText,
            hint: Text('Select a Course'),
            items: widget.branches.map((branch) {
              return DropdownMenuItem<String>(
                value: branch.branchId,
                child: Text(branch.branchName),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedText = value!;
              });
            },
          ),
          const SizedBox(height: 10),
          CustomTextbox(
            controller: nameController,
            icon: Icons.abc_outlined,
            hint: "Enter branch name",
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                widget.onSaveEdit(
                  widget.semester.copyWith(
                   semesterNumber: nameController.text.trim(),
                    branchId: selectedText ?? widget.semester.branchId,
                  ),
                );
                Navigator.pop(context);
              } else {
                AppUtils.showDialogMessage(
                  context,
                  "Please enter name and select branch",
                  "Sorry!!!",
                );
              }
            },
            child: Text("Save Changes"),
          )
        ],
      ),
    );
  }
}
