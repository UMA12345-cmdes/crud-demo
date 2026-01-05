import 'package:crud_demo/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';


class CommonToast {
  static commonToast({
    required String text,
    required BuildContext context,
  }) {
    showTopSnackBar(
      Overlay.of(context),
      displayDuration: const Duration(seconds: 1),
      reverseAnimationDuration: const Duration(milliseconds: 500),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: blackColor,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: whiteColor,
            decoration: TextDecoration.none,
            decorationColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
