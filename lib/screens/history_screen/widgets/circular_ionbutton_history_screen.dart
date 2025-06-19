import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color background;

  const CircleIconButton({
    required this.icon,
    required this.onTap,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Positioned(
              top: 2,
              left: 2,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.lightred,
              ),
            ),
            CircleAvatar(
              radius: 20,
              backgroundColor: background,
              child: Icon(
                icon,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
