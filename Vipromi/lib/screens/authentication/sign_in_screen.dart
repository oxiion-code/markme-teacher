import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vipromi/viewmodels/auth_bloc/auth_bloc.dart';


import '../widgets/LoadingAnimation.dart';
import '../widgets/app_textfiled.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() {
    return _SignInScreenState();
  }
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailSignInController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          showDialog(
            context: context,
            builder: (_) => LoadingAnimation(),
            barrierDismissible: false,
          );
        }
        else if(state is AuthSuccess){
          Navigator.of(context).pop();
          context.go('/home');
        }else if(state is AuthError){
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.orange[300],title: Text(""),),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'SignIn',
                style: GoogleFonts.inriaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              AppInputTextField(
                labelText: 'Email',
                controller: _emailSignInController,
              ),
              SizedBox(height: 12),
              AppInputTextField(
                labelText: 'Password',
                controller: _passwordTextController,
              ),
              SizedBox(height: 28),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (!isValidEmail(_emailSignInController.text)) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Enter valid email')),
                    );
                    return;
                  }
                  if (_passwordTextController.text.length < 6) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Enter valid email')),
                    );
                    return;
                  }
                  context.read<AuthBloc>().add(
                    SignInEvent(email: _emailSignInController.text, password: _passwordTextController.text)
                  );
                },
                child: Text(
                  'Signin to Account',
                  style: GoogleFonts.inriaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
