import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/customer_provider.dart';
import '../config/app_theme.dart';
import '../widgets/watermark.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الإحصائيات',
          style: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Watermark(
        child: Consumer<CustomerProvider>(
          builder: (context, provider, _) {
            final stats = provider.statistics;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Total Debts Card
                  _buildStatCard(
                    title: 'إجمالي الديون',
                    value:
                        '${stats['totalDebts']?.toStringAsFixed(2) ?? '0.00'} ر.س',
                    color: AppTheme.errorColor,
                    icon: Icons.trending_up,
                  ),
                  const SizedBox(height: 12),
                  // Total Payments Card
                  _buildStatCard(
                    title: 'إجمالي المسددات',
                    value:
                        '${stats['totalPayments']?.toStringAsFixed(2) ?? '0.00'} ر.س',
                    color: AppTheme.successColor,
                    icon: Icons.check_circle,
                  ),
                  const SizedBox(height: 12),
                  // Remaining Debt Card
                  _buildStatCard(
                    title: 'الديون المتبقية',
                    value:
                        '${stats['remainingDebt']?.toStringAsFixed(2) ?? '0.00'} ر.س',
                    color: AppTheme.warningColor,
                    icon: Icons.warning,
                  ),
                  const SizedBox(height: 12),
                  // Total Customers Card
                  _buildStatCard(
                    title: 'عدد العملاء',
                    value: '${stats['totalCustomers'] ?? 0}',
                    color: AppTheme.accentColor,
                    icon: Icons.people,
                  ),
                  const SizedBox(height: 12),
                  // Customers with Debt Card
                  _buildStatCard(
                    title: 'العملاء ذوو الديون',
                    value: '${stats['customersWithDebt'] ?? 0}',
                    color: AppTheme.primaryColor,
                    icon: Icons.account_balance,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: GoogleFonts.cairo(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
