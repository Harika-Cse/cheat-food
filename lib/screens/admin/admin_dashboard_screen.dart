import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/admin_provider.dart';
import '../../utils/currency_formatter.dart';
import 'manage_foods_screen.dart';
import 'manage_orders_screen.dart';
import 'manage_categories_screen.dart';
import 'manage_vendors_screen.dart';
import 'add_edit_food_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).loadAdminData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<AdminProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Vendor & Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => admin.loadAdminData(),
          ),
        ],
      ),
      body: admin.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Admin Welcome Banner
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E2124), Color(0xFF2C3238)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Stall Operations & Metrics',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'ADMIN MODE',
                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Total Street Sales',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          CurrencyFormatter.format(admin.totalRevenue),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Metrics 2x2 Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile(
                          title: 'Total Orders',
                          value: '${admin.totalOrderCount}',
                          icon: Icons.receipt_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricTile(
                          title: 'Pending Orders',
                          value: '${admin.pendingOrdersCount}',
                          icon: Icons.pending_actions_rounded,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile(
                          title: 'Active Foods',
                          value: '${admin.activeFoodsCount}',
                          icon: Icons.restaurant_menu_rounded,
                          color: AppColors.mintGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricTile(
                          title: 'Stall Vendors',
                          value: '${admin.vendors.length}',
                          icon: Icons.storefront_rounded,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Quick Operations Section
                  const Text('Management Modules', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),

                  _buildNavCard(
                    icon: Icons.fastfood_rounded,
                    title: 'Manage Street Food Items',
                    subtitle: 'Add new items, update prices, upload pictures & edit',
                    badge: '${admin.allFoods.length} items',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ManageFoodsScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  _buildNavCard(
                    icon: Icons.list_alt_rounded,
                    title: 'Live Order Management',
                    subtitle: 'Accept incoming orders, update cooking & rider delivery status',
                    badge: '${admin.allOrders.length} orders',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ManageOrdersScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  _buildNavCard(
                    icon: Icons.category_rounded,
                    title: 'Manage Food Categories',
                    subtitle: 'Chaat, Mumbai, South Indian, Rolls, Beverages',
                    badge: '${admin.categories.length} categories',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ManageCategoriesScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  _buildNavCard(
                    icon: Icons.storefront_rounded,
                    title: 'Manage Vendors & Stalls',
                    subtitle: 'Sharma Chaat, Sardar Pav Bhaji, Anand Dosa & more',
                    badge: '${admin.vendors.length} vendors',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ManageVendorsScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Seed Data Action Button
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWarm,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.cloud_sync_rounded, color: AppColors.primary, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'Seed Cloud Database',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Click to instantly populate Cloud Firestore with all Indian street foods, vendors, and coupons.',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                            icon: const Icon(Icons.download_rounded, size: 18),
                            label: const Text('Seed Database Now'),
                            onPressed: () async {
                              await admin.seedInitialData();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Database seeded successfully!')),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Food Item', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditFoodScreen()),
          );
        },
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
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
              Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildNavCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String badge,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surfaceWarm,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            badge,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
