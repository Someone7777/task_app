import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:task_app/config/theme.dart';
import 'package:task_app/src/core/presentation/states/app_localization_state.dart';
import 'package:task_app/src/core/presentation/states/theme_data_state.dart';
import 'package:universal_io/io.dart';

///
/// Presentation dependencies
///

final themeDataProvider =
    StateNotifierProvider<ThemeDataState, ThemeData>((ref) {
  final theme =
      (SchedulerBinding.instance.window.platformBrightness == Brightness.light)
          ? AppTheme.lightTheme
          : AppTheme.darkTheme;
  return ThemeDataState(theme);
});

final appLocalizationsProvider =
    StateNotifierProvider<AppLocalizationsState, AppLocalizations>((ref) {
  Locale locale = Locale(Platform.localeName.substring(0, 2));
  // If system's locale is not supported, Enlish will be used as default
  if (!AppLocalizations.supportedLocales.contains(locale)) {
    locale = const Locale("en");
  }
  return AppLocalizationsState(lookupAppLocalizations(locale));
});
