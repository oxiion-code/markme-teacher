import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:task_ng/blocs/theme/theme_state.dart';
import 'package:task_ng/blocs/user_detail/user_detail_bloc.dart';
import 'package:task_ng/blocs/user_list/user_list_event.dart';
import 'package:task_ng/models/local_post.dart';
import 'package:task_ng/repositories/user_repository.dart';
import 'package:task_ng/screens/user_list_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'blocs/theme/theme_bloc.dart';
import 'blocs/user_list/user_list_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(LocalPostAdapter());
  await Hive.openBox<LocalPost>('localPosts');
  runApp(const MyApp());
}

 class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepository=UserRepository();
    return MultiBlocProvider(providers: [
      BlocProvider(create: (_)=>ThemeBloc()),
      BlocProvider(create: (_)=>UserListBloc(userRepository)..add(LoadUsers())),
      BlocProvider(create: (_)=>UserDetailBloc(userRepository))
    ], child:BlocBuilder<ThemeBloc,ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "User Management App",
          theme: state.themeData,
          home: const UserListScreen(),
        );
      },
    )
    );
  }
 }
