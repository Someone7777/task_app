import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_picker/languages.dart';
import 'package:task_app/config/app_colors.dart';
import 'package:task_app/config/app_layout.dart';
import 'package:task_app/src/core/presentation/widgets/app_title.dart';
import 'package:task_app/src/core/presentation/widgets/language_picker_dropdown.dart';
import 'package:task_app/src/core/providers.dart';
import 'package:task_app/src/features/auth/presentation/widgets/login_form.dart';
import 'package:task_app/src/features/auth/presentation/widgets/register_form.dart';
import 'package:universal_io/io.dart';

final lastExitPressState = ValueNotifier<DateTime?>(null);

class AuthView extends ConsumerWidget {
  /// Named route for [AuthView]
  static const String routeName = 'authentication';

  /// Path route for [AuthView]
  static const String routePath = 'auth';

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final registerUsernameController = TextEditingController();
  final registerFullnameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerPassword2Controller = TextEditingController();
  final registerInvitationCodeController = TextEditingController();

  @visibleForTesting
  final cache = ValueNotifier<Widget>(Container());

  AuthView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final appLocalizationStateNotifier =
        ref.read(appLocalizationsProvider.notifier);
    return WillPopScope(
        onWillPop: () async {
          final now = DateTime.now();
          if (lastExitPressState.value != null &&
              now.difference(lastExitPressState.value!) <
                  const Duration(seconds: 2)) {
            exit(0);
          } else {
            lastExitPressState.value = now;
            return false;
          }
        },
        child: Scaffold(
            appBar: AppBar(
                title: const AppTitle(fontSize: 30),
                backgroundColor: AppColors.appBarBackgroundColor,
                automaticallyImplyLeading: false),
            body: SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: AppLanguagePickerDropdown(
                        appLocalizations: appLocalizations,
                        onValuePicked: (Language language) {
                          Locale locale = Locale(language.isoCode);
                          appLocalizationStateNotifier.setLocale(locale);
                        }),
                  ),
                  const SizedBox(height: AppLayout.genericPadding),
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      initialIndex: 0,
                      child: Column(
                        children: [
                          TabBar(
                              tabAlignment: TabAlignment.center,
                              isScrollable: true,
                              dividerColor: Colors.transparent,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorColor:
                                  const Color.fromARGB(255, 7, 136, 76),
                              tabs: [
                                Tab(
                                  child: Text(
                                    appLocalizations.signIn,
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 20),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    appLocalizations.register,
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 20),
                                  ),
                                )
                              ]),
                          Expanded(
                              child: TabBarView(children: [
                            LoginForm(
                              emailController: loginEmailController,
                              passwordController: loginPasswordController,
                            ),
                            RegisterForm(
                              usernameController: registerUsernameController,
                              fullnameController: registerFullnameController,
                              emailController: registerEmailController,
                              passwordController: registerPasswordController,
                              repeatPasswordController:
                                  registerPassword2Controller,
                            )
                          ])),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
