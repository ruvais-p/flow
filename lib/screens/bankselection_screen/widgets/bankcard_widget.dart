import 'package:flutter/material.dart';
import 'package:flow/theme/colors.dart';

class BankCards extends StatelessWidget {
  const BankCards({
    super.key,
    required this.currentIndex,
    required this.smallContainerWidth,
    required this.smallContainerHeight,
    required this.banks,
    required this.largeContainerWidth,
    required this.largeContainerHeight,
  });

  final int currentIndex;
  final double smallContainerWidth;
  final double smallContainerHeight;
  final List<String> banks;
  final double largeContainerWidth;
  final double largeContainerHeight;

  Widget _buildCard(BuildContext context, String text, double width, double height, Color color, TextStyle style) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        currentIndex == 0
            ? SizedBox(width: smallContainerWidth, height: smallContainerHeight)
            : _buildCard(
                context,
                banks[currentIndex - 1],
                smallContainerWidth,
                smallContainerHeight,
                AppColors.lightgray,
                Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
        Container(
          width: largeContainerWidth,
          height: largeContainerHeight,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.darkgray,
          ),
          alignment: Alignment.center,
          child: Text(
            banks[currentIndex],
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        currentIndex == banks.length - 1
            ? SizedBox(width: smallContainerWidth, height: smallContainerHeight)
            : _buildCard(
                context,
                banks[currentIndex + 1],
                smallContainerWidth,
                smallContainerHeight,
                AppColors.lightgray,
                Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
      ],
    );
  }
}
