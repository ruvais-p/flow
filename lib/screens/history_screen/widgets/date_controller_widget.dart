
import 'package:decimal/decimal.dart';
import 'package:flow/screens/history_screen/widgets/circular_ionbutton_history_screen.dart';
import 'package:flow/screens/homepage_screen/widgets/expenss_shower_container_widget.dart';
import 'package:flutter/material.dart';

class DateControllerWidget extends StatelessWidget {
  const DateControllerWidget({
    super.key, required this.creditedAmount, required this.debitedAmount, required this.dateTitle, required this.leftButton, required this.rightButton,
  });
  final Decimal creditedAmount;
  final Decimal debitedAmount;
  final String dateTitle;
  final VoidCallback leftButton;
  final VoidCallback rightButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleIconButton(
              icon: Icons.arrow_back_ios,
              onTap: leftButton,
              color: Theme.of(context).colorScheme.primary,
              background: Theme.of(context).colorScheme.secondary,
            ),
                    Text(dateTitle, style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: dateTitle.length >= 12 ? 25 : 28
                    ),),
                     CircleIconButton(
              icon: Icons.arrow_forward_ios,
              onTap:rightButton,
              color: Theme.of(context).colorScheme.primary,
              background: Theme.of(context).colorScheme.secondary,
            ),
                  ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ExpenssShowerContainer(isCreated: true, heading: "Debited", amount: double.parse(debitedAmount.toString())),
            ExpenssShowerContainer(isCreated: false, heading: "Credited", amount: double.parse(creditedAmount.toString())),
          ],
        )
      ],
    );
  }
}