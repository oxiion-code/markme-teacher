// manage_sections.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:markme_teacher/core/models/course.dart';
import 'package:markme_teacher/core/models/teacher.dart';
import 'package:markme_teacher/core/utils/app_utils.dart';
import 'package:markme_teacher/core/widgets/app_nav_bar.dart';
import 'package:markme_teacher/features/section/blocs/section_event.dart';

import '../../../core/models/section.dart';
import '../blocs/section_bloc.dart';
import '../blocs/section_state.dart';
import '../widgets/add_section_bottom_sheet.dart';
import '../widgets/section_card.dart';

class ManageSectionsScreen extends StatefulWidget {
  final Teacher teacher;
  const ManageSectionsScreen({super.key, required this.teacher});

  @override
  State<ManageSectionsScreen> createState() => _ManageSectionsScreenState();
}
class _ManageSectionsScreenState extends State<ManageSectionsScreen> {
  List<Course>? courses;
  List<String>? loadedSections;

  @override
  void initState() {
    super.initState();
    context.read<SectionBloc>().add(GetCoursesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppNavBar(
        title: "Manage Sections",
        onTap: () {
          final sectionBloc = context.read<SectionBloc>();

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (_) => FractionallySizedBox(
              heightFactor: 0.55,
              child: AddSectionBottomSheet(
                teacherId: widget.teacher.teacherId,
                courses: courses!,
                sectionBloc: sectionBloc,
              ),
            ),
          ).then((result) {
            if (result != true) {
              sectionBloc.add(GetSectionsOfTeacherEvent(widget.teacher.teacherId));
            }
          });
        },
      ),
      body: BlocConsumer<SectionBloc, SectionState>(
        listener: (context, state) {
          if (state is SectionLoading) {
            AppUtils.showCustomLoading(context);
          }else if(state is SectionDeleted){
            context.read<SectionBloc>().add(GetSectionsOfTeacherEvent(widget.teacher.teacherId));
            AppUtils.showCustomSnackBar(context, "Section Deleted");
          }
          else {
            AppUtils.hideCustomLoading(context);
          }
          if (state is SectionFailure) {
              AppUtils.showCustomSnackBar(context, state.message);
            } else if (state is SectionAdded) {
              context.read<SectionBloc>().add(GetSectionsOfTeacherEvent(widget.teacher.teacherId));
              AppUtils.showCustomSnackBar(context, "Section Added");
            }
          else if (state is SectionsOfTeacherLoaded) {
            setState(() {
              loadedSections=state.sections;
            });
          }
          else if (state is CoursesLoadedForSection) {
              setState(() => courses = state.courses);
              context.read<SectionBloc>().add(GetSectionsOfTeacherEvent(widget.teacher.teacherId));
            }
          }
        ,

        builder: (context, state) {
         if (state is SectionFailure) {
            return Center(child: Text("Error: ${state.message}"));
          }
          if(loadedSections!=null){
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2,
                mainAxisSpacing: 12,
                childAspectRatio: 0.67, // Adjust as needed for card height
              ),
              itemCount: loadedSections!.length,
              itemBuilder: (context, index) {
                final sectionData = loadedSections![index];
                return SectionCard(
                  sectionData: sectionData,
                  onDelete: () {
                    context.read<SectionBloc>().add(
                      DeleteSectionEvent(widget.teacher.teacherId, sectionData),
                    );
                  },
                );
              },
            );
          }
          return Center(
            child: Icon(
             MaterialCommunityIcons.google_classroom,       // Or any icon you like
              size: 100,               // Large size
              color: Colors.grey[400], // Light grey to indicate emptiness
            ),
          );

        },
      ),
    );
  }
}

