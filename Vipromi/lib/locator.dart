import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:vipromi/repositories/auth_repository.dart';
import 'package:vipromi/repositories/feed_repository.dart';
import 'package:vipromi/repositories/product_repository.dart';
import 'package:vipromi/services/firebase_auth_service.dart';
import 'package:vipromi/viewmodels/auth_bloc/auth_bloc.dart';
import 'package:vipromi/viewmodels/feed_bloc/feed_bloc.dart';
import 'package:vipromi/viewmodels/product_bloc/product_bloc.dart';

final sl = GetIt.instance;

void setUpLocator() {
  sl.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Register FirebaseFirestore
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl<FirebaseAuthService>(), sl<FirebaseFirestore>()),);
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl<AuthRepository>()));

  sl.registerLazySingleton<FeedRepository>(() => FeedRepository());
  sl.registerFactory<FeedBloc>( () => FeedBloc(sl<FeedRepository>()) );

  sl.registerFactory<ProductBloc>(()=>ProductBloc(sl<ProductRepository>()));
  sl.registerLazySingleton<ProductRepository>(()=>ProductRepository());
}

