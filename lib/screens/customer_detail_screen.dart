import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/customer.dart';
import '../providers/customer_provider.dart';
import '../config/app_theme.dart';
import '../widgets/watermark.dart';
import 'add_customer_screen.dart';
import 'add_transaction_screen.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer customer;

  const CustomerDetailScreen({Key? key, required this.customer})
      : super(key: key);

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  late List<Transaction> _transactions;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final provider = context.read<CustomerProvider>();
    _transactions =
        await provider.getCustomerTransactions(widget.customer.id ?? 0);
    setState(() => _isLoading = false);
  }

  void _deleteCustomer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'حذف العميل',
          style: GoogleFonts.cairo(),
        ),
        content: Text(
          'هل أنت متأكد من حذف ${widget.customer.name}؟',
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          TextButton(
            onPressed: () async {
              final provider = context.read<CustomerProvider>();
              await provider.deleteCustomer(widget.customer.id ?? 0);
              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'تم حذف العميل',
                      style: GoogleFonts.cairo(),
                    ),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              }
            },
            child: Text(
              'حذف',
              style: GoogleFonts.cairo(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(double balance) {
    if (balance == 0) return AppTheme.successColor;
    if (balance > 0) return AppTheme.errorColor;
    return AppTheme.warningColor;
  }

  @override
  Widget build(BuildContext context) {
    final balance = widget.customer.currentBalance;
    final statusColor = _getStatusColor(balance);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.customer.name,
          style: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddCustomerScreen(customer: widget.customer),
              ),
            ).then((_) => setState(() {})),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteCustomer,
          ),
        ],
      ),
      body: Watermark(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Customer Header Card
                    Card(
                      margin: const EdgeInsets.all(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Balance
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    'الرصيد الحالي',
                                    style: GoogleFonts.cairo(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${balance.toStringAsFixed(2)} ر.س',
                                    style: GoogleFonts.cairo(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: statusColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Customer Info
                            Text(
                              'معلومات العميل',
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (widget.customer.phone != null)
                              _buildInfoRow(
                                'الهاتف',
                                widget.customer.phone!,
                                Icons.phone,
                              ),
                            if (widget.customer.address != null)
                              _buildInfoRow(
                                'العنوان',
                                widget.customer.address!,
                                Icons.location_on,
                              ),
                            if (widget.customer.notes != null)
                              _buildInfoRow(
                                'ملاحظات',
                                widget.customer.notes!,
                                Icons.note,
                              ),
                          ],
                        ),
                      ),
                    ),
                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddTransactionScreen(
                                    customer: widget.customer,
                                    type: 'دين',
                                  ),
                                ),
                              ).then((_) => setState(() => _loadTransactions())),
                              icon: const Icon(Icons.add),
                              label: Text(
                                'إضافة دين',
                                style: GoogleFonts.cairo(),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.errorColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddTransactionScreen(
                                    customer: widget.customer,
                                    type: 'تسديد',
                                  ),
                                ),
                              ).then((_) => setState(() => _loadTransactions())),
                              icon: const Icon(Icons.check_circle),
                              label: Text(
                                'تسديد',
                                style: GoogleFonts.cairo(),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.successColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Transactions History
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'سجل العمليات',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_transactions.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'لا توجد عمليات',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = _transactions[index];
                          final isDebt = transaction.type == 'دين';
                          return _buildTransactionTile(transaction, isDebt);
                        },
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(Transaction transaction, bool isDebt) {
    final color = isDebt ? AppTheme.errorColor : AppTheme.successColor;
    final symbol = isDebt ? '+' : '-';
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'ar');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '$symbol${transaction.amount.toStringAsFixed(0)}',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.type,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (transaction.description != null)
                    Text(
                      transaction.description!,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  Text(
                    dateFormat.format(transaction.dateTime),
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
