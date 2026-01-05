import 'package:crud_demo/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({super.key, this.onPressed, required this.text});
  final void Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(double.infinity, 48)),
        backgroundColor: WidgetStatePropertyAll(primaryColor),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(fontSize: 16, color: blackColor, letterSpacing: 0.3),),
    );
  }
}
