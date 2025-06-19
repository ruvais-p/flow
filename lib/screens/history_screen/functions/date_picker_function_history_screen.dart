import 'package:flow/screens/history_screen/provider/history_provider.dart';
import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> pickDate(BuildContext context) async {
  final provider = Provider.of<HistoryProvider>(context, listen: false);

  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: provider.selectedDate ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
    barrierColor: AppColors.darkgray,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.lightred, // Header background color
            onPrimary: Colors.white, // Header text color
            onSurface: AppColors.blackcolor  // Body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.lightred, // Button text color
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null && picked != provider.selectedDate) {
    provider.setDate(picked);
  }
}
