import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/phone_no_box.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class AuthPhoneNumberScreen extends StatefulWidget {
  const AuthPhoneNumberScreen({super.key});

  @override
  State<AuthPhoneNumberScreen> createState() => _AuthPhoneNumberScreenState();
}

class _AuthPhoneNumberScreenState extends State<AuthPhoneNumberScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            AppUtils.showCustomLoading(context);
          }
          if (state is OtpSent) {
            context.pop();
            context.push('/authOtp', extra: state.verificationId);
          } else if (state is AuthError) {
            context.pop();
            AppUtils.showCustomSnackBar(context,state.error);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: Image.asset(
                      "assets/icons/admin_logo_no_bg.png",
                      height: 150,
                      width: 150,
                    ),
                  ),
                  const Text(
                    "Teacher",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      color: AppColors.primary,
                    ),
                  ),
                  const Text(
                    "Attendance just got smarter",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  PhoneNumberBox(controller: phoneController),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                "By submitting this application you confirm that you are authorized to share this information and agree with our ",
                          ),
                          TextSpan(
                            text: "Terms and Conditions",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomButton(
                    onTap: () {
                      final phoneNumber=phoneController.text.trim();
                      if(phoneNumber.isNotEmpty && phoneNumber.length==10){
                        context.read<AuthBloc>().add(SendOtpEvent('+91$phoneNumber'));
                      }else{
                        AppUtils.showCustomSnackBar(context, "Enter valid phone number");
                      }
                    },
                    text: 'Send OTP',
                    icon: Icons.message_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
