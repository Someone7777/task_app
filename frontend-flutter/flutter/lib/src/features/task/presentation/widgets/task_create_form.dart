import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_app/config/router.dart';
import 'package:task_app/src/core/presentation/widgets/app_text_button.dart';
import 'package:task_app/src/core/presentation/widgets/app_text_form_field.dart';
import 'package:task_app/src/core/presentation/widgets/error_dialog.dart';
import 'package:task_app/src/core/providers.dart';
import 'package:task_app/src/core/utils/widget_utils.dart';
import 'package:task_app/src/features/home/presentation/views/home_view.dart';
import 'package:task_app/src/features/task/domain/values/task_description_value.dart';
import 'package:task_app/src/features/task/domain/values/task_title_value.dart';
import 'package:task_app/src/features/task/providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskCreateForm extends ConsumerStatefulWidget {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final finishedDateController = TextEditingController();
  final deadlineDateontroller = TextEditingController();

  final dateFormatter = DateFormat("dd/MM/yyyy");

  final cache = ValueNotifier<Widget>(Container());

  TaskCreateForm({
    super.key,
  });

  @override
  ConsumerState<TaskCreateForm> createState() => _TaskCreateFormState();
}

class _TaskCreateFormState extends ConsumerState<TaskCreateForm> {
  TaskTitleValue? title;
  TaskDescriptionValue? description;
  DateTime? finishedDate;
  DateTime? deadlineDate;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    title = TaskTitleValue(appLocalizations, widget.nameController.text);
    description = TaskDescriptionValue(
        appLocalizations, widget.descriptionController.text);
    if (widget.finishedDateController.text.isEmpty) {
      widget.finishedDateController.text =
          widget.dateFormatter.format(DateTime.now());
    }
    finishedDate = DateTime.now();
    if (widget.deadlineDateontroller.text.isEmpty) {
      widget.deadlineDateontroller.text =
          widget.dateFormatter.format(DateTime.now());
    }
    deadlineDate = DateTime.now();

    final taskCreateController =
        ref.read(taskCreateControllerProvider.notifier);
    final taskListController = ref.read(taskListControllerProvider.notifier);

    final taskCreateState = ref.watch(taskCreateControllerProvider);

    return taskCreateState.when(data: (_) {
      widget.cache.value = SingleChildScrollView(
        child: Form(
          key: widget.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                verticalSpace(),
                AppTextFormField(
                  onChanged: (value) =>
                      title = TaskTitleValue(appLocalizations, value),
                  title: appLocalizations.taskTitle,
                  validator: (value) => title?.validate,
                  maxCharacters: 40,
                  maxWidth: 500,
                  controller: widget.nameController,
                ),
                verticalSpace(),
                AppTextFormField(
                  onChanged: (value) => description =
                      TaskDescriptionValue(appLocalizations, value),
                  title: appLocalizations.taskDescription,
                  validator: (value) => description?.validate,
                  maxCharacters: 2000,
                  maxWidth: 500,
                  maxHeight: 400,
                  maxLines: 7,
                  multiLine: true,
                  showCounterText: true,
                  controller: widget.descriptionController,
                ),
                verticalSpace(),
                AppTextFormField(
                    onTap: () async {
                      // Below line stops keyboard from appearing
                      FocusScope.of(context).requestFocus(FocusNode());
                      // Show Date Picker Here
                      DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now());
                      if (newDate != null) {
                        finishedDate = newDate;
                        widget.finishedDateController.text =
                            widget.dateFormatter.format(newDate);
                      }
                    },
                    textAlign: TextAlign.center,
                    controller: widget.finishedDateController,
                    title: appLocalizations.taskFinishedDate,
                    maxWidth: 200),
                verticalSpace(),
                AppTextFormField(
                    onTap: () async {
                      // Below line stops keyboard from appearing
                      FocusScope.of(context).requestFocus(FocusNode());
                      // Show Date Picker Here
                      DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now());
                      if (newDate != null) {
                        deadlineDate = newDate;
                        widget.deadlineDateontroller.text =
                            widget.dateFormatter.format(newDate);
                      }
                    },
                    textAlign: TextAlign.center,
                    controller: widget.deadlineDateontroller,
                    title: appLocalizations.taskDeadlineDate,
                    maxWidth: 200),
                verticalSpace(),
                AppTextButton(
                  width: 140,
                  height: 50,
                  onPressed: () async {
                    if (widget.formKey.currentState == null ||
                        !widget.formKey.currentState!.validate()) {
                      return;
                    }
                    if (title == null) return;
                    if (description == null) return;
                    if (finishedDate == null) return;
                    if (deadlineDate == null) return;
                    (await taskCreateController.handle(title!, description!,
                            finishedDate!, deadlineDate!, appLocalizations))
                        .fold((failure) {
                      showErrorTaskCreationDialog(
                          appLocalizations, failure.detail);
                    }, (entity) {
                      router.go("/${HomeView.routePath}");
                      taskListController.add(entity);
                    });
                  },
                  text: appLocalizations.create,
                ),
              ],
            ),
          ),
        ),
      );
      return widget.cache.value;
    }, error: (error, _) {
      return showError(error: error, background: widget.cache.value);
    }, loading: () {
      return showLoading(background: widget.cache.value);
    });
  }

  Future<void> showErrorTaskCreationDialog(
      AppLocalizations appLocalizations, String error) async {
    await showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => ErrorDialog(
              dialogTitle: appLocalizations.taskCreateDialogTitle,
              dialogDescription: error,
              cancelText: appLocalizations.cancel,
            ));
  }
}
