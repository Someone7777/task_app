import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app/config/router.dart';
import 'package:task_app/src/core/presentation/views/error_view.dart';
import 'package:task_app/src/core/presentation/widgets/loading_widget.dart';
import 'package:task_app/src/features/auth/presentation/views/auth_view.dart';
import 'package:task_app/src/features/auth/providers.dart';

class LogoutView extends ConsumerWidget {
  /// Named route for [LogoutView]
  static const String routeName = 'logout';

  /// Path route for [LogoutView]
  static const String routePath = 'logout';

  const LogoutView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider.notifier);
    Future.delayed(Duration.zero, () async {
      final value = await authController.signOut();
      value.fold((_) {
        ErrorView.go();
      }, (_) {
        navigatorKey.currentContext!.goNamed(AuthView.routeName);
      });
    });
    return const Scaffold(body: LoadingWidget());
  }
}