import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/otp_boxes.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import 'dart:async';


class UpdatePhoneOtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String uid;// for resend
  const UpdatePhoneOtpScreen({super.key, required this.verificationId, required this.phoneNumber, required this.uid});

  @override
  State<UpdatePhoneOtpScreen> createState() => _UpdatePhoneOtpScreenState();
}

class _UpdatePhoneOtpScreenState extends State<UpdatePhoneOtpScreen> {
  final TextEditingController otpController = TextEditingController();
  Timer? _timer;
  int _start = 60; // 60 sec countdown
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _canResend = false;
    _start = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _canResend = true;
        });
        _timer?.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    _timer?.cancel();
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

          if (state is PhoneNumberUpdated) {
            AppUtils.showCustomSnackBar(
              context,
              "Phone number updated successfully!",
              isError: false,
            );
            context.pop(); // go back after update
          } else if (state is UpdateOtpSent) {
            AppUtils.showCustomSnackBar(
              context,
              "OTP sent successfully!",
              isError: false,
            );
            _startTimer();
          } else if (state is AuthError) {
            AppUtils.showCustomSnackBar(context, state.error);
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
                      "Enter the OTP sent to your new phone number to complete the update.",
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
                  const SizedBox(height: 20),
                  Text(
                    _canResend ? "Didn't receive OTP?" : "Resend OTP in $_start sec",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _canResend
                      ? GestureDetector(
                    onTap: () {
                      context.read<AuthBloc>().add(
                        SendUpdateOtpEvent(widget.phoneNumber),
                      );
                    },
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  )
                      : const SizedBox.shrink(),
                ],
              ),
              CustomButton(
                onTap: () {
                  final otp = otpController.text.trim();
                  if (otp.length == 6) {
                    context.read<AuthBloc>().add(
                      VerifyAndUpdatePhoneNumberEvent(
                        widget.verificationId,
                        otp,
                        widget.uid,
                        widget.phoneNumber
                      ),
                    );
                  } else {
                    AppUtils.showCustomSnackBar(
                      context,
                      "Enter a valid 6 digit OTP",
                    );
                  }
                },
                text: "Verify & Update",
                icon: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
