import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:markme_teacher/config/app_router.dart';
import 'package:markme_teacher/core/theme/app_theme.dart';
import 'package:markme_teacher/core/services/service_locator.dart' as di;

import 'core/models/subject.dart';
import 'core/models/teacher.dart';
import 'features/auth/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  await Hive.initFlutter();

  // Register adapters (must match your @HiveType classes)
  Hive.registerAdapter(TeacherAdapter());
  Hive.registerAdapter(SubjectAdapter()); // since Teacher contains List<Subject>

  await Hive.openBox<Teacher>('teacherBox');
  await Hive.openBox<Subject>('subjectBox'); // optional if you want subjects standalone


  runApp(
    MultiBlocProvider(
      providers: [BlocProvider<AuthBloc>(create: (_) => di.sl<AuthBloc>())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Teacher App',
      routerConfig: appRouter,
      theme: AppTheme.lightTheme,
    );
  }
}
