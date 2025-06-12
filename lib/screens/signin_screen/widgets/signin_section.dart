
import 'package:flow/theme/colors.dart';
import 'package:flow/theme/strings.dart';
import 'package:flutter/material.dart';

class SigninSection extends StatelessWidget {
  final TextEditingController controller;

  const SigninSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.284,
          decoration: BoxDecoration(
            color: AppColors.lightred,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(80)),
          ),
          alignment: Alignment.center,
          child: Text(
            signin_page_headline,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: AppColors.whitecolor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.darkgray,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: controller,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.whitecolor,
            ),
            decoration: InputDecoration(
              hintText: "Name",
              hintStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.whitecolor,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        )
      ],
    );
  }
}
