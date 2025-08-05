import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/theme/color_scheme.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';

class DashboardDrawer extends StatelessWidget {
  final AdminUser user;
  const DashboardDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding:EdgeInsets.zero,
        children: [
          Container(
            color: AppColors.cardBg,
            height: 220,
            padding:  EdgeInsets.only(top: MediaQuery.of(context).padding.top+12) ,
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  height: 130,
                  width: 120,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(user.profilePhotoUrl),
                      fit: BoxFit.cover,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade600,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Text(
                  user.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: AppColors.primaryDark),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_tree),
            title: const Text('Academic Structure'),
            onTap: (){
              context.pop();
              context.push('/manageAcademicStructure');
            },
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: const Text('Manage Subjects'),
            onTap: (){
              context.pop();
              context.push('/manageSubjects');
            },
          ),
          ListTile(
            leading: Icon(Icons.person_2_rounded),
            title: const Text('Manage Teachers'),
            onTap: (){
              context.pop();
              context.push('/manageTeachers');
            },
          ),
          ListTile(
            leading: Icon(Icons.history_outlined),
            title: const Text('Past Classes'),
            onTap: (){
              context.pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.error),
            title: const Text('Check Defaulters'),
            onTap: (){
              context.pop();
            },
          ),

        ],
      ),
    );
  }
}
