import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_app/config/router.dart';
import 'package:task_app/src/core/presentation/views/app_loading_view.dart';
import 'package:task_app/src/features/auth/presentation/views/auth_view.dart';

class AppInfoLoadingView extends ConsumerStatefulWidget {
  const AppInfoLoadingView({super.key});

  @override
  ConsumerState<AppInfoLoadingView> createState() => _AppInfoLoadingViewState();
}

class _AppInfoLoadingViewState extends ConsumerState<AppInfoLoadingView> {
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      router.goNamed(AuthView.routeName);
    });
    return const Scaffold(body: AppLoadingView());
  }
}
