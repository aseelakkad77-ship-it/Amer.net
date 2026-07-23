import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/customer.dart';

class DatabaseService {
  static Isar? _isar;

  static Future<Isar> get isar async {
    if (_isar != null) return _isar!;
    return _isar = await _initIsar();
  }

  static Future<Isar> _initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      [CustomerSchema, TransactionSchema],
      directory: dir.path,
      name: 'amer_net',
    );
  }

  // Customer Operations
  static Future<List<Customer>> getAllCustomers() async {
    final db = await isar;
    return db.customers.where().sortByUpdatedAtDesc().findAll();
  }

  static Future<Customer?> getCustomer(int id) async {
    final db = await isar;
    return db.customers.get(id);
  }

  static Future<int> addCustomer(Customer customer) async {
    final db = await isar;
    return db.writeTxn(() async {
      return db.customers.put(customer);
    });
  }

  static Future<void> updateCustomer(Customer customer) async {
    final db = await isar;
    await db.writeTxn(() async {
      customer.updatedAt = DateTime.now();
      await db.customers.put(customer);
    });
  }

  static Future<void> deleteCustomer(int id) async {
    final db = await isar;
    await db.writeTxn(() async {
      // Delete all transactions for this customer
      final customer = await db.customers.get(id);
      if (customer != null) {
        await customer.transactions.delete();
      }
      await db.customers.delete(id);
    });
  }

  // Search Customers
  static Future<List<Customer>> searchCustomers(String query) async {
    final db = await isar;
    return db.customers
        .where()
        .nameContains(query, caseSensitive: false)
        .or()
        .phoneContains(query, caseSensitive: false)
        .sortByUpdatedAtDesc()
        .findAll();
  }

  // Transaction Operations
  static Future<void> addTransaction(
    int customerId,
    Transaction transaction,
  ) async {
    final db = await isar;
    await db.writeTxn(() async {
      final customer = await db.customers.get(customerId);
      if (customer != null) {
        transaction.customer.value = customer;
        await db.transactions.put(transaction);
        await customer.transactions.save();
        customer.updatedAt = DateTime.now();
        await db.customers.put(customer);
      }
    });
  }

  static Future<List<Transaction>> getCustomerTransactions(int customerId) async {
    final db = await isar;
    return db.transactions
        .where()
        .customer((q) => q.idEqualTo(customerId))
        .sortByDateTimeDesc()
        .findAll();
  }

  // Statistics
  static Future<Map<String, dynamic>> getStatistics() async {
    final db = await isar;
    final customers = await db.customers.where().findAll();
    final allTransactions = await db.transactions.where().findAll();

    double totalDebts = 0;
    double totalPayments = 0;
    int customersWithDebt = 0;

    for (final customer in customers) {
      final debts = allTransactions
          .where((t) => t.customer.value?.id == customer.id && t.type == 'دين')
          .fold(0.0, (sum, t) => sum + t.amount);
      final payments = allTransactions
          .where((t) => t.customer.value?.id == customer.id && t.type == 'تسديد')
          .fold(0.0, (sum, t) => sum + t.amount);

      totalDebts += debts;
      totalPayments += payments;
      if (debts > payments) {
        customersWithDebt++;
      }
    }

    return {
      'totalCustomers': customers.length,
      'totalDebts': totalDebts,
      'totalPayments': totalPayments,
      'customersWithDebt': customersWithDebt,
      'remainingDebt': totalDebts - totalPayments,
    };
  }

  // Backup & Restore
  static Future<void> closeDatabase() async {
    if (_isar != null) {
      await _isar!.close();
      _isar = null;
    }
  }
}
