import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_teacher/core/models/teacher.dart';
import 'package:markme_teacher/core/theme/color_palette.dart';

class HomeSideBar extends StatelessWidget {
  final Teacher teacher;
  const HomeSideBar({super.key, required this.teacher});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.cardBg,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: teacher.profilePhotoUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error, size: 40),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0,bottom: 4),
                  child: Text(
                    teacher.teacherName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0,bottom: 8),
                  child: Text(
                    teacher.designation,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(CupertinoIcons.archivebox),
            title: Text("Attendance Records"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.antenna_radiowaves_left_right),
            title: Text("Make Announcement"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.book_outlined),
            title: Text("Manage Subjects"),
            onTap: () {
              Navigator.pop(context);
              context.push('/manageSubjects', extra: teacher);
            },
          ),


          ListTile(
            leading: Icon(CupertinoIcons.person_2),
            title: Text("Manage Sections"),
            onTap: () {
              Navigator.pop(context);
              context.push('/manageSections', extra: teacher);
            },
          ),
          ListTile(
            leading: Icon(MaterialCommunityIcons.book_open_page_variant)
            ,
            title: Text("Students Data"),
            onTap: () {
              Navigator.pop(context);
              context.push('/manageClasses', extra: teacher);
            },
          ),
          ListTile(
            leading: Icon(MaterialCommunityIcons.file_document_edit_outline)
            ,
            title: Text("Manage Leaves"),
            onTap: () {
              Navigator.pop(context);
              context.push('/manageClasses', extra: teacher);
            },
          ),
          ListTile(
            leading:Icon(MaterialCommunityIcons.calendar_clock),
            title: Text("Past Classes"),
            onTap: () {
              Navigator.pop(context);
              context.push('/manageClasses', extra: teacher);
            },
          ),
          ListTile(
            leading: Icon(MaterialCommunityIcons.table_clock)
            ,
            title: Text("Time Table"),
            onTap: () {
              Navigator.pop(context);
              context.push('/manageClasses', extra: teacher);
            },
          ),

          ListTile(
            leading: Icon(MaterialCommunityIcons.book_open_page_variant)
            ,
            title: Text("Lesson Plan"),
            onTap: () {
              Navigator.pop(context);
              context.push('/lessonPlans', extra: teacher);
            },
          ),
          ListTile(
            leading:Icon(Ionicons.megaphone_outline),
            title: Text("File Complain"),
            onTap: () {
              Navigator.pop(context);
              context.push('/manageClasses', extra: teacher);
            },
          ),
          ListTile(
            leading: Icon(Icons.help_center_outlined),
            title: Text("Help Us"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.settings),
            title: Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              context.push('/setting', extra: teacher);
            },
          ),
        ],
      ),
    );
  }
}
