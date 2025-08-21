import 'package:flutter/material.dart';
import 'package:rasa/core/theme/color_app.dart';

class FilledButtonItem extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  const FilledButtonItem({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 39,
      child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(mainColor),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)))),
          child: Center(
            child: Text(
              title,
              style: whiteTextStyle.copyWith(fontSize: 14, fontWeight: bold),
            ),
          )),
    );
  }
}

class OutlineButtonItem extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  const OutlineButtonItem({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 39,
      child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
            side: WidgetStateProperty.all(
              BorderSide(color: mainColor, width: 3),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style:
                  mainColorTextStyle.copyWith(fontSize: 14, fontWeight: bold),
            ),
          )),
    );
  }
}
