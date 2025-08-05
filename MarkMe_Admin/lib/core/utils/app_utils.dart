import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/widgets/loading.dart';

class AppUtils{
  static void showCustomSnackBar(BuildContext context,String message){
    ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(SnackBar(content: Text(message)));
  }
  static void showCustomLoading(BuildContext context){
    showDialog(context: context, builder: (_)=>Dialog(
      backgroundColor: Colors.transparent,
      child: Loading(),
    ));
  }

  static void showDialogMessage(BuildContext context,String message,String title){
    showDialog(context: context, builder: (context)=>AlertDialog(
      title:Text(title) ,
      content: Text(message),
      actions: [
        IconButton(onPressed: ()=>context.pop(), icon: Icon(Icons.close_outlined))
      ],
    ));
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
  }
}