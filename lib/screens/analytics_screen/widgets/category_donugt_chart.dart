import 'package:flow/common/donugt_chart.dart';
import 'package:flow/model/chart.dart';
import 'package:flow/screens/analytics_screen/services/analystic_db_services.dart';
import 'package:flow/screens/analytics_screen/widgets/chart_title_widget.dart';
import 'package:flutter/material.dart';

class YearlyCategoryChartSection extends StatefulWidget {
  final int year;
  const YearlyCategoryChartSection({super.key, required this.year});

  @override
  State<YearlyCategoryChartSection> createState() => _YearlyCategoryChartSectionState();
}

class _YearlyCategoryChartSectionState extends State<YearlyCategoryChartSection> {
  List<ChartData> _creditData = [];
  List<ChartData> _debitData = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final credit = await AnalysticDbServices.instance.fetchCategoryCreditDebitByYear(widget.year, 'CREDIT');
    final debit = await AnalysticDbServices.instance.fetchCategoryCreditDebitByYear(widget.year, 'DEBIT');

    setState(() {
      _creditData = credit;
      _debitData = debit;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ChartTitleWidget(context, "${widget.year} - Credit by Category"),
        const SizedBox(height: 12),
        BasicChartUnit(dataSet: _creditData),
        const SizedBox(height: 24),
        ChartTitleWidget(context, "${widget.year} - Debit by Category"),
        const SizedBox(height: 12),
        BasicChartUnit(dataSet: _debitData),
      ],
    );
  }
}
