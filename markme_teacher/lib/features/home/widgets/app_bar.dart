import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/models/teacher.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Teacher teacher;
  const HomeAppBar({super.key, required this.teacher});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      titleSpacing: 0,
      leading: Builder(
        builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu),
          );
        }
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "GITA Autonomous College",
            style: TextStyle(  fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,),
          ),SizedBox(height: 2,),
          Text(
           "Powered by Dept. of CST",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white70, // lighter subtitle),
          ),
          )],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
