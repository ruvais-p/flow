
import 'package:flow/screens/history_screen/provider/history_provider.dart';
import 'package:flow/screens/history_screen/widgets/expenss_shower_container_widget.dart';
import 'package:flutter/material.dart';

class TransactionListBuilder extends StatelessWidget {
  const TransactionListBuilder({
    super.key,
    required this.provider,
  });

  final HistoryDataProvider provider;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: provider.monthlyTransactions.isEmpty
          ? Center(child: Text("No transactions found...", style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            color: Theme.of(context).colorScheme.secondary
          ),
          textAlign: TextAlign.center,
          ))
          : SingleChildScrollView(
              child: Column(
                children: provider.monthlyTransactions
                    .map((e) =>
                        ExpenssShowerContainerWidget(data: e))
                    .toList(),
              ),
            ),
    );
  }
}
