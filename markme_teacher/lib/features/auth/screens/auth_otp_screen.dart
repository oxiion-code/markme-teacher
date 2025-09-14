import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/otp_boxes.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class AuthOtpScreen extends StatefulWidget {
  final String verificationId;
  const AuthOtpScreen({super.key, required this.verificationId});

  @override
  State<AuthOtpScreen> createState() => _AuthOtpScreenState();
}

class _AuthOtpScreenState extends State<AuthOtpScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            AppUtils.showCustomLoading(context);
          } else {
            context.pop();
          }
          if (state is AuthenticationSuccess) {
            if (state.isNewUser) {
              context.go('/authProfileUpdate', extra: state.teacher);
            } else {
              context.go('/home', extra: state.teacher);
            }
          } else if (state is AuthError) {
            AppUtils.showCustomSnackBar(context, state.error);
          } else if (state is LogoutSuccess) {
            context.pop();
            context.goNamed('auth_phone');
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  SizedBox(
                    child: Lottie.asset(
                      "assets/animations/otp_animation.json",
                      height: 120,
                      width: 120,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 24.0,
                      top: 12,
                      left: 24,
                      right: 24,
                    ),
                    child: Text(
                      "Please enter the OTP sent to your phone to complete verification.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                  OtpBoxes(controller: otpController),
                ],
              ),
              CustomButton(
                onTap: () {
                  final otp = otpController.text.trim();
                  if (otp.length == 6) {
                    context.read<AuthBloc>().add(
                      VerifyOtpEvent(widget.verificationId, otp),
                    );
                  } else {
                    AppUtils.showCustomSnackBar(
                      context,
                      "Enter a valid 6 digit OTP",
                    );
                  }
                },
                text: "Verify OTP",
                icon: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
