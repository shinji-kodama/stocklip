import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'model/transaction.dart';

class Boxes {
  static Box<Transaction> getTransactions() =>
      Hive.box<Transaction>('transactions');
}
