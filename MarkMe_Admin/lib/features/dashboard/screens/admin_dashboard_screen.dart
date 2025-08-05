import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/core/widgets/custom_button.dart';
import 'package:markme_admin/features/auth/bloc/auth_bloc.dart';
import 'package:markme_admin/features/auth/bloc/auth_event.dart';
import 'package:markme_admin/features/auth/bloc/auth_state.dart';
import 'package:markme_admin/features/dashboard/widgets/app_bar.dart';
import 'package:markme_admin/features/dashboard/widgets/dashboard_drawer.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';

class DashboardScreen extends StatelessWidget {
  final AdminUser user;
  const DashboardScreen({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: user,),
      drawer: DashboardDrawer(user: user),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
                AppUtils.showCustomLoading(context);
              } else if (state is LogoutSuccess) {
                context.goNamed('auth_phone');
              } else if (state is AuthError) {
                AppUtils.showCustomSnackBar(context, state.error);
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Dashboard Screen",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                Text('welcome ${user.name}'),
                Text('joined ${user.joinedAt}'),
                Text('admin type ${user.adminType}'),
                const SizedBox(),
                CustomButton(onTap: (){
                  context.read<AuthBloc>().add(LogoutRequested());
                }, text: 'Logout', icon: null)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
