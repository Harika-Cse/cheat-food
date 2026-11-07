import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/order_status_timeline.dart';
import '../../widgets/custom_button.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  void _showCancelOrderDialog(BuildContext context, OrderProvider orderProv) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Order?', style: TextStyle(fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to cancel this street food order?'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(hintText: 'Reason for cancellation...'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Keep Order')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              await orderProv.cancelOrder(orderId, reasonController.text.trim());
              if (context.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order has been cancelled.')),
                );
              }
            },
            child: const Text('Confirm Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final order = orderProvider.getOrderById(orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: const Center(child: Text('Order not found.')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Track ${order.id}'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Status Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Estimated Street Arrival',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormatter.formatTime(order.estimatedDeliveryTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Status: ${order.status}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delivery_dining_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Demonstration / Evaluation Control: Advance Order Status
            if (order.isActive)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWarm,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.speed_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Demo Tool: Step order status forward',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () => orderProvider.advanceDemoOrderStatus(order.id),
                      child: const Text('Next Step ➔', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),

            // Live Timeline Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Progress',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 18),
                  OrderStatusTimeline(currentStatus: order.status),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Delivery Address Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20),
                      SizedBox(width: 8),
                      Text('Delivery Location', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${order.customerName} • ${order.customerPhone}',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    order.deliveryAddress.fullAddress,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  if (order.deliveryInstructions != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Note: "${order.deliveryInstructions}"',
                      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.primaryDark),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Ordered Delicacies Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ordered Street Foods', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  ...order.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceWarm,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.foodName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                if (item.selectedOptions.isNotEmpty)
                                  Text(
                                    item.selectedOptions.join(', '),
                                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                  ),
                              ],
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(item.totalPrice),
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount Paid', style: TextStyle(fontWeight: FontWeight.w800)),
                      Text(
                        CurrencyFormatter.format(order.totalAmount),
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Cancel Button if order is still early in workflow
            if (order.status == AppConstants.statusPlaced || order.status == AppConstants.statusConfirmed)
              CustomButton(
                text: 'Cancel Order',
                isOutlined: true,
                backgroundColor: AppColors.error,
                textColor: AppColors.error,
                onPressed: () => _showCancelOrderDialog(context, orderProvider),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
