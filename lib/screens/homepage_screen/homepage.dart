import 'package:flow/model/data.dart';
import 'package:flow/screens/homepage_screen/provider/provider.dart';
import 'package:flow/screens/homepage_screen/widgets/addressing_segment_future_builder.dart';
import 'package:flow/screens/homepage_screen/widgets/expenss_animated_container.dart';
import 'package:flow/screens/homepage_screen/widgets/expenss_shower_widget.dart';
import 'package:flow/services/database_servieces.dart';
import 'package:flow/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  final DatabaseService _databaseService = DatabaseService.instance;
  late final Future<List<Data>> _recentTransactionlist = _databaseService.getRecentTransactions();
  late final Future<List<Data>> _todaysTransactionlist = _databaseService.getTodayTransactions();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    final provider = context.read<TrendingPageProvider>();
    if (provider.currentPage != page) {
      provider.currentPage = page;
    }
  }
  
  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddressingSegmentFutureBuilder(databaseService: _databaseService),
              const SizedBox(height: 20),
              FutureBuilder<Map<String, double>>(
                future: _databaseService.getTodayAndMonthTotals(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Failed to load data');
                  } else {
                    final data = snapshot.data!;
                    return ExpenssShower(
                      todayCredited: data['todayCredited'] ?? 0.0,
                      thismonthCredited: data['monthCredited'] ?? 0.0,
                      todayDebited: data['todayDebited'] ?? 0.0,
                      thismonthDebited: data['monthDebited'] ?? 0.0,
                    );
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder<List<Data>>(
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
              ),
              SizedBox(
                height: 250,
                child: FutureBuilder<List<List<Data>>>(
                  future: Future.wait([
                    _todaysTransactionlist,
                    _recentTransactionlist,
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Failed to load transactions'));
                    } else {
                      final todayList = snapshot.data![0];
                      final recentList = snapshot.data![1];
        
                      // Use today's list if not empty, else fall back to recent list
                      final transactionList =
                          todayList.isNotEmpty ? todayList : recentList;
        
                      if (transactionList.isEmpty) {
                        return const Center(child: Text('No transactions available'));
                      }
                      return Consumer<TrendingPageProvider>(
                        builder: (context, provider, child) {
                          return PageView.builder(
                            itemCount: transactionList.length,
                            controller: _pageController,
                            onPageChanged: _onPageChanged,
                            itemBuilder: (context, index) =>
                               BuildAnimatedCard.buildAnimatedCard(index, provider.currentPage, transactionList[index], context),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              FutureBuilder<Map<DateTime, int>>(
                future: _databaseService.getCalendarDataset(), // The function we defined above
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator()); 
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return Text('No data available');
                  }
                  final calendarData = snapshot.data!;

                  return HeatMapCalendar(
                    defaultColor: Colors.white,
                    flexible: true,
                    colorMode: ColorMode.opacity,
                    datasets: calendarData,
                    colorsets: { 1: AppColors.lightred },
                    onClick: (date) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$date')),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}