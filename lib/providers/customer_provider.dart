import 'package:flutter/foundation.dart';
import '../models/customer.dart';
import '../services/database_service.dart';

class CustomerProvider extends ChangeNotifier {
  List<Customer> _customers = [];
  List<Customer> _filteredCustomers = [];
  Map<String, dynamic> _statistics = {};
  bool _isLoading = false;

  List<Customer> get customers => _filteredCustomers.isEmpty ? _customers : _filteredCustomers;
  Map<String, dynamic> get statistics => _statistics;
  bool get isLoading => _isLoading;

  CustomerProvider() {
    loadCustomers();
    loadStatistics();
  }

  Future<void> loadCustomers() async {
    _isLoading = true;
    notifyListeners();
    try {
      _customers = await DatabaseService.getAllCustomers();
      _filteredCustomers = [];
      notifyListeners();
    } catch (e) {
      print('Error loading customers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadStatistics() async {
    try {
      _statistics = await DatabaseService.getStatistics();
      notifyListeners();
    } catch (e) {
      print('Error loading statistics: $e');
    }
  }

  Future<void> addCustomer(Customer customer) async {
    try {
      await DatabaseService.addCustomer(customer);
      await loadCustomers();
      await loadStatistics();
    } catch (e) {
      print('Error adding customer: $e');
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    try {
      await DatabaseService.updateCustomer(customer);
      await loadCustomers();
      await loadStatistics();
    } catch (e) {
      print('Error updating customer: $e');
    }
  }

  Future<void> deleteCustomer(int id) async {
    try {
      await DatabaseService.deleteCustomer(id);
      await loadCustomers();
      await loadStatistics();
    } catch (e) {
      print('Error deleting customer: $e');
    }
  }

  Future<void> searchCustomers(String query) async {
    if (query.isEmpty) {
      _filteredCustomers = [];
    } else {
      _filteredCustomers = await DatabaseService.searchCustomers(query);
    }
    notifyListeners();
  }

  Future<void> addTransaction(
    int customerId,
    Transaction transaction,
  ) async {
    try {
      await DatabaseService.addTransaction(customerId, transaction);
      await loadCustomers();
      await loadStatistics();
    } catch (e) {
      print('Error adding transaction: $e');
    }
  }

  Future<List<Transaction>> getCustomerTransactions(int customerId) async {
    try {
      return await DatabaseService.getCustomerTransactions(customerId);
    } catch (e) {
      print('Error loading transactions: $e');
      return [];
    }
  }
}
