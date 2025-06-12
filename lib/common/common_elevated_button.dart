import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';

class CommonElevatedButton extends StatelessWidget {
  const CommonElevatedButton({
    super.key, required this.onPressed,
  });
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container( height: 50,
        alignment: Alignment.center,
       decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppColors.lightred,
      
      ),
        child: Text("Next", style: Theme.of(context).textTheme.displayMedium!.copyWith(
          color: AppColors.whitecolor
        )),
      ),
    );
  }
}