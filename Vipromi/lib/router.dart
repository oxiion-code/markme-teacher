import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vipromi/models/product_item_model.dart';
import 'package:vipromi/repositories/auth_repository.dart';
import 'package:vipromi/screens/authentication/sign_in_screen.dart';
import 'package:vipromi/screens/authentication/sign_up_screen.dart';
import 'package:vipromi/screens/contact_us/contact_form.dart';
import 'package:vipromi/screens/home/home_view.dart';
import 'package:vipromi/screens/know_animal/know_your_animal.dart';
import 'package:vipromi/screens/product_views/product_detail_screen.dart';
import 'package:vipromi/screens/product_views/products_list_view.dart';
import 'package:vipromi/screens/settings/settings_screen.dart';
import 'package:vipromi/viewmodels/feed_bloc/feed_bloc.dart';
import 'package:vipromi/viewmodels/home_bloc/home_bloc.dart';
import 'package:vipromi/viewmodels/product_bloc/product_bloc.dart';


import 'locator.dart';

final GoRouter router = GoRouter(
  initialLocation: '/signup',
  redirect: (context, GoRouterState state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggedIn = user != null;
    final location = state.uri.toString();
    final loggingIn = location == '/signup' || location == '/signin';
    if (!isLoggedIn && !loggingIn) {
      return '/signup';
    } else if (isLoggedIn && loggingIn) {
      return '/home';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/signin', builder: (context, state) => SignInScreen()),
    GoRoute(
      path: '/signup',
      builder: (context, state) {
        return SignUpScreen();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        return BlocProvider<HomeBloc>(
          create:
              (_) =>
                  HomeBloc(authRepository: sl<AuthRepository>())
                    ..add(LoadUserData()),
          child: HomeView(),
        );
      },
    ),
    GoRoute(
      path: '/knowyouranimal',
      builder:
          (context, state) => BlocProvider(
            create: (_) => sl<FeedBloc>()..add(LoadProductsFromJson(context)),
            child: KnowYourAnimal(),
          ),
    ),
    GoRoute(
      path: '/products',
      builder:
          (context, state) => BlocProvider(
            create:
                (_) => sl<ProductBloc>()..add(LoadProductsFromCJson(context)),
            child: ProductsListView(),
          ),
    ),
    GoRoute(path: '/productDetail',
      builder: (context,state){
      final product=state.extra as Product;
      return ProductDetailScreen(product: product,);
      }
),
    GoRoute(path: '/contactus',builder: (context,state){
      return ContactFormScreen();
    }),
    GoRoute(path: '/settings',builder: (context,state){
      return SettingScreen();
    })
  ],
);
