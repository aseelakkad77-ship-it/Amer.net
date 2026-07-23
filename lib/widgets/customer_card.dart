import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/customer.dart';
import '../config/app_theme.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback onTap;

  const CustomerCard({
    Key? key,
    required this.customer,
    required this.onTap,
  }) : super(key: key);

  Color _getStatusColor(double balance) {
    if (balance == 0) return AppTheme.successColor;
    if (balance > 0) return AppTheme.errorColor;
    return AppTheme.warningColor;
  }

  String _getStatusText(double balance) {
    if (balance == 0) return 'بلا ديون';
    if (balance > 0) return 'عليه ديون';
    return 'دفع زيادة';
  }

  @override
  Widget build(BuildContext context) {
    final balance = customer.currentBalance;
    final statusColor = _getStatusColor(balance);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Status indicator
              Container(
                width: 12,
                height: 60,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 16),
              // Customer info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (customer.phone != null)
                      Text(
                        customer.phone!,
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
              // Balance info
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${balance.toStringAsFixed(2)} ر.س',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getStatusText(balance),
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
