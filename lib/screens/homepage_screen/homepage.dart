import 'package:flow/model/data.dart';
import 'package:flow/model/regex_models/south_indian_bank.dart';
import 'package:flow/screens/homepage_screen/provider/provider.dart';
import 'package:flow/screens/homepage_screen/widgets/addressing_segment_future_builder.dart';
import 'package:flow/screens/homepage_screen/widgets/chart_widget.dart';
import 'package:flow/screens/homepage_screen/widgets/expenss_animated_container.dart';
import 'package:flow/screens/homepage_screen/widgets/expenss_showing_widget.dart';
import 'package:flow/screens/homepage_screen/widgets/heat_map_widget.dart';
import 'package:flow/services/database_servieces.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  final DatabaseService _databaseService = DatabaseService.instance;
  static const platform = MethodChannel('uniqueChannel');
  
  List<Map<String, dynamic>> _smsMessages = [];
  bool _isLoading = true;
  String? _error;
  late Future<List<List<Data>>> _initializeData;
  
  @override
  void initState() {
    super.initState();
    _initializeData = initializeHomeData();
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

  Future<List<List<Data>>> initializeHomeData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      await fetchSmsMessages(); // Await full insert
      final recent = await _databaseService.getRecentTransactions();
      final today = await _databaseService.getTodayTransactions();
      
      setState(() {
        _isLoading = false;
      });
      
      return [today, recent]; // Return both lists
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
      rethrow;
    }
  }

  Future<void> fetchSmsMessages() async {
    try {
      final filterString = await _databaseService.getBankCode();
      final DateTime? afterDate = await _databaseService.getLatestDateTime();

      final List<dynamic> result = await platform.invokeMethod(
        'getAllSMS',
        {
          'filter': filterString ?? '',
          'date': afterDate?.millisecondsSinceEpoch.toString(),
        },
      );

      _smsMessages = result.cast<Map<dynamic, dynamic>>().map(
        (e) => e.map((k, v) => MapEntry(k.toString(), v)),
      ).toList();

      await parseAndInsertMessages(); // Await insert
    } on PlatformException catch (e) {
      setState(() {
        _error = "Platform Error: ${e.message}";
      });
      rethrow; // Re-throw to handle in initializeHomeData
    } catch (e) {
      setState(() {
        _error = "Error fetching SMS: $e";
      });
      rethrow;
    }
  }

  Future<void> parseAndInsertMessages() async {
    try {
      for (var msg in _smsMessages) {
        final body = msg['body'];
        final timestamp = msg['date'];

        if (body != null && timestamp != null) {
          final parsedData = parseSouthIndianBankSms(
            body, 
            DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp.toString()))
          );
          
          if (parsedData != null) {
            await _databaseService.insertTransaction(
              message: body,
              amount: parsedData['amount'],
              balance: parsedData['balance'],
              date: parsedData['date'],
              time: parsedData['time'],
              consumer: parsedData['consumer'],
              transactionType: parsedData['mode'],
              category: parsedData['category'],
              upiid: parsedData['upiid'] ?? '',
              bank: "SIB"
            );
          }
        }
      }
    } catch (e) {
      setState(() {
        _error = "Error parsing messages: $e";
      });
      rethrow;
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
              ExpenssShowingWidget(databaseService: _databaseService),
              const SizedBox(height: 10),
              SizedBox(
                height: 280, // Fixed height to contain both title and PageView
                child: FutureBuilder<List<List<Data>>>(
                  future: _initializeData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Failed to load transactions'),
                            if (_error != null) 
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _error!,
                                  style: const TextStyle(color: Colors.red, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _initializeData = initializeHomeData();
                                });
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      final todayList = snapshot.data![0];
                      final recentList = snapshot.data![1];
                
                      final transactionList = todayList.length < 5 ? recentList : todayList;
                      final title = todayList.length < 5 ? "Recent flows" : "Today's flow";
                      
                      if (transactionList.isEmpty) {
                        return const Center(child: Text('No transactions available'));
                      }
                
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title section
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              title,
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                            ),
                          ),
                          // PageView section with fixed height
                          Expanded(
                            child: Consumer<TrendingPageProvider>(
                              builder: (context, provider, child) {
                                return PageView.builder(
                                  itemCount: transactionList.length,
                                  controller: _pageController,
                                  onPageChanged: _onPageChanged,
                                  itemBuilder: (context, index) =>
                                      BuildAnimatedCard.buildAnimatedCard(
                                        index, 
                                        provider.currentPage, 
                                        transactionList[index], 
                                        context
                                      ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              HeatMapWidget(databaseService: _databaseService),
              ChartWidget(),
            ],
          ),
        ),
      ),
    );
  }
}