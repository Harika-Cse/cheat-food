import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../constants/app_colors.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/custom_button.dart';
import 'order_tracking_screen.dart';
import '../main_navigation_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final OrderModel order;

  const OrderSuccessScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 1),

              // Animated celebration badge
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.mintGreen,
                    size: 54,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Order Placed Successfully!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Your street food feast is being prepped fresh at the stall!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Order Summary Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildRow('Order ID', order.id, isBold: true),
                    const Divider(height: 20),
                    _buildRow('Total Paid', CurrencyFormatter.format(order.totalAmount), isBold: true),
                    const SizedBox(height: 8),
                    _buildRow('Payment Mode', order.paymentMethod),
                    const SizedBox(height: 8),
                    _buildRow('Estimated Time', '25 - 35 mins'),
                    const SizedBox(height: 8),
                    _buildRow('Items Count', '${order.items.length} street delicacies'),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Track Order Button
              CustomButton(
                text: 'Track Order Live',
                icon: Icons.delivery_dining_rounded,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderTrackingScreen(orderId: order.id),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Back to Home
              CustomButton(
                text: 'Back to Home',
                isOutlined: true,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
