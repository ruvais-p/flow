
import 'package:flow/theme/colors.dart';
import 'package:flow/theme/strings.dart';
import 'package:flutter/material.dart';

class HeadlineSection extends StatelessWidget {
  const HeadlineSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
    height: MediaQuery.of(context).size.height * 0.284,
    decoration: BoxDecoration(
      color: AppColors.lightred,
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80)),
    ),
    alignment: Alignment.center,
    child: Text(
      bank_selection_headline,
      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
        color: AppColors.whitecolor,
      ),
      textAlign: TextAlign.center,
    ),
            );
  }
}