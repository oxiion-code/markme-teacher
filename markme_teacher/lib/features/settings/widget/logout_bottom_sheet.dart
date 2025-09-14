import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogoutBottomSheet extends StatelessWidget {
  final VoidCallback onLogoutConfirmed;
  const LogoutBottomSheet({super.key, required this.onLogoutConfirmed});

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: const Text("Confirm Logout"),
      message: const Text("Are you sure you want to logout?"),
      actions: [
        CupertinoActionSheetAction(
          onPressed: onLogoutConfirmed,
          isDestructiveAction: true,
          child: const Text("Logout"),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text("Cancel"),
      ),
    );
  }
}