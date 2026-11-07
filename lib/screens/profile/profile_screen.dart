import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../onboarding/welcome_screen.dart';
import '../order/order_history_screen.dart';
import '../favorites/favorites_screen.dart';
import '../admin/admin_dashboard_screen.dart';
import 'edit_profile_screen.dart';
import 'saved_addresses_screen.dart';
import 'help_support_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _confirmLogout(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Are you sure you want to sign out from Cheat Food?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              await auth.signOut();
              if (context.mounted) {
                Navigator.pop(ctx);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // User Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      user != null && user.name.isNotEmpty
                          ? user.name.substring(0, 1).toUpperCase()
                          : 'U',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Street Foodie',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user?.email ?? 'user@cheatfood.com',
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user?.phone ?? '+91 98765 43210',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Admin / Vendor Portal Box
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF24282C), Color(0xFF1E2124)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary, size: 24),
                ),
                title: const Text(
                  'Admin & Vendor Dashboard',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15),
                ),
                subtitle: const Text(
                  'Manage foods, categories, orders & vendors',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
                  );
                },
              ),
            ),

            // Navigation Links Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.receipt_long_rounded,
                    title: 'My Orders',
                    subtitle: 'View history & live order statuses',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildListTile(
                    icon: Icons.favorite_rounded,
                    title: 'Favourite Foods',
                    subtitle: 'Quick access to your craved delicacies',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildListTile(
                    icon: Icons.location_on_rounded,
                    title: 'Saved Delivery Addresses',
                    subtitle: 'Home, Work and other locations',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SavedAddressesScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildListTile(
                    icon: Icons.headset_mic_rounded,
                    title: 'Help & Support',
                    subtitle: 'Street food FAQs, live chat & assistance',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildListTile(
                    icon: Icons.logout_rounded,
                    title: 'Sign Out',
                    subtitle: 'Log out from this device',
                    isDestructive: true,
                    onTap: () => _confirmLogout(context, auth),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // App branding tag
            Text(
              '${AppConstants.appName} v${AppConstants.appVersion}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Exclusively Indian Street Food Platform',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive ? const Color(0xFFFFEBEE) : AppColors.surfaceWarm,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isDestructive ? AppColors.error : AppColors.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: isDestructive ? AppColors.error : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: Colors.grey),
      onTap: onTap,
    );
  }
}
