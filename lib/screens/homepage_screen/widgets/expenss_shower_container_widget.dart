

import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';

class ExpenssShowerContainer extends StatelessWidget {
  const ExpenssShowerContainer({
    super.key, required this.isCreated, required this.heading, required this.amount,
  });
  final bool isCreated;
  final String heading;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width ;
    final height = MediaQuery.of(context).size.height ;
    return Container(
      width: width * 0.3883,
      height: height * 0.0896,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isCreated ? AppColors.darkred : AppColors.lightgray,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary,    
          )
        ]
      ),
      child: Stack(
        children: [
          Positioned(
          top: 0,
          left: 0,
          child: Text(
            heading,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: isCreated ? AppColors.whitecolor : AppColors.blackcolor
            ),
          ),
          ),
          Positioned(
          bottom: 0,
          right: 0,
          child: Text(
            "₹$amount",
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
              color: isCreated ? AppColors.whitecolor : AppColors.blackcolor
            ),
          ),
          )
        ],
      )
    );
  }
}
