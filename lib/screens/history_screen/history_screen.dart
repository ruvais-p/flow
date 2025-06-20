
import 'package:flow/screens/history_screen/functions/month_list_function.dart';
import 'package:flow/screens/history_screen/provider/history_provider.dart';
import 'package:flow/screens/history_screen/widgets/date_controller_widget.dart';
import 'package:flow/screens/history_screen/widgets/donugt_chart_widget.dart';
import 'package:flow/screens/history_screen/widgets/history_appbar_widget.dart';
import 'package:flow/screens/history_screen/widgets/option_selector_widget.dart';
import 'package:flow/screens/history_screen/widgets/transaction_list_builder_widget.dart';
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

    final List<String> titles = ["Transactions", "Categories"];
    final List<Widget> widgets = [ TransactionListBuilder(provider: provider), PieChartSection()];
    final chartProvider = context.watch<HistoryDataProvider>();
    final selectedChartIndex = chartProvider.selectedIndex;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
            OptionSelectorWidget(titles: titles, selectedChartIndex: selectedChartIndex),
            const SizedBox(height: 10),
            widgets[selectedChartIndex],
          ],
        ),
      ),
    );
  }
}
