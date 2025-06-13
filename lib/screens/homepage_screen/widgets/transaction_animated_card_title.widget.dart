
import 'package:flow/model/data.dart';
import 'package:flutter/material.dart';

class TransactionAnimatedCardTitle extends StatelessWidget {
  const TransactionAnimatedCardTitle({
    super.key,
    required Future<List<Data>> todaysTransactionlist,
  }) : _todaysTransactionlist = todaysTransactionlist;

  final Future<List<Data>> _todaysTransactionlist;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Data>>(
      future: _todaysTransactionlist,
      builder: (context, snapshot) {
        String title = "Today's flow";
        if (snapshot.connectionState == ConnectionState.done &&
            (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty)) {
          title = "Recent flow";
        }
        return Text(
          title,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        );
      },
    );
  }
}
