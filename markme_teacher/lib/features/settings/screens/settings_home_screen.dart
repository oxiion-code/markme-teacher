import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_teacher/core/theme/color_palette.dart';
import 'package:markme_teacher/core/utils/app_utils.dart';
import '../../../core/models/teacher.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../widget/logout_bottom_sheet.dart';

class SettingsHomeScreen extends StatelessWidget {
  final Teacher teacher;
  const SettingsHomeScreen({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.go('/authPhoneNumber'); // move to login screen
        } else if (state is AuthError) {
          AppUtils.showCustomSnackBar(context, state.error);
        }
      },
      child: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        navigationBar: CupertinoNavigationBar(
          middle: Text("Settings", style: theme.textTheme.navTitleTextStyle),
          backgroundColor: AppColors.scaffoldBg,
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 10),
              _buildSettingsTile(
                context,
                icon: CupertinoIcons.person_crop_circle,
                title: "Edit Profile",
                subtitle: "Update photo, name, email, gender",
                color: CupertinoColors.activeBlue,
                onTap: () {
                  context.push('/editProfile', extra: teacher);
                },
              ),
              const SizedBox(height: 12),
              _buildSettingsTile(
                context,
                icon: CupertinoIcons.building_2_fill,
                title: "Change Branch",
                subtitle: "Update your branch/department",
                color: CupertinoColors.activeGreen,
                onTap: () {
                  context.push('/changeBranch', extra: teacher);
                },
              ),
              const SizedBox(height: 12),
              _buildSettingsTile(
                context,
                icon: CupertinoIcons.phone,
                title: "Change Phone Number",
                subtitle: "Update your contact number",
                color: CupertinoColors.black,
                onTap: () {
                  context.push('/updatePhoneNumber', extra: teacher);
                },
              ),
              const SizedBox(height: 12),
              _buildSettingsTile(
                context,
                icon: CupertinoIcons.power,
                title: "Logout",
                subtitle: "Sign out from your account",
                color: CupertinoColors.destructiveRed,
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (_) => LogoutBottomSheet(
                      onLogoutConfirmed: () {
                        // Dispatch logout event
                        context.read<AuthBloc>().add(LogoutRequested());
                        Navigator.of(context).pop(); // close the bottom sheet
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
        Color color = CupertinoColors.activeBlue,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 14, color: CupertinoColors.inactiveGray)),
                ],
              ),
            ),
            const Icon(CupertinoIcons.forward,
                color: CupertinoColors.systemGrey2, size: 20),
          ],
        ),
      ),
    );
  }
}
