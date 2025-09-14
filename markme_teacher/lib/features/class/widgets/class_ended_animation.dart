import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ClassEndAnimation extends StatelessWidget {
  const ClassEndAnimation({super.key});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            "assets/animations/Check.json",
            repeat: false,
            onLoaded: (composition) async {
              await Future.delayed(
                composition.duration + const Duration(seconds: 1),
              );
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 12),
          const Text(
            "Class Completed",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
          ),
        ],
      ),
    );
  }
}
