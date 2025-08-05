import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/services/service_locator.dart';
import 'package:markme_admin/features/academic_structure/bloc/batch_bloc/academic_batch_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/branch_bloc/branch_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/course_bloc/course_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/section_bloc/section_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/semester_bloc/semester_bloc.dart';
import 'package:markme_admin/features/academic_structure/screens/manage_academic_structure_screen.dart';
import 'package:markme_admin/features/academic_structure/screens/manage_batches.dart';
import 'package:markme_admin/features/academic_structure/screens/manage_branches.dart';
import 'package:markme_admin/features/academic_structure/screens/manage_courses.dart';
import 'package:markme_admin/features/academic_structure/screens/manage_sections.dart';
import 'package:markme_admin/features/academic_structure/screens/manage_semesters.dart';
import 'package:markme_admin/features/auth/models/auth_info.dart';
import 'package:markme_admin/features/auth/screens/auth_otp_screen.dart';
import 'package:markme_admin/features/auth/screens/auth_phone_no_screen.dart';
import 'package:markme_admin/features/auth/screens/splash_screen.dart';
import 'package:markme_admin/features/dashboard/screens/admin_dashboard_screen.dart';
import 'package:markme_admin/features/onboarding/bloc/onboard_bloc.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';
import 'package:markme_admin/features/onboarding/screens/personal_info_screen.dart';
import 'package:markme_admin/features/subjects/bloc/subject_bloc.dart';
import 'package:markme_admin/features/subjects/screens/manage_subjects.dart';
import 'package:markme_admin/features/teacher/bloc/teacher_bloc.dart';
import 'package:markme_admin/features/teacher/screens/manage_teachers.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/authPhone',
      name: 'auth_phone',
      builder: (context, state) => AuthPhoneNumberScreen(),
    ),
    GoRoute(
      path: '/authOtp',
      name: 'auth_otp',
      builder: (context, state) {
        final String verificationId = state.extra as String;
        return AuthOtpScreen(verificationId: verificationId);
      },
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) {
        final authInfo = state.extra as AuthInfo;
        return BlocProvider(
          create: (_) => OnboardBloc(sl()), // This is a separate bloc — fine!
          child: PersonalInfoScreen(
            uid: authInfo.uid,
            phoneNumber: authInfo.phoneNumber,
          ),
        );
      },
    ),
    GoRoute(
      path: '/dashboardScreen',
      name: 'dashboard_screen',
      builder: (context, state) {
        final user = state.extra as AdminUser;
        return DashboardScreen(
          user: user,
        ); // AuthBloc already available from root
      },
    ),
    GoRoute(
      path: '/manageAcademicStructure',
      name: 'manage_academic_structure',
      builder: (context, state) {
        return ManageAcademicStructureScreen();
      },
    ),
    GoRoute(
      path: '/manageCourses',
      name: 'manage_courses',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => CourseBloc(sl()),
          child: ManageCourses(),
        );
      },
    ),
    GoRoute(
      path: '/manageBranches',
      name: 'manage_branches',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => BranchBloc(sl(), sl()),
          child: ManageBranches(),
        );
      },
    ),
    GoRoute(
      path: '/manageSemesters',
      name: 'manage_semesters',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => SemesterBloc(sl(), sl()),
          child: ManageSemesters(),
        );
      },
    ),
    GoRoute(
      path: '/manageBatches',
      name: 'manage_batches',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => AcademicBatchBloc(sl(),sl()),
          child: ManageBatches(),
        );
      },
    ),
    GoRoute(
      path: '/manageSections',
      name: 'manage_sections',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => SectionBloc(sl(), sl(), sl()),
          child: ManageSections(),
        );
      },
    ),
    GoRoute(
      path: '/manageSubjects',
      name: 'manage_subjects',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => SubjectBloc(sl(), sl(), sl()),
          child: ManageSubjects(),
        );
      },
    ),
    GoRoute(path: '/manageTeachers',
    name: 'manage_teachers',
      builder: (context,state){
      return BlocProvider(
        create: (_) =>TeacherBloc(sl(),sl()),
        child: ManageTeachers(),
      );
      }
    )
  ],
);
