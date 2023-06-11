import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app/config/app_colors.dart';
import 'package:task_app/config/router.dart';
import 'package:task_app/src/core/presentation/widgets/app_title.dart';
import 'package:task_app/src/core/providers.dart';
import 'package:task_app/src/core/utils/widget_utils.dart';
import 'package:task_app/src/features/auth/presentation/widgets/settings_widget.dart';
import 'package:task_app/src/features/auth/providers.dart';

class SettingsView extends ConsumerWidget {
  /// Route name
  static const routeName = 'settings';

  /// Route path
  static const routePath = 'settings';
  @visibleForTesting
  final cache = ValueNotifier<Widget>(Container());

  SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);
    final appLocalizations = ref.watch(appLocalizationsProvider);
    return user.when(data: (data) {
      cache.value = Scaffold(
          appBar: AppBar(
            title: const AppTitle(fontSize: 30),
            backgroundColor: AppColors.appBarBackgroundColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              // TODO change for home view
              onPressed: () => navigatorKey.currentContext!
                  .goNamed("HomeView.routeName"),
            ),
          ),
          body: SafeArea(
              child: Center(
            child: SettingsWidget(user: data!),
          )));
      return cache.value;
    }, error: (error, st) {
      return showError(
          error: error,
          background: cache.value,
          text: appLocalizations.genericError);
    }, loading: () {
      return showLoading(background: cache.value);
    });
  }
}