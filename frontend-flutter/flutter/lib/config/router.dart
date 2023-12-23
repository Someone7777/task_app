import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app/config/api_client.dart';
import 'package:task_app/src/core/presentation/views/app_info_loading_view.dart';
import 'package:task_app/src/core/presentation/views/error_view.dart';
import 'package:task_app/src/core/presentation/views/app_loading_view.dart';
import 'package:task_app/src/features/auth/presentation/views/auth_loading_view.dart';
import 'package:task_app/src/features/auth/presentation/views/auth_view.dart';
import 'package:task_app/src/features/auth/presentation/views/logout_view.dart';
import 'package:task_app/src/features/auth/presentation/views/reset_password_view.dart';
import 'package:task_app/src/features/auth/presentation/views/settings_view.dart';
import 'package:task_app/src/features/auth/providers.dart';
import 'package:task_app/src/features/home/presentation/views/home_view.dart';

final router = GoRouter(
  errorBuilder: (context, state) {
    if (state.error
        .toString()
        .contains("/${AppErrorView.noConnectionErrorPath}")) {
      return const AppErrorView(
          location: "/${AppErrorView.noConnectionErrorPath}");
    }
    if (state.error.toString().contains("/${AppErrorView.notFoundPath}")) {
      return const AppErrorView(location: "/${AppErrorView.notFoundPath}");
    }
    debugPrint(state.error.toString());
    return const AppErrorView(location: '/${AppErrorView.notFoundPath}');
  },
  navigatorKey: navigatorKey,
  debugLogDiagnostics: true,
  refreshListenable: authStateListenable,
  redirect: appGuard,
  observers: [routeObserver],
  routes: [
    GoRoute(
        name: 'root',
        path: '/',
        builder: (_, __) => const AppLoadingView(),
        redirect: rootGuard,
        routes: [
          GoRoute(
            name: AppInfoLoadingView.routeName,
            path: AppInfoLoadingView.routePath,
            builder: (context, state) => const AppInfoLoadingView(),
          ),
          GoRoute(
              name: HomeView.routeName,
              path: HomeView.routePath,
              builder: (context, state) => const HomeView(),
              redirect: authGuardOrNone),
          GoRoute(
            name: AuthLoadingView.routeName,
            path: AuthLoadingView.routePath,
            builder: (context, state) {
              return AuthLoadingView(
                  location: GoRouterState.of(context)
                              .uri
                              .queryParameters['path'] !=
                          null
                      ? GoRouterState.of(context).uri.queryParameters['path']!
                      : "/${AuthLoadingView.routePath}");
            },
          ),
          GoRoute(
            name: AuthView.routeName,
            path: AuthView.routePath,
            redirect: authGuard,
            builder: (context, state) => AuthView(),
          ),
          GoRoute(
            name: LogoutView.routeName,
            path: LogoutView.routePath,
            redirect: authGuard,
            builder: (context, state) => const LogoutView(),
          ),
          GoRoute(
            name: AppLoadingView.routeName,
            path: AppLoadingView.routePath,
            builder: (context, state) => const AppLoadingView(),
          ),
          GoRoute(
              name: 'passwordRoot',
              path: 'password',
              redirect: passwordGuard,
              builder: (_, __) => AppLoadingView(func: (context) {
                    context.go("/${AuthView.routePath}");
                  }),
              routes: [
                GoRoute(
                  name: ResetPasswordView.routeName,
                  path: ResetPasswordView.routePath,
                  builder: (context, state) => ResetPasswordView(),
                ),
              ]),
        ]),
  ],
);

final navigatorKey = GlobalKey<NavigatorState>();

const ValueKey<String> _scaffoldKey = ValueKey<String>('taskapp_scaffold');

/// Route observer to use with RouteAware
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

@visibleForTesting
String? appGuard(BuildContext context, GoRouterState state) {
  return null;
}

@visibleForTesting
String? rootGuard(BuildContext context, GoRouterState state) {
  if (state.uri.toString() == "/") {
    return "/${AppInfoLoadingView.routePath}";
  }
  return null;
}

Future<String?> logoutGuard(BuildContext context, GoRouterState state) async {
  final loggedIn = authStateListenable.value;
  final goingToLogout = state.matchedLocation == '/${LogoutView.routePath}';
  if (!loggedIn && goingToLogout) {
    return "/";
  }
  return null;
}

Future<String?> authGuard(BuildContext context, GoRouterState state) async {
  final loggedIn = authStateListenable.value;
  final goingToAuth = state.name == AuthView.routeName;
  if (loggedIn && goingToAuth) {
    return "/${HomeView.routePath}";
  } else if (!loggedIn && !goingToAuth) {
    return '/${AuthView.routePath}';
  } else if (state.extra == null || state.extra != true) {
    return "/${AuthLoadingView.routePath}?path=/${AuthView.routePath}";
  }
  return null;
}

Future<String?> authGuardOrNone(
    BuildContext context, GoRouterState state) async {
  final loggedIn = authStateListenable.value;
  final isConnected = connectionStateListenable.value;
  if (!isConnected &&
      (state.name == SettingsView.routeName ||
          state.name == LogoutView.routeName)) {
    return "/${AppErrorView.noConnectionErrorPath}";
  }
  if (!loggedIn) {
    return "/${AuthLoadingView.routePath}?path=${state.matchedLocation}";
  }
  return null;
}

Future<String?> passwordGuard(BuildContext context, GoRouterState state) async {
  final isConnected = connectionStateListenable.value;
  if (!isConnected) {
    return "/${AppErrorView.noConnectionErrorPath}";
  }
  final goingToPassword = state.matchedLocation == '/password';
  if (goingToPassword) return "/";
  return null;
}
