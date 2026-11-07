import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../models/order_model.dart';
import '../../providers/admin_provider.dart';
import '../../providers/order_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';

class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({super.key});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  String _selectedStatusFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<AdminProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    List<OrderModel> orders = admin.allOrders;
    if (_selectedStatusFilter != 'All') {
      orders = orders.where((o) => o.status == _selectedStatusFilter).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manage Customer Orders'),
      ),
      body: Column(
        children: [
          // Filter Chips Horizontal Bar
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              children: [
                'All',
                AppConstants.statusPlaced,
                AppConstants.statusConfirmed,
                AppConstants.statusPreparing,
                AppConstants.statusOutForDelivery,
                AppConstants.statusDelivered,
                AppConstants.statusCancelled,
              ].map((status) {
                final isSelected = _selectedStatusFilter == status;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(status),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedStatusFilter = status;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),

          Expanded(
            child: orders.isEmpty
                ? Center(
                    child: Text(
                      'No orders found with status "$_selectedStatusFilter".',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  order.id,
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                                ),
                                Text(
                                  CurrencyFormatter.format(order.totalAmount),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${order.customerName} • ${order.customerPhone}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              order.deliveryAddress.fullAddress,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Divider(height: 18),

                            // Items summary
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: order.items.map((item) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    '${item.quantity} × ${item.foodName} (${item.vendorName})',
                                    style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                                  ),
                                );
                              }).toList(),
                            ),
                            const Divider(height: 18),

                            // Status changer dropdown
                            Row(
                              children: [
                                const Text(
                                  'Update Status:',
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceWarm,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: AppColors.primary, width: 1.2),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: order.status,
                                        isExpanded: true,
                                        items: AppConstants.orderStatuses.map((st) {
                                          return DropdownMenuItem(
                                            value: st,
                                            child: Text(
                                              st,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 13,
                                                color: AppColors.primaryDark,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (newStatus) async {
                                          if (newStatus != null) {
                                            await admin.updateOrderStatus(order.id, newStatus);
                                            orderProvider.advanceDemoOrderStatus(order.id);
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Order ${order.id} status updated to "$newStatus"')),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
