import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_teacher/core/models/teacher.dart';
import 'package:markme_teacher/core/utils/app_utils.dart';
import 'package:markme_teacher/features/class/bloc/class_event.dart';
import 'package:markme_teacher/features/class/bloc/class_state.dart';
import 'package:markme_teacher/features/home/bloc/home_bloc.dart';
import 'package:markme_teacher/features/home/bloc/home_event.dart';
import 'package:markme_teacher/features/home/bloc/home_state.dart';
import 'package:markme_teacher/features/home/widgets/class_card.dart';
import 'package:markme_teacher/features/home/widgets/home_side_bar.dart';
import 'package:markme_teacher/features/home/widgets/live_dot.dart';
import 'package:markme_teacher/features/home/widgets/start_class_bottom_sheet.dart';
import 'package:markme_teacher/features/home/widgets/app_bar.dart';

import '../../class/bloc/class_bloc.dart';

class HomeScreen extends StatefulWidget {
  final Teacher teacherAuth;

  const HomeScreen({super.key, required this.teacherAuth});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Teacher? lastLoadedTeacher;
  bool _navigatedToLiveClass = false;
  bool _bottomSheetOpen = false; // NEW: prevent duplicate sheets

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ClassBloc,ClassState>(listener: (context,state){
          if(state is ClassLoading){
            AppUtils.showCustomLoading(context);
          }else{
            AppUtils.hideCustomLoading(context);
          }
          if(state is ClassFailure){
            AppUtils.showDialogMessage(
                context,
                "Live Class Ended",
                "This live class is no longer available."
            );
          }else if(state is JoinedLiveClass){
            context.push("/liveClass",extra: state.classStartData);
          }
        })
      ],
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeLoading) {
            AppUtils.showCustomLoading(context);
            return;
          } else {
            AppUtils.hideCustomLoading(context);
          }
          if (state is TeacherDataLoadedForHome) {
            lastLoadedTeacher = state.teacher;

            if (state.teacher.liveClassId == null) {
              _navigatedToLiveClass = false;
            }
            return;
          }

          /// 🔹 Show Bottom Sheet safely
          if (state is SectionDataLoadedForHome &&
              lastLoadedTeacher != null &&
              !_bottomSheetOpen) {
            _bottomSheetOpen = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                backgroundColor: Colors.white,
                builder: (sheetContext) {
                  return BlocProvider.value(
                    value: context.read<ClassBloc>(),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                        bottom:
                            MediaQuery.of(sheetContext).viewInsets.bottom + 20,
                      ),
                      child: StartClassBottomSheet(
                        section: state.section,
                        subjects: lastLoadedTeacher!.subjects,
                        teacher: lastLoadedTeacher!,
                        onStartClassClick: (classSession) {},
                      ),
                    ),
                  );
                },
              ).whenComplete(() {
                _bottomSheetOpen = false;
              });
            });
            return;
          }
        },
        builder: (context, state) {
          Widget bodyContent;

          if (state is HomeFailure) {
            bodyContent = Center(child: Text(state.message));
          } else if (lastLoadedTeacher != null) {
            final teacher = lastLoadedTeacher!;
            bodyContent = GridView.builder(
              itemCount: teacher.assignedClasses.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final sectionId = teacher.assignedClasses[index];
                final parts = sectionId.split("_");
                final branchName = parts[0].toUpperCase();
                final batchName = "${parts[1]}-${parts[2]}";
                final sectionName = parts[3].toUpperCase();

                return ClassCard(
                  branchName: branchName,
                  batchName: batchName,
                  sectionName: sectionName,
                  onPressed: () {
                    context.read<HomeBloc>().add(
                      GetSectionDetailsForHome(sectionId),
                    );
                  },
                );
              },
            );
          } else {
            bodyContent = const Center(child: Text("Loading..."));
          }

          return Scaffold(
            drawer: lastLoadedTeacher != null
                ? HomeSideBar(teacher: lastLoadedTeacher!)
                : null,
            appBar: lastLoadedTeacher != null
                ? HomeAppBar(teacher: lastLoadedTeacher!)
                : HomeAppBar(teacher: widget.teacherAuth),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      image: DecorationImage(
                        image: AssetImage("assets/images/college_front.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  if (lastLoadedTeacher?.liveClassId != null)
                    InkWell(
                      onTap: () {
                        if(lastLoadedTeacher!=null){
                          context.read<ClassBloc>().add(JoinLiveClassEvent(lastLoadedTeacher!.liveClassId!));
                        }
                      },
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        margin:const EdgeInsets.only(
                          top: 16,
                        ) ,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors:   [Colors.indigo, Colors.blue.shade600],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Tap to open live class",
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const LiveDot()
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Text(
                      "My Sections",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(child: bodyContent),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
