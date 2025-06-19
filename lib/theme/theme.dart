import 'package:flow/theme/colors.dart';
import 'package:flow/theme/texttheme.dart';
import 'package:flutter/material.dart';

class Apptheme {

  static ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      surface: AppColors.lightbackgroung, 
      primary: AppColors.whitecolor,
      secondary: AppColors.blackcolor,
    ),
    textTheme: AppTextTheme.lighTextTheme,
    scaffoldBackgroundColor: AppColors.lightbackgroung,
    
  );

  static ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: AppColors.darkbackground, 
      primary: AppColors.blackcolor,
      secondary: AppColors.whitecolor,
    ),
    textTheme: AppTextTheme.darkTextTheme,
    scaffoldBackgroundColor: AppColors.darkbackground, 
  );
}