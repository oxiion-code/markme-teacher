import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vipromi/models/user_data.dart';
import 'package:vipromi/viewmodels/auth_bloc/auth_bloc.dart';


import '../widgets/LoadingAnimation.dart';
import '../widgets/app_textfiled.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
            barrierDismissible: false,
            builder:
                (_) =>LoadingAnimation(),
          );
        } else if (state is AuthSuccess) {
          Navigator.pop(context);
          context.go('/home');
        } else if (state is AuthError) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.orange[300]),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Text(
                'Create an account',
                style: GoogleFonts.inriaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 28
                ),
              ),
              SizedBox(height: 16),
              AppInputTextField(
                controller: _emailController,
                labelText: 'Enter Email',
              ),
              SizedBox(height: 16),
              AppInputTextField(
                controller: _newPasswordController,
                labelText: 'New Password',
              ),
              SizedBox(height: 16),
              AppInputTextField(
                controller: _confirmPasswordController,
                labelText: 'Re-enter password',
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.go('/signin');
                },
                child: Text('Already have an account ! Click here',style: GoogleFonts.inriaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.blueAccent
                ),),
              ),
              SizedBox(height: 16),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orange[700],
                  elevation: 16,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  final email = _emailController.text.trim();
                  final password = _newPasswordController.text.trim();
                  final confirmPassword =
                      _confirmPasswordController.text.trim();
                  if (!isValidEmail(email)) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a valid email address'),
                      ),
                    );
                    return;
                  }
                  if (password.length < 6) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter minimum 6 characters'),
                      ),
                    );
                    return;
                  }
                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Passwords do not match')),
                    );
                    return;
                  }
                  final userData = UserData(
                    email: email,
                    phoneNumber: "",
                    name: "",
                    age: 0,
                  );
                  context.read<AuthBloc>().add(
                    SignUpEvent(userData: userData, password: password),
                  );
                },
                child: Text(
                  "Create Account!",
                  style: GoogleFonts.inriaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 15
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
