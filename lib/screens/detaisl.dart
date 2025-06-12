import 'package:flow/model/data.dart';
import 'package:flow/services/database_servieces.dart';
import 'package:flutter/material.dart';

class Detaisl extends StatefulWidget {
  const Detaisl({super.key});

  @override
  State<Detaisl> createState() => _DetaislState();
}

class _DetaislState extends State<Detaisl> {
  final DatabaseService _databaseService = DatabaseService.instance;
  late final Future<List<Data>> _data = _databaseService.getTasks();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Details')),
      body: FutureBuilder<List<Data>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found.'));
          }

          final dataList = snapshot.data!;

          return ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final data = dataList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${data.date}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Time: ${data.time}'),
                      Text('Message: ${data.message}'),
                      Text('Amount: ${data.amount?.toStringAsFixed(2) ?? '0.00'}'),
                      Text('Balance: ${data.balance?.toStringAsFixed(2) ?? '0.00'}'),
                      Text('Consumer: ${data.consumer}'),
                      Text('Category: ${data.category}'),
                      Text('UPI ID: ${data.upiid}'),
                      Text('Type: ${data.transactionType}'),
                      Text('Bank: ${data.bank}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
