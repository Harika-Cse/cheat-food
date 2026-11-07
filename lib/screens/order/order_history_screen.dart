import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/empty_state_widget.dart';
import 'order_tracking_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final orderProv = Provider.of<OrderProvider>(context, listen: false);
      orderProv.fetchOrders(auth.user?.uid ?? 'user_default');
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Street Orders'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          tabs: [
            Tab(text: 'Active Orders (${orderProvider.activeOrders.length})'),
            Tab(text: 'Past Orders (${orderProvider.pastOrders.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Active Orders Tab
          _buildOrderList(orderProvider.activeOrders, isActiveTab: true),

          // Past Orders Tab
          _buildOrderList(orderProvider.pastOrders, isActiveTab: false),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<OrderModel> list, {required bool isActiveTab}) {
    if (list.isEmpty) {
      return EmptyStateWidget(
        emoji: '🧾',
        title: isActiveTab ? 'No Active Orders' : 'No Past Orders',
        message: isActiveTab
            ? 'You have no orders currently in preparation or on the road.'
            : 'You have not completed any street food orders yet.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final order = list[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    Color statusBg;
    Color statusColor;

    switch (order.status) {
      case AppConstants.statusDelivered:
        statusBg = const Color(0xFFE8F5E9);
        statusColor = AppColors.mintGreen;
        break;
      case AppConstants.statusCancelled:
        statusBg = const Color(0xFFFFEBEE);
        statusColor = AppColors.error;
        break;
      case AppConstants.statusOutForDelivery:
        statusBg = const Color(0xFFE3F2FD);
        statusColor = AppColors.info;
        break;
      default:
        statusBg = AppColors.surfaceWarm;
        statusColor = AppColors.primaryDark;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrderTrackingScreen(orderId: order.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Order ID & Status Pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.id,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order.status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Date
                Text(
                  DateFormatter.formatOrderDate(order.createdAt),
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const Divider(height: 20),

                // Item Names Summary
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: order.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.quantity} × ${item.foodName}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(item.totalPrice),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const Divider(height: 20),

                // Footer: Total & Track action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Amount', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        Text(
                          CurrencyFormatter.format(order.totalAmount),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          order.isActive ? 'Track Live' : 'View Details',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.primary),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
