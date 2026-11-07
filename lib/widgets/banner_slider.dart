import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class BannerItem {
  final String title;
  final String subtitle;
  final String couponCode;
  final String buttonText;
  final List<Color> gradientColors;
  final String emoji;

  const BannerItem({
    required this.title,
    required this.subtitle,
    required this.couponCode,
    required this.buttonText,
    required this.gradientColors,
    required this.emoji,
  });
}

class BannerSlider extends StatefulWidget {
  final void Function(String couponCode)? onCouponTap;

  const BannerSlider({super.key, this.onCouponTap});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<BannerItem> _banners = const [
    BannerItem(
      title: 'Craving Indian Street Food?',
      subtitle: 'Flat 50% OFF on Gol Gappe & Vada Pav',
      couponCode: 'CHEATDAY50',
      buttonText: 'USE CHEATDAY50',
      gradientColors: [Color(0xFFFF5722), Color(0xFFD32F2F)],
      emoji: '🌶️',
    ),
    BannerItem(
      title: 'Authentic Mumbai Special',
      subtitle: 'Amul Butter Pav Bhaji with extra pavs',
      couponCode: 'STREET20',
      buttonText: 'USE STREET20',
      gradientColors: [Color(0xFFE65100), Color(0xFFBF360C)],
      emoji: '🧈',
    ),
    BannerItem(
      title: 'Free Delivery Weekend',
      subtitle: 'Hot samosas & cutting chai at ₹0 delivery',
      couponCode: 'FREEDELIVERY',
      buttonText: 'USE FREEDELIVERY',
      gradientColors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
      emoji: '🛵',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 155,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (idx) {
              setState(() {
                _currentPage = idx;
              });
            },
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: banner.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: banner.gradientColors.first.withValues(alpha: 0.35),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'SPECIAL STREET DEAL',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            banner.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            banner.subtitle,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              if (widget.onCouponTap != null) {
                                widget.onCouponTap!(banner.couponCode);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                banner.buttonText,
                                style: TextStyle(
                                  color: banner.gradientColors.first,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        banner.emoji,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == index ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.primary
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
