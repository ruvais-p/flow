import 'package:another_flushbar/flushbar.dart';
import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';

void showAppSnackBar(BuildContext context, String message) {
  Flushbar(
    messageText: Text(
      message,
      style: Theme.of(context).textTheme.displayMedium!.copyWith(
            color: AppColors.whitecolor,
          ),
    ),
    backgroundColor: AppColors.darkred,
    borderRadius: BorderRadius.circular(12),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    duration: const Duration(seconds: 2),
    flushbarPosition: FlushbarPosition.BOTTOM,
    animationDuration: const Duration(milliseconds: 1000),
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInOutBack,
  ).show(context);
}
