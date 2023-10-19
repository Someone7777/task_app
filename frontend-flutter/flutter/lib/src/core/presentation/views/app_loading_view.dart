import 'package:flutter/material.dart';
import 'package:task_app/config/app_colors.dart';

class AppLoadingView extends StatelessWidget {
  /// Named route for [AppLoadingView]
  static const String routeName = 'loading';

  /// Path route for [AppLoadingView]
  static const String routePath = 'load';

  final void Function(BuildContext context)? func;

  const AppLoadingView({this.func, super.key});

  @override
  Widget build(BuildContext context) {
    if (func != null) func!(context);
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator.adaptive(
            valueColor:
                AlwaysStoppedAnimation<Color>(AppColors.appLoadingCircleColor),
            strokeWidth: 6.0,
          ),
        ),
      ),
    );
  }
}
