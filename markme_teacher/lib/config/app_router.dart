import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_teacher/core/models/teacher.dart';
import 'package:markme_teacher/features/attendance/bloc/attendance_bloc.dart';
import 'package:markme_teacher/features/attendance/models/attendance_data.dart';
import 'package:markme_teacher/features/attendance/models/attendance_edit_data.dart';
import 'package:markme_teacher/features/auth/models/auth_info.dart';
import 'package:markme_teacher/features/auth/screens/auth_otp_screen.dart';
import 'package:markme_teacher/features/auth/screens/auth_phone_no_screen.dart';
import 'package:markme_teacher/features/auth/screens/splash_screen.dart';
import 'package:markme_teacher/features/auth/screens/personal_details_screen.dart';
import 'package:markme_teacher/features/class/models/class_start_data.dart';
import 'package:markme_teacher/features/class/screens/edit_live_attendance.dart';
import 'package:markme_teacher/features/class/screens/live_class_attendance_screen.dart';
import 'package:markme_teacher/features/class/screens/live_class_screen.dart';
import 'package:markme_teacher/features/home/screens/home_screen.dart';
import 'package:markme_teacher/features/lesson_plan/bloc/lesoon_bloc.dart';
import 'package:markme_teacher/features/lesson_plan/models/lesson_plan_details.dart';
import 'package:markme_teacher/features/lesson_plan/screens/add_lesson_plan.dart';
import 'package:markme_teacher/features/lesson_plan/screens/lesson_plan_details_screen.dart';
import 'package:markme_teacher/features/lesson_plan/screens/lesson_plans.dart';
import 'package:markme_teacher/features/settings/bloc/setting_bloc.dart';
import 'package:markme_teacher/features/settings/models/update_number_info.dart';
import 'package:markme_teacher/features/settings/screens/change_branch_screen.dart';
import 'package:markme_teacher/features/settings/screens/change_phone_otp_screen.dart';
import 'package:markme_teacher/features/settings/screens/chnage_phone_number_screen.dart';
import 'package:markme_teacher/features/settings/screens/edit_profile_screen.dart';
import 'package:markme_teacher/features/settings/screens/settings_home_screen.dart';
import 'package:markme_teacher/features/subject/blocs/subject_bloc.dart';
import 'package:markme_teacher/features/subject/screens/add_subject_screen.dart';
import 'package:markme_teacher/features/subject/screens/manage_subjects_screen.dart';
import '../core/services/service_locator.dart';
import '../features/class/bloc/class_bloc.dart';
import '../features/home/bloc/home_bloc.dart';
import '../features/home/bloc/home_event.dart';
import '../features/section/blocs/section_bloc.dart';
import '../features/section/screens/manage_sections.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: "splash",
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: "/authPhoneNumber",
      name: "auth_phone",
      builder: (context, state) => AuthPhoneNumberScreen(),
    ),
    GoRoute(
      path: "/authOtp",
      name: "auth_otp",
      builder: (context, state) {
        final verificationId = state.extra as String;
        return AuthOtpScreen(verificationId: verificationId);
      },
    ),
    GoRoute(
      path: '/authProfileUpdate',
      name: 'auth_profile_update',
      builder: (context, state) {
        final teacher = state.extra as Teacher;
        return PersonalDetailsScreen(teacher: teacher);
      },
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) {
        final teacher = state.extra as Teacher;
        return MultiBlocProvider(
          providers: [
            BlocProvider<HomeBloc>(
              create: (context) =>
                  HomeBloc(sl(), sl(), sl(), sl())
                    ..add(HomeStarted(teacher.teacherId)),
            ),
            BlocProvider<ClassBloc>(
              create: (context) => ClassBloc(
                sl(),
                sl(),
                sl(), // pass your dependencies here
              ),
            ),
          ],
          child: HomeScreen(teacherAuth: teacher),
        );
      },
    ),

    GoRoute(
      path: '/manageSubjects',
      name: 'manageSubjects',
      builder: (context, state) {
        final teacher = state.extra as Teacher;
        return BlocProvider(
          create: (context) => SubjectBloc(sl()),
          child: ManageSubjectsScreen(teacher: teacher),
        );
      },
    ),
    GoRoute(
      path: '/addSubject',
      name: 'add_subject',
      builder: (context, state) {
        final teacher = state.extra as Teacher;

        return BlocProvider(
          create: (context) => SubjectBloc(sl()),
          child: AddSubjectScreen(teacher: teacher),
        );
      },
    ),
    GoRoute(
      path: '/manageSections',
      name: 'manage_sections',
      builder: (context, state) {
        final teacher = state.extra as Teacher;
        return BlocProvider(
          create: (context) => SectionBloc(sl(), sl()),
          child: ManageSectionsScreen(teacher: teacher),
        );
      },
    ),
    GoRoute(
      path: "/liveClass",
      name: "live_class",
      builder: (context, state) {
        final args = state.extra as ClassStartData;
        final classSessionData = args.classSession;
        final students = args.students;
        return MultiBlocProvider(
          providers: [
            BlocProvider<ClassBloc>(
              create: (context) => ClassBloc(sl(), sl(), sl()),
            ),
            BlocProvider<AttendanceBloc>(
              create: (context) => AttendanceBloc(sl()),
            ),
          ],
          child: LiveClassScreen(
            students: students,
            classSession: classSessionData,
          ),
        );
      },
    ),
    GoRoute(
      path: "/takeAttendance",
      name: "take_attendance",
      builder: (context, state) {
        final args = state.extra as AttendanceData;
        final attendanceId = args.attendanceId;
        final students = args.students;
        final teacherId = args.teacherId;
        final sectionId = args.sectionId;
        final subjectId = args.subjectId;
        return MultiBlocProvider(
          providers: [
            BlocProvider<AttendanceBloc>(
              create: (context) => AttendanceBloc(sl()),
            ),
            BlocProvider<LessonBloc>(create: (context) => LessonBloc(sl())),
          ],
          child: LiveClassAttendanceScreen(
            attendanceId: attendanceId,
            students: students,
            teacherId: teacherId,
            sectionId: sectionId,
            subjectId: subjectId,
          ),
        );
      },
    ),
    GoRoute(
      path: "/editLiveAttendance",
      name: "edit_live_attendance",
      builder: (context, state) {
        final args = state.extra as AttendanceEditData;
        final presentStudents = args.presentStudents;
        final allStudents = args.students;
        final teacherId = args.teacherId;
        final attendanceId = args.attendanceId;
        final sectionId = args.sectionId;
        final subjectId = args.subjectId;
        final lessonTopic = args.lessonTopic;
        return MultiBlocProvider(
          providers: [
            BlocProvider<AttendanceBloc>(
              create: (context) => AttendanceBloc(sl()),
            ),
            BlocProvider<LessonBloc>(create: (context) => LessonBloc(sl())),
          ],
          child: EditLiveAttendanceScreen(
            presentStudents: presentStudents,
            allStudents: allStudents,
            teacherId: teacherId,
            attendanceId: attendanceId,
            subjectId: subjectId,
            sectionId: sectionId,
            lessonTopic: lessonTopic,
          ),
        );
      },
    ),

    GoRoute(
      path: "/lessonPlans",
      name: "lesson_plan",
      builder: (context, state) {
        final teacher = state.extra as Teacher;
        return BlocProvider(
          create: (context) => LessonBloc(sl()),
          child: LessonPlans(teacher: teacher),
        );
      },
    ),
    GoRoute(
      path: "/addLessonPlan",
      name: "add_lesson_plan",
      builder: (context, state) {
        final teacher = state.extra as Teacher;
        return BlocProvider(
          create: (context) => LessonBloc(sl()),
          child: AddLessonPlan(teacher: teacher),
        );
      },
    ),
    GoRoute(
      path: "/lessonDetails",
      name: "lesson_details",
      builder: (context, state) {
        final extra = state.extra as LessonPlanDetails;
        final teacher = extra.teacher;
        final lessonPlan = extra.lessonPlan;
        return LessonPlanDetailsScreen(
          lessonPlan: lessonPlan,
          teacher: teacher,
        );
      },
    ),

    GoRoute(
      path: '/setting',
      name: 'setting',
      builder: (context, state) {
        final teacher = state.extra as Teacher;
        return SettingsHomeScreen(teacher: teacher);
      },
    ),

    GoRoute(
      path: '/editProfile',
      name: 'edit_profile',
      builder: (context, state) {
        final teacher = state.extra as Teacher;
        return EditProfileScreen(teacher: teacher);
      },
    ),

    GoRoute(
      path: '/changeBranch',
      name: 'change_branch',
      builder: (context, state) {
        final teacher = state.extra as Teacher;
        return BlocProvider(
          create: (context)=>SettingBloc(sl()),
            child: ChangeBranchScreen(teacher: teacher)
        );
      },
    ),
    GoRoute(
      path: '/updatePhoneNumber',
      name: 'update_phone_number',
      builder: (context, state) {
        final teacher = state.extra as Teacher;
        return UpdatePhoneNumberScreen(teacher: teacher,);
      },
    ),
    GoRoute(
      path: '/updateOtp',
      name: 'update_otp',
      builder: (context, state) {
        final updatePhoneInfo= state.extra as UpdatePhoneNumberInfo;
        final verificationId=updatePhoneInfo.verificationId;
        final phoneNumber= updatePhoneInfo.phoneNumber;
        final uid= updatePhoneInfo.uid;
        return UpdatePhoneOtpScreen(verificationId:verificationId , phoneNumber: phoneNumber,uid: uid,);
      },
    ),
  ],
);
