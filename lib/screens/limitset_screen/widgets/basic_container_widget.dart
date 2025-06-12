
import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';

class BasicWidget extends StatelessWidget {
  const BasicWidget({
    super.key, required this.isInvert, required this.controller, required this.heading, required this.hinttext
  });
  final bool isInvert;
  final TextEditingController controller;
  final String heading;
  final String hinttext;


  @override
  Widget build(BuildContext context) {
      double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height * 0.280, // 👈 Give Stack a fixed height
      child: Stack(
        children: [
          Positioned(
            top: width * 0.12136,
            left: width * 0.0485,
            child: Container(
              width:  width * 0.9,
              height: height * 0.185,
              padding: EdgeInsets.all(8),
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(
                color: isInvert ? AppColors.darkgray : AppColors.lightred,
                borderRadius: BorderRadius.circular(20)
              ),
              child:  Align(
  alignment: Alignment.bottomRight,
  child: SizedBox(
    width: width * 0.3, // Or any suitable fixed width
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "₹",
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
            color: AppColors.whitecolor
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.whitecolor,
            ),
            decoration: InputDecoration(
              hintText: hinttext,
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
        ),
      ],
    ),
  ),
),

            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width:  width * 0.9,
              height: height * 0.185,
              padding: EdgeInsets.symmetric(horizontal: 30),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: isInvert ? AppColors.lightred : AppColors.darkgray,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Text(heading, style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: AppColors.whitecolor
              ),),
            ),
          ),
          
        ],
      ),
    );
  }
}
