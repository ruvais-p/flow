import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  static TextTheme lighTextTheme = TextTheme(
    headlineLarge: GoogleFonts.poppins(
      fontSize: 33,
      fontWeight: FontWeight.w600,
      color: AppColors.blackcolor,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    displayLarge: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 15,
      fontWeight: FontWeight.w600
    ),
    labelMedium: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600
    )
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: GoogleFonts.poppins(
      fontSize: 33,
      fontWeight: FontWeight.w600,
      color: AppColors.whitecolor,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    displayLarge: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 15,
      fontWeight: FontWeight.w600
    ),
    labelMedium: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600
    )
  );
}