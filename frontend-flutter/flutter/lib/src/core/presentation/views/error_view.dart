import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app/config/router.dart';
import 'package:task_app/src/core/presentation/widgets/app_error_widget.dart';
import 'package:task_app/src/core/providers.dart';

class AppErrorView extends ConsumerWidget {
  /// Named route for [AppErrorView].
  static const String routeName = 'error';

  /// Path route for [AppErrorView].
  static const String routePath = 'error';

  /// Path route for [AppErrorView] with not found error.
  static const String notFoundPath = 'not-found';

  /// Path route for [AppErrorView] with no connection error.
  static const String noConnectionErrorPath = 'connection-error';

  final String location;

  const AppErrorView({required this.location, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    return Scaffold(
      body: AppErrorWidget(
          text: (location == '/$notFoundPath')
              ? appLocalizations.pageNotFound
              : (location == '/$noConnectionErrorPath')
                  ? appLocalizations.noConnection
                  : appLocalizations.genericError,
          icon: (location == '/$notFoundPath')
              ? Icons.question_mark
              : (location == '/$noConnectionErrorPath')
                  ? Icons.network_wifi_1_bar
                  : null),
    );
  }

  /// Redirects current view to [AppErrorView] using a gneric error.
  static void go() {
    navigatorKey.currentContext!.go('/$routePath');
  }

  /// Redirects current view to [AppErrorView] using a not found error.
  static void go404() {
    navigatorKey.currentContext!.go('/$notFoundPath');
  }
}
