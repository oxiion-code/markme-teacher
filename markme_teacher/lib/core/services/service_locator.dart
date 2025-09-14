import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:markme_teacher/features/attendance/bloc/attendance_bloc.dart';
import 'package:markme_teacher/features/attendance/repositories/attendance_repository.dart';
import 'package:markme_teacher/features/attendance/repositories/attendance_repository_impl.dart';
import 'package:markme_teacher/features/auth/bloc/auth_bloc.dart';
import 'package:markme_teacher/features/auth/repository/auth_repository.dart';
import 'package:markme_teacher/features/auth/repository/auth_repository_impl.dart';
import 'package:markme_teacher/features/class/repositories/class_repository.dart';
import 'package:markme_teacher/features/class/repositories/class_repository_impl.dart';
import 'package:markme_teacher/features/home/bloc/home_bloc.dart';
import 'package:markme_teacher/features/home/repositories/home_repository.dart';
import 'package:markme_teacher/features/home/repositories/home_repository_impl.dart';
import 'package:markme_teacher/features/lesson_plan/bloc/lesoon_bloc.dart';
import 'package:markme_teacher/features/lesson_plan/repositories/lesson_plan_repository.dart';
import 'package:markme_teacher/features/lesson_plan/repositories/lesson_plan_repository_impl.dart';
import 'package:markme_teacher/features/section/blocs/section_bloc.dart';
import 'package:markme_teacher/features/settings/bloc/setting_bloc.dart';
import 'package:markme_teacher/features/settings/repositories/setting_repository.dart';
import 'package:markme_teacher/features/settings/repositories/setting_repository_impl.dart';
import 'package:markme_teacher/features/student/repositories/student_repository.dart';
import 'package:markme_teacher/features/student/repositories/student_repository_impl.dart';
import 'package:markme_teacher/features/subject/blocs/subject_bloc.dart';
import 'package:markme_teacher/features/subject/repositories/subject_repository.dart';
import 'package:markme_teacher/features/subject/repositories/subject_repository_impl.dart';

import '../../features/class/bloc/class_bloc.dart';
import '../../features/section/repository/section_repository.dart';
import '../../features/section/repository/section_repository_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl(), sl()),
  );
  sl.registerLazySingleton<SubjectRepository>(
    () => SubjectRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<SectionRepository>(
    () => SectionRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));
  sl.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ClassRepository>(() => ClassRepositoryImpl(sl()));
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<LessonRepository>(() => LessonRepositoryImpl(sl()));
  sl.registerLazySingleton<SettingRepository>(
    () => SettingRepositoryImpl(sl()),
  );

  sl.registerFactory<AuthBloc>(() => AuthBloc(sl()));
  sl.registerFactory<SubjectBloc>(() => SubjectBloc(sl()));
  sl.registerFactory<SectionBloc>(() => SectionBloc(sl(), sl()));
  sl.registerFactory<HomeBloc>(() => HomeBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory<ClassBloc>(() => ClassBloc(sl(), sl(), sl()));
  sl.registerFactory<AttendanceBloc>(() => AttendanceBloc(sl()));
  sl.registerFactory<LessonBloc>(() => LessonBloc(sl()));
  sl.registerFactory<SettingBloc>(() => SettingBloc(sl()));
}
