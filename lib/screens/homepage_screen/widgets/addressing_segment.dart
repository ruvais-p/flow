
import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';

class AddressingSegment extends StatelessWidget {
  const AddressingSegment({
    super.key, required this.name,
  });
  final String name;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width ;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Hi...\n$name",
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            color: Theme.of(context).colorScheme.secondary
          ),
        ),
        Column(
          children: [
            CircleAvatar(
              radius: width * 0.060679 ,
              backgroundColor: AppColors.lightred,
              child: IconButton(onPressed: (){}, icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.secondary,)),
            ),
            SizedBox(
              height: 10,
            ),
            CircleAvatar(
              radius: width * 0.060679 ,
              backgroundColor: AppColors.darkgray,
              child: IconButton(onPressed: (){}, icon: Icon(Icons.add, color: Theme.of(context).colorScheme.secondary,)),
            )
          ],
        )
      ],
    );
  }
}