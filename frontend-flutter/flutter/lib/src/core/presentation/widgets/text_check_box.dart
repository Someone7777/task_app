import 'package:flutter/material.dart';

class TextCheckBox extends StatefulWidget {
  final String title;
  final Color? fillColor;
  final Function(bool?)? onChanged;
  final isCheckedState = ValueNotifier<bool>(false);

  TextCheckBox(
      {required this.title,
      this.onChanged,
      this.fillColor,
      isChecked = false,
      Key? key})
      : super(key: key) {
    isCheckedState.value = isChecked;
  }

  @override
  State<TextCheckBox> createState() => _TextCheckBoxState();
}

class _TextCheckBoxState extends State<TextCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          checkBox(widget.fillColor),
          TextButton(
            onPressed: () {
              setState(() {
                widget.isCheckedState.value = !widget.isCheckedState.value;
                if (widget.onChanged != null) {
                  widget.onChanged!(widget.isCheckedState.value);
                }
              });
            },
            child: Text(
              widget.title,
              style: TextStyle(color: widget.fillColor, fontSize: 14),
            ),
          )
        ],
      ),
    );
  }

  @visibleForTesting
  Widget checkBox(Color? fillColor) {
    return Checkbox(
      fillColor: MaterialStateProperty.resolveWith((_) => fillColor),
      value: widget.isCheckedState.value,
      onChanged: (bool? value) {
        setState(() {
          widget.isCheckedState.value = value!;
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        });
      },
    );
  }
}
