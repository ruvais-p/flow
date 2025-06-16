import 'package:flow/model/data.dart';
import 'package:flow/model/weekexpenss.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();
  static Database? _db;

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'transaction_data.db');

  return await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      // 1. user_details table
        // Drop if exists
      await db.execute('''
        CREATE TABLE user_details (
          username TEXT DEFAULT 'user',
          status INTEGER DEFAULT 0,
          initiated INTEGER DEFAULT 0,
          daily_limit INTEGER DEFAULT 100,
          monthly_limit INTEGER DEFAULT 3000
        );
      ''');

      // ✅ Insert default user row
      await db.insert('user_details', {
        'username': 'user',
        'status': 0,
        'initiated': 0,
        'daily_limit': 100,
        'monthly_limit': 3000
      });

      // 2. bank table
      await db.execute('''
        CREATE TABLE bank (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          bank_name TEXT NOT NULL,
          bank_code TEXT NOT NULL
        )
      ''');

      // 3. data table (will also be recreated on every open)
      await db.execute('''
        CREATE TABLE data (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          upiid TEXT UNIQUE,
          date DATE,
          time TIME,
          message TEXT NOT NULL,
          amount REAL,
          balance REAL,
          consumer TEXT,
          category TEXT,
          transaction_type TEXT,
          bank TEXT,
          callname TEXT
        )
      ''');

      await db.execute('''
        CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_transaction
        ON data(upiid, amount, date)
      ''');

      // 4. total table
      await db.execute('''
        CREATE TABLE total (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          debited REAL DEFAULT 0,
          credited REAL DEFAULT 0
        )
      ''');
    },
  );
}

  //get user status
  Future<int?> getUserStatus() async {
    final db = await database;

    final result = await db.query(
      'user_details',
      columns: ['status'],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['status'] as int;
    } else {
      return null; 
    }
  }
   Future<int?> getInitiatedrStatus() async {
    final db = await database;

    final result = await db.query(
      'user_details',
      columns: ['initiated'],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['initiated'] as int;
    } else {
      return null; 
    }
  }

  //add user details
  Future<void> addUserData(String name) async {
  final db = await database;

  final result = await db.query(
    'user_details',
    where: 'username = ?',
    whereArgs: ['user'], // Our single-row key
  );

  if (result.isEmpty) {
    // Insert default row if not exists
    await db.insert('user_details', {
      'username': 'user',
      'status': 0,
      'initiated': 0,
      'daily_limit': 100,
      'monthly_limit': 3000
    });
  }

  // Update only the name now
  await db.update(
    'user_details',
    {'username': name},
    where: 'username = ?',
    whereArgs: ['user'],
  );
}

Future<void> addUserLimit(int daily, int monthly) async {
  final db = await database;

  // Fetch the current row (only one expected)
  final result = await db.query('user_details', limit: 1);

  if (result.isEmpty) {
    // Insert the first row (could take a name input elsewhere)
    await db.insert('user_details', {
      'username': 'default_user', // Or get from an input field
      'status': 0,
      'initiated': 1,
      'daily_limit': daily,
      'monthly_limit': monthly
    });
  } else {
    // Get the existing username from the row
    String username = result.first['username'] as String;

    // Then update using that username
    await db.update(
      'user_details',
      {
        'daily_limit': daily,
        'monthly_limit': monthly,
        'initiated': 1,
      },
      where: 'username = ?',
      whereArgs: [username],
    );
  }
}



  Future<void> addUserBankData( String bankname, String bankCode) async {
    final db = await database;
    await db.insert('bank', {'bank_name': bankname, 'bank_code': bankCode});
    await db.update('user_details', {'status': 1});
  }

  //get UserName
  Future<String?> getUserName() async {
    final db = await database;
    final result = await db.query('user_details', limit: 1);
    if (result.isNotEmpty) {
      return result.first['username'] as String;
    } else {
      return null;
    }
  }

  //get Bank code
  Future<String?> getBankCode() async {
    final db = await database;
    final result = await db.query('bank', limit: 1 );
    if(result.isNotEmpty){
      return result.first['bank_code'] as String;
    }else{
      return null;
    }
  }

  Future<List<Data>> getTasks() async {
  final db = await database;
  final result = await db.query('data');
  return result.map((e) => Data(
    date: e['date'] as String? ?? '',
    time: e['time'] as String? ?? '',
    message: e['message'] as String? ?? '',
    amount: (e['amount'] is num) ? (e['amount'] as num).toDouble() : null,
    balance: (e['balance'] is num) ? (e['balance'] as num).toDouble() : null,
    consumer: e['consumer'] as String? ?? '',
    category: e['category'] as String? ?? '',
    upiid: e['upiid'] as String? ?? '',
    transactionType: e['transaction_type'] as String? ?? '',
    bank: e['bank'] as String? ?? '',
    callname: e['callname'] as String? ?? '', // <-- added
  )).toList();
}



  Future<void> insertTransaction({
  required String message,
  double? amount,
  double? balance,
  String? date,
  String? time,
  String? consumer,
  String? category,
  required String upiid,
  String? transactionType,
  String? bank,
  String? callname, // <-- added
}) async {
  final db = await database;

  // Check if a transaction with this UPI ID already exists
  final existingRows = await db.query(
    'data',
    where: 'upiid = ?',
    whereArgs: [upiid],
    limit: 1,
  );

  if (existingRows.isNotEmpty) {
    final existing = existingRows.first;

    // Prepare a map of fields to update if they are null or empty in the DB
    Map<String, dynamic> updateFields = {};

    void tryUpdate(String key, dynamic value) {
      final current = existing[key];
      final isCurrentEmpty = current == null || current == '' || current == 0;
      final isValueValid = value != null && value.toString().isNotEmpty;
      if (isCurrentEmpty && isValueValid) {
        updateFields[key] = value;
      }
    }

    tryUpdate('message', message);
    tryUpdate('amount', amount);
    tryUpdate('balance', balance);
    tryUpdate('date', date);
    tryUpdate('time', time);
    tryUpdate('consumer', consumer);
    tryUpdate('category', category);
    tryUpdate('transaction_type', transactionType);
    tryUpdate('bank', bank);
    tryUpdate('callname', callname); // <-- added

    if (updateFields.isNotEmpty) {
      await db.update('data', updateFields, where: 'upiid = ?', whereArgs: [upiid]);
    }
  } else {
    // Insert new row if UPI ID does not exist
    await db.insert('data', {
      'message': message,
      'amount': amount,
      'balance': balance,
      'date': date,
      'time': time,
      'consumer': consumer,
      'category': category,
      'upiid': upiid,
      'transaction_type': transactionType,
      'bank': bank,
      'callname': callname, // <-- added
    });
  }
}

}
