import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app/config/app_colors.dart';
import 'package:task_app/config/router.dart';
import 'package:task_app/src/core/presentation/widgets/app_title.dart';
import 'package:task_app/src/features/auth/presentation/views/auth_view.dart';
import 'package:task_app/src/features/auth/presentation/widgets/reset_password_form.dart';

class ResetPasswordView extends ConsumerWidget {
  /// Route name
  static const routeName = 'resetPassword';

  /// Route path
  static const routePath = 'reset';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final codeController = TextEditingController();

  ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const AppTitle(fontSize: 30),
        backgroundColor: AppColors.appBarBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              navigatorKey.currentContext!.goNamed(AuthView.routeName),
        ),
      ),
      body: SafeArea(child: Center(child: ResetPasswordForm())),
    );
  }
}