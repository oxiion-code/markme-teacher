import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vipromi/viewmodels/auth_bloc/auth_bloc.dart';

import '../widgets/LoadingAnimation.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[300],
        title: Text(
          "Settings",
          style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => LoadingAnimation(),
            );
          } else if (state is AuthInitial) {
            Navigator.pop(context);
            context.go('/signin');
          } else if (state is AuthError) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [OutlinedButton(onPressed: () {
              context.read<AuthBloc>().add(SignOutEvent());
            }, child: Text("Logout"))],
          ),
        ),
      ),
    );
  }
}
