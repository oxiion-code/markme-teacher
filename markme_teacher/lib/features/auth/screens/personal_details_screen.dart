import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markme_teacher/core/theme/color_palette.dart';
import 'package:markme_teacher/core/utils/app_utils.dart';
import 'package:markme_teacher/core/widgets/custom_button.dart';
import 'package:markme_teacher/core/widgets/custom_textbox.dart';
import 'package:markme_teacher/features/auth/bloc/auth_bloc.dart';
import 'package:markme_teacher/features/auth/bloc/auth_event.dart';
import 'package:markme_teacher/features/auth/bloc/auth_state.dart';
import 'package:markme_teacher/features/auth/widgets/profilephoto_selection.dart';

import '../../../core/models/teacher.dart';

class PersonalDetailsScreen extends StatefulWidget {
  final Teacher teacher;
  const PersonalDetailsScreen({super.key, required this.teacher});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  File? _profileImage;
  String? _selectedGender;
  String? _selectedDesignation;
  final List<String> _designations = ['Teacher', 'HOD', 'Staff'];
  final List<String> _genders = ['Male', 'Female', 'Prefer not to say'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            AppUtils.showCustomLoading(context);
          } else {
            context.pop();
          }
          if (state is TeacherUpdateSuccess) {
            final Teacher teacher = state.teacher;
            context.go('/home', extra: teacher);
          } else if (state is AuthError) {
            AppUtils.showCustomSnackBar(context, state.error);
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            bottom: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              ProfilePhotoSelection(
                profileImage: _profileImage,
                onSelectImage: (image) {
                  setState(() {
                    _profileImage = image;
                  });
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedDesignation,
                hint: Text(
                  "Select Designation",
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.deepPurple,
                  size: 28,
                ),
                dropdownColor: Colors.white,
                validator: (value) {
                  if (value == null) {
                    return "Please select designation";
                  }
                  return null;
                },
                style: TextStyle(color: Colors.black, fontSize: 16),
                items: _designations.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(
                          Icons.work_outline,
                          size: 18,
                          color: Colors.deepPurple,
                        ),
                        SizedBox(width: 8),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDesignation = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                hint: Text(
                  "Select Gender",
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.deepPurple,
                  size: 28,
                ),
                dropdownColor: Colors.white,
                validator: (value) {
                  if (value == null) {
                    return "Please select designation";
                  }
                  return null;
                },
                style: TextStyle(color: Colors.black, fontSize: 16),
                items: _genders.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(Icons.ac_unit, size: 18, color: Colors.deepPurple),
                        SizedBox(width: 8),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
              ),
              SizedBox(height: 18),
              CustomButton(
                onTap: () {
                  if (_selectedGender != null &&
                      _selectedDesignation != null &&
                      _profileImage != null) {
                    context.read<AuthBloc>().add(
                      UpdateDataEvent(
                        widget.teacher.copyWith(
                          gender: _selectedGender,
                          designation: _selectedDesignation,
                        ),
                        _profileImage!,
                      ),
                    );
                  } else {
                    AppUtils.showDialogMessage(
                      context,
                      "Please select all the fields",
                      "Sorry!!!",
                    );
                  }
                },
                text: "Update",
                icon: Icons.navigate_next,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
