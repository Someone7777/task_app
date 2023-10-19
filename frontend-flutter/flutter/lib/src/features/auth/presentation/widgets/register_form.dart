import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_app/src/core/presentation/widgets/app_text_button.dart';
import 'package:task_app/src/core/presentation/widgets/app_text_form_field.dart';
import 'package:task_app/src/core/presentation/widgets/password_text_form_field.dart';
import 'package:task_app/src/core/providers.dart';
import 'package:task_app/src/core/utils/dialog_utils.dart';
import 'package:task_app/src/core/utils/widget_utils.dart';
import 'package:task_app/src/features/auth/domain/values/user_email.dart';
import 'package:task_app/src/features/auth/domain/values/user_full_name.dart';
import 'package:task_app/src/features/auth/domain/values/user_name.dart';
import 'package:task_app/src/features/auth/domain/values/user_password.dart';
import 'package:task_app/src/features/auth/domain/values/user_repeat_password.dart';
import 'package:task_app/src/features/auth/providers.dart';

class RegisterForm extends ConsumerStatefulWidget {
  @visibleForTesting
  final cache = ValueNotifier<Widget>(Container());

  @visibleForTesting
  final TextEditingController usernameController;
  @visibleForTesting
  final TextEditingController fullnameController;
  @visibleForTesting
  final TextEditingController emailController;
  @visibleForTesting
  final TextEditingController passwordController;
  @visibleForTesting
  final TextEditingController repeatPasswordController;
  @visibleForTesting
  final formKey = GlobalKey<FormState>();

  RegisterForm(
      {required this.usernameController,
      required this.fullnameController,
      required this.emailController,
      required this.passwordController,
      required this.repeatPasswordController,
      Key? key})
      : super(key: key);

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  @visibleForTesting
  UserName? username;
  @visibleForTesting
  UserFullName? fullname;
  @visibleForTesting
  UserEmail? email;
  @visibleForTesting
  UserPassword? password;
  @visibleForTesting
  UserRepeatPassword? repeatPassword;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    username = UserName(appLocalizations, widget.usernameController.text);
    email = UserEmail(appLocalizations, widget.emailController.text);
    fullname = UserFullName(appLocalizations, widget.fullnameController.text);
    password = UserPassword(appLocalizations, widget.passwordController.text);
    repeatPassword = UserRepeatPassword(appLocalizations,
        widget.passwordController.text, widget.repeatPasswordController.text);
    final auth = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);
    final emailCode = ref.watch(emailCodeControllerProvider);
    final emailCodeController = ref.read(emailCodeControllerProvider.notifier);
    final isLoading = auth.maybeWhen(
          data: (_) => auth.isRefreshing,
          loading: () => true,
          orElse: () => false,
        ) ||
        emailCode.maybeWhen(
          data: (_) => auth.isRefreshing,
          loading: () => true,
          orElse: () => false,
        );
    widget.cache.value = SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              AppTextFormField(
                maxCharacters: 15,
                maxWidth: 400,
                title: appLocalizations.username,
                controller: widget.usernameController,
                onChanged: (value) =>
                    username = UserName(appLocalizations, value),
                validator: (value) => username?.validate,
              ),
              verticalSpace(),
              AppTextFormField(
                maxCharacters: 15,
                maxWidth: 400,
                title: appLocalizations.fullname,
                controller: widget.fullnameController,
                onChanged: (value) =>
                    fullname = UserFullName(appLocalizations, value),
                validator: (value) => fullname?.validate,
              ),
              verticalSpace(),
              AppTextFormField(
                title: appLocalizations.emailAddress,
                maxWidth: 400,
                maxCharacters: 300,
                controller: widget.emailController,
                onChanged: (value) =>
                    email = UserEmail(appLocalizations, value),
                validator: (value) => email?.validate,
              ),
              verticalSpace(),
              PasswordTextFormField(
                title: appLocalizations.password,
                maxWidth: 400,
                maxCharacters: 400,
                controller: widget.passwordController,
                onChanged: (value) =>
                    password = UserPassword(appLocalizations, value),
                validator: (value) => password?.validate,
              ),
              verticalSpace(),
              PasswordTextFormField(
                title: appLocalizations.repeatPassword,
                maxWidth: 400,
                maxCharacters: 400,
                controller: widget.repeatPasswordController,
                onChanged: (value) => repeatPassword = UserRepeatPassword(
                    appLocalizations, widget.passwordController.text, value),
                validator: (value) => repeatPassword?.validate,
              ),
              verticalSpace(),
              SizedBox(
                  height: 50,
                  width: 240,
                  child: AppTextButton(
                      enabled: !isLoading,
                      onPressed: () async {
                        if (widget.formKey.currentState == null ||
                            !widget.formKey.currentState!.validate()) {
                          return;
                        }
                        if (username == null) return;
                        if (fullname == null) return;
                        if (email == null) return;
                        if (password == null) return;
                        if (repeatPassword == null) return;
                        String lang = appLocalizations.localeName;
                        (await authController.createUser(
                                username!,
                                fullname!,
                                email!,
                                lang,
                                password!,
                                repeatPassword!,
                                appLocalizations))
                            .fold((failure) {
                          showErrorRegisterDialog(
                              appLocalizations, failure.detail);
                        }, (_) async {
                          bool sendCode =
                              await showCodeAdviceDialog(appLocalizations);
                          if (sendCode) {
                            (await emailCodeController.requestCode(
                                    email!, appLocalizations))
                                .fold((failure) {
                              showErrorEmailSendCodeDialog(
                                  appLocalizations, failure.detail);
                            }, (_) {
                              showCodeSendDialog(widget.emailController.text);
                            });
                          }
                        });
                      },
                      text: appLocalizations.register)),
            ],
          ),
        ),
      ),
    );
    return isLoading
        ? showLoading(background: widget.cache.value)
        : widget.cache.value;
  }
}
