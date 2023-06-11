import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app/config/api_client.dart';
import 'package:task_app/src/core/presentation/views/error_view.dart';
import 'package:task_app/src/core/presentation/views/loading_view.dart';
import 'package:task_app/src/features/auth/presentation/views/auth_loading_view.dart';
import 'package:task_app/src/features/auth/presentation/views/auth_view.dart';
import 'package:task_app/src/features/auth/presentation/views/logout_view.dart';
import 'package:task_app/src/features/auth/presentation/views/reset_password_view.dart';
import 'package:task_app/src/features/auth/presentation/views/settings_view.dart';
import 'package:task_app/src/features/auth/providers.dart';

final router = GoRouter(
  errorBuilder: (context, state) {
    if (state.error
        .toString()
        .contains("/${ErrorView.noConnectionErrorPath}")) {
      return const ErrorView(location: "/${ErrorView.noConnectionErrorPath}");
    }
    if (state.error.toString().contains("/${ErrorView.notFoundPath}")) {
      return const ErrorView(location: "/${ErrorView.notFoundPath}");
    }
    debugPrint(state.error.toString());
    return const ErrorView(location: '/${ErrorView.routePath}');
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
        builder: (_, __) => const LoadingView(),
        redirect: rootGuard,
        routes: [
          GoRoute(
            name: AuthLoadingView.routeName,
            path: AuthLoadingView.routePath,
            builder: (context, state) {
              return AuthLoadingView(
                  location: state.queryParams['path'] ?? "/${AuthLoadingView.routePath}");
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
            name: LoadingView.routeName,
            path: LoadingView.routePath,
            builder: (context, state) => const LoadingView(),
          ),
          GoRoute(
              name: 'passwordRoot',
              path: 'password',
              redirect: passwordGuard,
              builder: (_, __) => LoadingView(func: (context) {
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
  final goingToRoot = state.location == '/';
  if (goingToRoot) {
    return "/${AuthLoadingView.routePath}?path=/${AuthView.routePath}";
  }
  return null;
}

Future<String?> logoutGuard(BuildContext context, GoRouterState state) async {
  final loggedIn = authStateListenable.value;
  final goingToLogout = state.location == '/${LogoutView.routePath}';
  if (!loggedIn && goingToLogout) {
    return "/";
  }
  return null;
}

Future<String?> authGuard(BuildContext context, GoRouterState state) async {
  final loggedIn = authStateListenable.value;
  final goingToAuth = state.name == AuthView.routeName;
  if (loggedIn && goingToAuth) {
    // TODO home view
    return "/HomeView.routePath";
  } else if (!loggedIn && !goingToAuth) {
    return '/';
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
    return "/${ErrorView.noConnectionErrorPath}";
  }
  if (!loggedIn) {
    return "/${AuthLoadingView.routePath}?path=${state.location}";
  }
  return null;
}

Future<String?> passwordGuard(BuildContext context, GoRouterState state) async {
  final isConnected = connectionStateListenable.value;
  if (!isConnected) {
    return "/${ErrorView.noConnectionErrorPath}";
  }
  final goingToPassword = state.location == '/password';
  if (goingToPassword) return "/";
  return null;
}

/// A page that fades in an out.
class FadeTransitionPage extends CustomTransitionPage<void> {
  /// Creates a [FadeTransitionPage].
  FadeTransitionPage({
    required LocalKey key,
    required Widget child,
  }) : super(
            key: key,
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
                  opacity: animation.drive(_curveTween),
                  child: child,
                ),
            child: child);

  static final CurveTween _curveTween = CurveTween(curve: Curves.easeIn);
}
