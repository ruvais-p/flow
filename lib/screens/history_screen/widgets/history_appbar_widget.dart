import 'package:flutter/material.dart';
import 'package:flow/screens/history_screen/widgets/circular_ionbutton_history_screen.dart';

class HistoryAppBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onCalendar;

  const HistoryAppBar({
    super.key,
    required this.onBack,
    required this.onCalendar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button
        CircleIconButton(
          icon: Icons.arrow_back,
          onTap: onBack,
          color: Theme.of(context).colorScheme.primary,
          background: Theme.of(context).colorScheme.secondary,
        ),

        // Calendar Button
        CircleIconButton(
          icon: Icons.calendar_month,
          onTap: onCalendar,
          color: Theme.of(context).colorScheme.primary,
          background: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }
}
