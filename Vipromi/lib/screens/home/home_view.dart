import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vipromi/viewmodels/home_bloc/home_bloc.dart';


import '../widgets/LoadingAnimation.dart';
import 'drawer_view.dart';
import 'home_container_screen.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoadingData) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => LoadingAnimation(),
          );
        } else {
          Navigator.of(context, rootNavigator: true).pop(); // Dismiss loader
        }

        if (state is HomeLoadDataError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text(
            'Home',
            style: GoogleFonts.inriaSans(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              _key.currentState?.openDrawer();
            },
            icon: Icon(Icons.menu),
          ),
          backgroundColor: Colors.orange[300],
        ),
        drawer: AppSideDrawer(),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeDataLoadSuccess) {
              final user = state.userData;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: HomeContainer(),
              );
            }
            return Center(child: Text("Welcome to Home"));
          },
        ),
      ),
    );
  }
}
