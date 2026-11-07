import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  final List<Map<String, String>> _faqs = const [
    {
      'question': 'How does Cheat Food ensure street food hygiene?',
      'answer': 'All vendors on Cheat Food adhere to strict FSSAI street vendor standards. Purified RO water is mandatory for Pani Puri / Gol Gappe, fresh oil is monitored, and food is packed in food-grade thermal containers.',
    },
    {
      'question': 'Are the street food prices higher than at the stall?',
      'answer': 'No! Cheat Food offers direct stall-menu pricing plus exclusive app discount coupons like CHEATDAY50 and STREET20.',
    },
    {
      'question': 'How fast will my street food arrive?',
      'answer': 'Most street snacks like Pani Puri, Samosas, and Momos are prepared within 8-12 minutes and delivered within 25-35 minutes to preserve maximum crispiness.',
    },
    {
      'question': 'Can I request Jain preparation or less spice?',
      'answer': 'Yes! Open any food item details screen to select spice levels (Mild, Medium, Fiery Spicy) or write instructions such as "No onion/garlic" or "Extra crisp puris".',
    },
    {
      'question': 'What if my food arrives cold or puris are broken?',
      'answer': 'We offer an instant refund or free stall replacement guarantee. Simply reach out via our support options below.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'We are here for you!',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Need help with your street food order? Connect with our support team.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.support_agent_rounded, size: 48, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Contact Options
            const Text('Instant Support Channels', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildContactBox(
                    icon: Icons.phone_in_talk_rounded,
                    title: 'Call Support',
                    subtitle: '1800-CHEAT-FOOD',
                    color: AppColors.primary,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Dialing Cheat Food Care: 1800-243-2836...')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildContactBox(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'WhatsApp Chat',
                    subtitle: 'Chat with Agent',
                    color: AppColors.mintGreen,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening WhatsApp Support Chat...')),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // FAQs
            const Text('Frequently Asked Questions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),

            ..._faqs.map((faq) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ExpansionTile(
                  shape: const Border(),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: Text(
                    faq['question']!,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 14),
                      child: Text(
                        faq['answer']!,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildContactBox({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
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
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
