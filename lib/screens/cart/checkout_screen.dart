import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/address_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/validators.dart';
import '../order/order_success_screen.dart';
import '../profile/saved_addresses_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _instructionsController = TextEditingController();

  String _selectedPaymentMethod = 'Cash on Delivery';

  final List<Map<String, dynamic>> _paymentOptions = [
    {
      'title': 'Cash on Delivery (COD)',
      'subtitle': 'Pay cash or UPI scan when rider arrives',
      'icon': Icons.payments_outlined,
      'value': 'Cash on Delivery',
    },
    {
      'title': 'UPI (Google Pay / PhonePe / Paytm)',
      'subtitle': 'Fast & secure instant UPI payment',
      'icon': Icons.account_balance_wallet_outlined,
      'value': 'UPI (Google Pay / PhonePe)',
    },
    {
      'title': 'Credit / Debit Card',
      'subtitle': 'Visa, MasterCard, RuPay cards accepted',
      'icon': Icons.credit_card_rounded,
      'value': 'Credit / Debit Card',
    },
  ];

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.user != null) {
      _nameController.text = auth.user!.name;
      _phoneController.text = auth.user!.phone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    AddressModel? address = locationProvider.selectedAddress;

    // Fallback default address if none chosen yet
    address ??= AddressModel(
      id: 'addr_checkout_default',
      userId: authProvider.user?.uid ?? 'guest',
      label: 'Home',
      recipientName: _nameController.text.trim(),
      recipientPhone: _phoneController.text.trim(),
      houseFlatBlock: 'Street Stall Road 4',
      areaColonyStreet: 'Central Market',
      city: 'Delhi',
      pincode: '110001',
    );

    final placedOrder = await orderProvider.placeOrder(
      userId: authProvider.user?.uid ?? 'guest_uid',
      customerName: _nameController.text.trim(),
      customerPhone: _phoneController.text.trim(),
      deliveryAddress: address,
      cartItems: cartProvider.itemList,
      subtotal: cartProvider.subtotal,
      deliveryFee: cartProvider.deliveryFee,
      packagingFee: cartProvider.packagingFee,
      taxes: cartProvider.taxes,
      discountAmount: cartProvider.discountAmount,
      appliedCoupon: cartProvider.appliedCoupon,
      totalAmount: cartProvider.finalTotal,
      paymentMethod: _selectedPaymentMethod,
      deliveryInstructions: _instructionsController.text.trim().isNotEmpty
          ? _instructionsController.text.trim()
          : null,
    );

    if (!mounted) return;

    if (placedOrder != null) {
      // Clear cart only after verified placement
      cartProvider.clearCart();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(order: placedOrder),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(orderProvider.errorMessage ?? 'Order placement failed.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final activeAddress = locationProvider.selectedAddress;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout & Order'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Details Card
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
                        Icon(Icons.person_pin_circle_outlined, color: AppColors.primary, size: 20),
                        SizedBox(width: 8),
                        Text('Customer Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: _nameController,
                      label: 'Your Name',
                      hint: 'Recipient name',
                      prefixIcon: Icons.person_outline,
                      validator: Validators.validateName,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _phoneController,
                      label: 'Mobile Number (For Rider Updates)',
                      hint: '10-digit mobile',
                      prefixIcon: Icons.phone_android_rounded,
                      keyboardType: TextInputType.phone,
                      validator: Validators.validatePhone,
                    ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20),
                            SizedBox(width: 8),
                            Text('Delivery Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SavedAddressesScreen()),
                            );
                          },
                          child: const Text('Change / Add'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (activeAddress != null) ...[
                      Text(
                        '${activeAddress.label} • ${activeAddress.recipientName}',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        activeAddress.fullAddress,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ] else
                      const Text(
                        'No address selected yet. Default address will be applied.',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Payment Method Card
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
                        Icon(Icons.payment_rounded, color: AppColors.primary, size: 20),
                        SizedBox(width: 8),
                        Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._paymentOptions.map((opt) {
                      final isSelected = _selectedPaymentMethod == opt['value'];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = opt['value'] as String;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.surfaceWarm : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.grey.shade200,
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                                color: isSelected ? AppColors.primary : Colors.grey.shade400,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Icon(opt['icon'] as IconData, color: AppColors.textPrimary, size: 22),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      opt['title'] as String,
                                      style: TextStyle(
                                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      opt['subtitle'] as String,
                                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Delivery Instructions Note
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
                        Icon(Icons.note_alt_outlined, color: AppColors.primary, size: 20),
                        SizedBox(width: 8),
                        Text('Rider Delivery Instructions', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _instructionsController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Ring bell, leave package at door, call on arrival...',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Order Summary Breakdown
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total To Pay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        Text(
                          CurrencyFormatter.format(cart.finalTotal),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Includes items, delivery (${cart.deliveryFee == 0 ? 'FREE' : CurrencyFormatter.format(cart.deliveryFee)}), taxes and discounts.',
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Final Place Order Button
              CustomButton(
                text: 'Place Street Food Order • ${CurrencyFormatter.format(cart.finalTotal)}',
                isLoading: orderProvider.isLoading,
                icon: Icons.check_circle_outline_rounded,
                onPressed: _placeOrder,
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
