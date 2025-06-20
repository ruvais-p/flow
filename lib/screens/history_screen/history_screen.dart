
import 'package:flow/screens/history_screen/functions/month_list_function.dart';
import 'package:flow/screens/history_screen/provider/history_provider.dart';
import 'package:flow/screens/history_screen/widgets/date_controller_widget.dart';
import 'package:flow/screens/history_screen/widgets/expenss_shower_container_widget.dart';
import 'package:flow/screens/history_screen/widgets/history_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      Provider.of<HistoryDataProvider>(context, listen: false)
          .loadTransactionsForSelectedMonth();
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryDataProvider>();
    final selectedDate = provider.selectedDate;
    final formattedMonthYear =
        "${monthName(selectedDate.month)} ${selectedDate.year}";

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            HistoryAppBar(onBack: () => Navigator.pop(context)),
            const SizedBox(height: 20),
            DateControllerWidget(
              dateTitle: formattedMonthYear,
              debitedAmount: provider.totalDebited,
              creditedAmount: provider.totalCredited,
              leftButton: () => provider.goToPreviousMonth(),
              rightButton: () => provider.goToNextMonth(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: provider.monthlyTransactions.isEmpty
                  ? const Center(child: Text("No transactions found"))
                  : SingleChildScrollView(
                      child: Column(
                        children: provider.monthlyTransactions
                            .map((e) =>
                                ExpenssShowerContainerWidget(data: e))
                            .toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
