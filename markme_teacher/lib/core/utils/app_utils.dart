import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/color_palette.dart';
import '../widgets/loading.dart';

class AppUtils {
  static Future<String?> getCurrentDeviceToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  static void showCustomSnackBar(BuildContext context, String message,
      {bool isError = true, Duration duration = const Duration(seconds: 3)}) {
    final snackBar = SnackBar(
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      backgroundColor: isError ? AppColors.error : AppColors.success,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  static void showCupertinoToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 50,
        left: 20,
        right: 20,
        child: Material(  // Material is only to allow text styling
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: CupertinoColors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              style: TextStyle(color: CupertinoColors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: 2), () => overlayEntry.remove());
  }

  static final Connectivity connectivity = Connectivity();

  /// Check if device has internet
  static Future<bool> hasInternet() async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Run any action safely with internet check
  static Future<void> safeAction(
      BuildContext context,
      Future<void> Function() action,
      ) async {
    final isConnected = await hasInternet();
    if (!isConnected) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Internet is off")),
        );
      }
      return;
    }
    await action();
  }

  static void showCustomLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true, // important!
      builder: (_) =>
          const Dialog(backgroundColor: Colors.transparent, child: Loading()),
    );
  }

  // Hide loader
  static void hideCustomLoading(BuildContext context) {
    try {
      Navigator.of(context, rootNavigator: true).pop(); // only closes dialog
    } catch (_) {
      // dialog was already dismissed
    }
  }

  static void showDialogMessage(
    BuildContext context,
    String message,
    String title,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.close_outlined),
          ),
        ],
      ),
    );
  }

  static void showDeleteConfirmation({
    required BuildContext context,
    required VoidCallback onConfirmDelete,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this teacher?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirmDelete(); // 👉 perform actual deletion
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  } // here is the end

  static void showEndClassConfirmation({
    required BuildContext context,
    required VoidCallback onConfirmDelete,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("End Class !"),
        content: const Text("Are you sure you want to end this class"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirmDelete(); // 👉 perform actual deletion
            },
            child: const Text(
              "Yes",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
