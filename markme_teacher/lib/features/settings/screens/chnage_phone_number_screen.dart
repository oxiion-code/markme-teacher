import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_teacher/core/models/teacher.dart';
import 'package:markme_teacher/features/settings/models/update_number_info.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/phone_no_box.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';

class UpdatePhoneNumberScreen extends StatefulWidget {
  final Teacher teacher;
  const UpdatePhoneNumberScreen({super.key, required this.teacher});

  @override
  State<UpdatePhoneNumberScreen> createState() =>
      _UpdatePhoneNumberScreenState();
}

class _UpdatePhoneNumberScreenState extends State<UpdatePhoneNumberScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Phone Number",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            AppUtils.showCustomLoading(context);
          }
          if (state is UpdateOtpSent) {
            context.pop();
            final phoneNumber=phoneController.text.trim();
            final phoneUpdateInfo=UpdatePhoneNumberInfo(uid: widget.teacher.teacherId , verificationId: state.verificationId, phoneNumber: '+91$phoneNumber');
            context.push('/updateOtp', extra: phoneUpdateInfo);
          } else if (state is AuthError) {
            context.pop();
            AppUtils.showCustomSnackBar(context, state.error);
          } else if (state is PhoneNumberUpdated) {
            context.pop();
            AppUtils.showCustomSnackBar(
              context,
              "Phone number updated successfully!",
            );
            context.pop();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 30),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primaryLight.withOpacity(0.3),
                    child: Icon(
                      Icons.phone_android,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Update your registered phone number",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: AppColors.primaryDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  PhoneNumberBox(controller: phoneController),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      "Make sure this number is active. You will receive an OTP for verification.",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  CustomButton(
                    onTap: () {
                      final phoneNumber = phoneController.text.trim();
                      if (phoneNumber.isNotEmpty && phoneNumber.length == 10) {
                        context.read<AuthBloc>().add(
                          SendUpdateOtpEvent('+91$phoneNumber'),
                        );
                      } else {
                        AppUtils.showCustomSnackBar(
                          context,
                          "Enter valid phone number",
                        );
                      }
                    },
                    text: 'Send OTP to Update',
                    icon: Icons.update,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
