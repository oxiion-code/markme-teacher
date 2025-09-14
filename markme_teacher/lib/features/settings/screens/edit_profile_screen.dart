import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_teacher/core/utils/app_utils.dart';
import 'package:markme_teacher/features/auth/bloc/auth_event.dart';
import '../../../core/models/teacher.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';

class EditProfileScreen extends StatefulWidget {
  final Teacher teacher;
  const EditProfileScreen({super.key, required this.teacher});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  String gender = 'Male';
  File? profilePhoto;

  final List<String> genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.teacher.teacherName);
    emailController = TextEditingController(text: widget.teacher.email);
    gender = widget.teacher.gender ?? 'Male';
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => profilePhoto = File(picked.path));
  }

  void _showGenderPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            // Done button
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(
                  "Done",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.activeBlue,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                  initialItem: genders.indexOf(gender),
                ),
                itemExtent: 36,
                onSelectedItemChanged: (index) {
                  setState(() => gender = genders[index]);
                },
                children: genders.map((g) => Text(g)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          AppUtils.showCustomLoading(context);
        } else if (state is TeacherUpdateSuccess) {
          AppUtils.showCupertinoToast(context, "Profile updated successfully!");
          Navigator.pop(context, state.teacher); // Return updated teacher
        } else if (state is AuthError) {
          AppUtils.showCupertinoToast(context, state.error);
        }
      },
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text("Edit Profile"),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            children: [
              _buildProfilePhoto(theme),
              const SizedBox(height: 32),
              _buildFormCard(theme),
              const SizedBox(height: 36),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhoto(CupertinoThemeData theme) {
    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  CupertinoColors.activeBlue,
                  CupertinoColors.systemPurple,
                ],
              ),
            ),
            padding: EdgeInsets.all(3),
            child: CircleAvatar(
              radius: 55,
              backgroundColor: CupertinoColors.systemGrey5,
              backgroundImage: profilePhoto != null
                  ? FileImage(profilePhoto!)
                  : (widget.teacher.profilePhotoUrl.isNotEmpty
                            ? NetworkImage(widget.teacher.profilePhotoUrl)
                            : null)
                        as ImageProvider?,
              child:
                  (profilePhoto == null &&
                      widget.teacher.profilePhotoUrl.isEmpty)
                  ? Icon(
                      CupertinoIcons.person,
                      color: CupertinoColors.systemGrey,
                      size: 60,
                    )
                  : null,
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: GestureDetector(
              onTap: _pickPhoto,
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.activeBlue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(6),
                child: Icon(
                  CupertinoIcons.camera_fill,
                  color: CupertinoColors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(CupertinoThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.barBackgroundColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CupertinoTextField(
            controller: nameController,
            placeholder: "Full Name",
            prefix: Icon(
              CupertinoIcons.person,
              size: 20,
              color: CupertinoColors.systemGrey2,
            ),
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          ),
          SizedBox(height: 14),
          CupertinoTextField(
            controller: emailController,
            placeholder: "Email",
            keyboardType: TextInputType.emailAddress,
            prefix: Icon(
              CupertinoIcons.envelope,
              size: 20,
              color: CupertinoColors.systemGrey2,
            ),
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: _showGenderPicker,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.person_2_fill,
                    color: CupertinoColors.systemGrey2,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(child: Text(gender, style: TextStyle(fontSize: 16))),
                  Icon(
                    CupertinoIcons.chevron_down,
                    size: 18,
                    color: CupertinoColors.systemGrey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CupertinoButton(
            color: CupertinoColors.systemGrey5,
            child: const Text(
              'Cancel',
              style: TextStyle(color: CupertinoColors.black),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        SizedBox(width: 18),
        Expanded(
          child: CupertinoButton.filled(
            borderRadius: BorderRadius.circular(12),
            padding: EdgeInsets.symmetric(vertical: 14),
            child: const Text('Save Changes'),
            onPressed: () {
              final teacherName = nameController.text.trim();
              final emailId = emailController.text.trim();

              if (teacherName.isEmpty) {
                AppUtils.showCupertinoToast(
                  context,
                  "Please enter teacher name",
                );
                return;
              }
              if (emailId.isEmpty) {
                AppUtils.showCupertinoToast(
                  context,
                  "Please enter valid email id",
                );
                return;
              }

              // Check if any data changed
              final isNameChanged = teacherName != widget.teacher.teacherName;
              final isEmailChanged = emailId != widget.teacher.email;
              final isGenderChanged =
                  gender != (widget.teacher.gender ?? 'Male');
              final isPhotoChanged = profilePhoto != null;

              if (!isNameChanged &&
                  !isEmailChanged &&
                  !isGenderChanged &&
                  !isPhotoChanged) {
                AppUtils.showCupertinoToast(context, "No changes detected");
                return;
              }

              final teacher = widget.teacher.copyWith(
                teacherName: teacherName,
                email: emailId,
                gender: gender,
              );

              // Only call update if something changed
              context.read<AuthBloc>().add(
                UpdateDataEvent(teacher, profilePhoto),
              );
              context.pop();
            },
          ),
        ),
      ],
    );
  }
}
