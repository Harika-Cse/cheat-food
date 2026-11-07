import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/veg_nonveg_badge.dart';
import '../../widgets/empty_state_widget.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    if (cart.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('My Street Cart')),
        body: EmptyStateWidget(
          emoji: '🛒',
          title: 'Your Cart is Empty',
          message: 'Explore authentic Indian street foods and satisfy your cravings today!',
          buttonText: 'Explore Street Foods',
          onButtonPressed: () => Navigator.pop(context),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Street Cart'),
        actions: [
          TextButton(
            onPressed: () {
              cart.clearCart();
            },
            child: const Text('Clear', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cart Items List
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cart.itemList.length,
                separatorBuilder: (ctx, i) => const Divider(),
                itemBuilder: (ctx, i) {
                  final item = cart.itemList[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VegNonVegBadge(isVeg: item.food.isVeg, size: 14),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.food.name,
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                              ),
                              if (item.selectedOptions.isNotEmpty)
                                Text(
                                  item.selectedOptions.join(', '),
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                CurrencyFormatter.format(item.totalPrice),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Quantity Counter
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceWarm,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.primary, width: 1),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => cart.decrementQuantity(item.id),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: Icon(Icons.remove, size: 16, color: AppColors.primary),
                                ),
                              ),
                              Text(
                                '${item.quantity}',
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                              ),
                              GestureDetector(
                                onTap: () => cart.incrementQuantity(item.id),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: Icon(Icons.add, size: 16, color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Coupon Code Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.local_offer_outlined, color: AppColors.primary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Offers & Coupons',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (cart.appliedCoupon != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.mintGreen),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AppColors.mintGreen, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Applied: ${cart.appliedCoupon!.code}',
                                  style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.mintGreen),
                                ),
                                Text(
                                  'Saved ${CurrencyFormatter.format(cart.discountAmount)}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.mintGreen),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => cart.removeCoupon(),
                            child: const Text('Remove', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _couponController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: const InputDecoration(
                              hintText: 'Enter coupon (CHEATDAY50)',
                              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          ),
                          onPressed: () {
                            if (_couponController.text.trim().isNotEmpty) {
                              cart.applyCoupon(_couponController.text.trim());
                            }
                          },
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                    if (cart.couponError != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        cart.couponError!,
                        style: const TextStyle(color: AppColors.error, fontSize: 12),
                      ),
                    ],
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Bill Summary
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
                  const Text('Bill Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  _buildBillRow('Item Total', CurrencyFormatter.format(cart.subtotal)),
                  const SizedBox(height: 8),
                  _buildBillRow(
                    'Delivery Fee',
                    cart.deliveryFee == 0 ? 'FREE' : CurrencyFormatter.format(cart.deliveryFee),
                    isGreen: cart.deliveryFee == 0,
                  ),
                  const SizedBox(height: 8),
                  _buildBillRow('Packaging & Stall Charges', CurrencyFormatter.format(cart.packagingFee)),
                  const SizedBox(height: 8),
                  _buildBillRow('GST & Restaurant Tax (5%)', CurrencyFormatter.format(cart.taxes)),
                  if (cart.discountAmount > 0) ...[
                    const SizedBox(height: 8),
                    _buildBillRow('Coupon Discount', '-${CurrencyFormatter.format(cart.discountAmount)}', isGreen: true),
                  ],
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'To Pay',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        CurrencyFormatter.format(cart.finalTotal),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),

      // Bottom Proceed to Checkout Bar
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Total Amount', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  Text(
                    CurrencyFormatter.format(cart.finalTotal),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                  );
                },
                child: const Row(
                  children: [
                    Text('Proceed to Checkout', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isGreen ? AppColors.mintGreen : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
