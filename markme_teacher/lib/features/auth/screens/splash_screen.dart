import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/color_palette.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/custom_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary.withOpacity(0.1), AppColors.scaffoldBg],
          ),
        ),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              AppUtils.showCustomLoading(context);
            }else{
              context.pop();
            }
            if (state is UnAuthenticated) {
              context.goNamed('auth_phone');
            } else if (state is UserAlreadyLoggedIn) {
              context.go('/home', extra: state.teacher);
            } else if (state is AuthError) {
              AppUtils.showCustomSnackBar(context, state.error);
            }
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/logo_no_brand_no_bg.png",
                            height: 220, // Increased size
                            width: 220, // Increased size
                          ),

                          const SizedBox(height: 2),

                          Text(
                            "Where Every Presence Counts",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.blue.shade400,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              // font-family should be set in ThemeData
                            ),
                          ),
                          const SizedBox(height: 15),
                          Opacity(
                            opacity: 0.5, // 0.0 = fully transparent, 1.0 = fully opaque
                            child: Image.asset(
                              "assets/images/gita_without_bg.png",
                              height: 150,
                              width: 150,
                            ),
                          )
                          ,
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                  CustomButton(
                    onTap: () {
                      context.read<AuthBloc>().add(CheckAuthStatus());
                    },
                    text: "Continue",
                    icon: Icons.arrow_forward_ios_rounded,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}