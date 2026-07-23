import 'package:isar/isar.dart';

part 'customer.g.dart';

@collection
class Customer {
  Id? id;
  late String name;
  String? phone;
  String? address;
  String? notes;
  late DateTime createdAt;
  late DateTime updatedAt;

  // Transient field
  @ignore
  double get totalDebt => transactions
      .where((t) => t.type == 'دين')
      .fold(0.0, (sum, t) => sum + t.amount);

  @ignore
  double get totalPayment => transactions
      .where((t) => t.type == 'تسديد')
      .fold(0.0, (sum, t) => sum + t.amount);

  @ignore
  double get currentBalance => totalDebt - totalPayment;

  @Backlink(to: 'customer')
  late final transactions = IsarLinks<Transaction>();

  Customer({
    this.id,
    required this.name,
    this.phone,
    this.address,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
  }
}

@collection
class Transaction {
  Id? id;
  late String type; // 'دين' or 'تسديد'
  late double amount;
  String? description;
  late DateTime dateTime;
  late DateTime createdAt;

  final customer = IsarLink<Customer>();

  @ignore
  double? balanceAfter;

  Transaction({
    this.id,
    required this.type,
    required this.amount,
    this.description,
    DateTime? dateTime,
    DateTime? createdAt,
  }) {
    this.dateTime = dateTime ?? DateTime.now();
    this.createdAt = createdAt ?? DateTime.now();
  }
}
