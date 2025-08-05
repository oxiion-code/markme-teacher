import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/core/widgets/custom_textbox.dart';

import '../../models/branch.dart';
import '../../models/semester.dart';

class AddSemesterBottomSheet extends StatefulWidget {
  final List<Branch> branches;
  final Function(Semester) addSemester;
  const AddSemesterBottomSheet({
    super.key,
    required this.branches,
    required this.addSemester,
  });

  @override
  State<AddSemesterBottomSheet> createState() => _AddSemesterBottomSheetState();
}

class _AddSemesterBottomSheetState extends State<AddSemesterBottomSheet> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  String? selectedBranch;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Add New Semester',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              hint: Text('Select a branch'),
              value: selectedBranch,
              items: widget.branches.map((branch) {
                return DropdownMenuItem<String>(
                  value: branch.branchId,
                  child: Text(branch.branchName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBranch = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            CustomTextbox(
              controller: idController,
              icon: Icons.flag,
              hint: 'Enter semester id',
            ),
            const SizedBox(height: 14),
            CustomTextbox(
              controller: nameController,
              icon: Icons.abc_outlined,
              hint: 'Enter semester name',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                if(selectedBranch!=null && idController.text.trim().isNotEmpty && nameController.text.trim().isNotEmpty){
                  widget.addSemester(
                    Semester(
                      branchId: selectedBranch!,
                      semesterId:"${selectedBranch!}_${idController.text}",
                      semesterNumber: nameController.text.trim(),
                    ),
                  );
                  Navigator.pop(context);
                }else{
                  AppUtils.showDialogMessage(context, "Fill all the fields and select branch", "Sorry !!!");
                }
              },
              child: Text('Add semester'),
            ),
          ],
        ),
      ),
    );
  }
}
