import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/food_item_model.dart';
import '../../models/review_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/food_provider.dart';
import '../../providers/auth_provider.dart';
import '../../constants/app_colors.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/veg_nonveg_badge.dart';
import '../../widgets/spice_level_badge.dart';
import '../../widgets/rating_badge.dart';
import '../../widgets/custom_button.dart';

class FoodDetailsScreen extends StatefulWidget {
  final FoodItem food;

  const FoodDetailsScreen({super.key, required this.food});

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  int _quantity = 1;
  final Map<String, List<FoodCustomizationOption>> _selectedCustomizations = {};
  final TextEditingController _instructionController = TextEditingController();
  List<ReviewModel> _reviews = [];
  bool _loadingReviews = true;

  @override
  void initState() {
    super.initState();
    _initCustomizationDefaults();
    _loadReviews();
  }

  void _initCustomizationDefaults() {
    for (final group in widget.food.customizations) {
      if (!group.isMultipleChoice && group.options.isNotEmpty) {
        _selectedCustomizations[group.title] = [group.options.first];
      } else {
        _selectedCustomizations[group.title] = [];
      }
    }
  }

  Future<void> _loadReviews() async {
    final foodProvider = Provider.of<FoodProvider>(context, listen: false);
    final revs = await foodProvider.getReviews(widget.food.id);
    if (mounted) {
      setState(() {
        _reviews = revs;
        _loadingReviews = false;
      });
    }
  }

  @override
  void dispose() {
    _instructionController.dispose();
    super.dispose();
  }

  double get _extraOptionsTotalPerUnit {
    double total = 0.0;
    _selectedCustomizations.forEach((_, options) {
      for (final opt in options) {
        total += opt.extraPrice;
      }
    });
    return total;
  }

  double get _itemUnitTotal => widget.food.effectivePrice + _extraOptionsTotalPerUnit;
  double get _calculatedTotal => _itemUnitTotal * _quantity;

  List<String> get _flattenedSelectedOptionNames {
    final List<String> list = [];
    _selectedCustomizations.forEach((_, options) {
      for (final opt in options) {
        list.add(opt.name);
      }
    });
    return list;
  }

  void _showAddReviewDialog() {
    double newRating = 5.0;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              title: const Text('Review Street Food', style: TextStyle(fontWeight: FontWeight.w800)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How was ${widget.food.name}?', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starValue = index + 1.0;
                      return IconButton(
                        icon: Icon(
                          starValue <= newRating ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: AppColors.accent,
                          size: 32,
                        ),
                        onPressed: () {
                          setDialogState(() {
                            newRating = starValue;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Share taste, crispiness, spice level details...',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final auth = Provider.of<AuthProvider>(context, listen: false);
                    final foodProvider = Provider.of<FoodProvider>(context, listen: false);

                    final review = ReviewModel(
                      id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
                      foodId: widget.food.id,
                      userId: auth.user?.uid ?? 'guest_uid',
                      userName: auth.user?.name ?? 'Street Foodie',
                      rating: newRating,
                      comment: commentController.text.trim().isNotEmpty
                          ? commentController.text.trim()
                          : 'Delicious Indian street food!',
                      createdAt: DateTime.now(),
                    );

                    await foodProvider.submitReview(review);
                    if (mounted) {
                      setState(() {
                        _reviews.insert(0, review);
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Review submitted! Thank you!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                  child: const Text('Post Review'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final favProvider = Provider.of<FavoritesProvider>(context);
    final isFav = favProvider.isFavorite(widget.food.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Collapsible Image App Bar with Hero Animation
          SliverAppBar(
            expandedHeight: 290,
            pinned: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.9),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isFav ? AppColors.secondary : Colors.grey.shade700,
                      size: 22,
                    ),
                    onPressed: () => favProvider.toggleFavorite(widget.food),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'food_img_${widget.food.id}',
                child: CachedNetworkImage(
                  imageUrl: widget.food.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.surfaceWarm,
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.surfaceWarm,
                    child: const Icon(Icons.fastfood_rounded, size: 60, color: AppColors.primary),
                  ),
                ),
              ),
            ),
          ),

          // Food Details Body
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges Row
                  Row(
                    children: [
                      VegNonVegBadge(isVeg: widget.food.isVeg, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        widget.food.isVeg ? 'PURE VEG' : 'NON-VEG',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: widget.food.isVeg ? AppColors.veg : AppColors.nonVeg,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      SpiceLevelBadge(level: widget.food.spiceLevel),
                      const SizedBox(width: 8),
                      RatingBadge(rating: widget.food.rating, count: widget.food.ratingCount),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Food Name
                  Text(
                    widget.food.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Vendor & Preparation Time
                  Row(
                    children: [
                      const Icon(Icons.storefront_rounded, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        widget.food.vendorName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.timer_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.food.preparationTimeMinutes} mins prep',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Price
                  Row(
                    children: [
                      Text(
                        CurrencyFormatter.format(widget.food.effectivePrice),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (widget.food.hasDiscount) ...[
                        const SizedBox(width: 8),
                        Text(
                          CurrencyFormatter.format(widget.food.price),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade400,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceWarm,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.primary, width: 0.8),
                          ),
                          child: Text(
                            '${widget.food.discountPercentage}% OFF',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Description
                  Text(
                    widget.food.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Divider(),
                  const SizedBox(height: 12),

                  // Customization Options
                  if (widget.food.customizations.isNotEmpty) ...[
                    const Text(
                      'Customize Your Order',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Choose spice levels, extra chutneys, puris, or toppings',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 14),

                    ...widget.food.customizations.map((group) {
                      final selectedInGroup = _selectedCustomizations[group.title] ?? [];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  group.title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: group.isRequired ? const Color(0xFFFFEBEE) : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    group.isRequired ? 'REQUIRED' : 'OPTIONAL',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: group.isRequired ? AppColors.secondary : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            ...group.options.map((option) {
                              final isChecked = selectedInGroup.any((o) => o.name == option.name);

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (group.isMultipleChoice) {
                                      if (isChecked) {
                                        selectedInGroup.removeWhere((o) => o.name == option.name);
                                      } else {
                                        selectedInGroup.add(option);
                                      }
                                    } else {
                                      _selectedCustomizations[group.title] = [option];
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    children: [
                                      Icon(
                                        group.isMultipleChoice
                                            ? (isChecked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded)
                                            : (isChecked ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded),
                                        color: isChecked ? AppColors.primary : Colors.grey.shade400,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          option.name,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: isChecked ? FontWeight.w700 : FontWeight.w500,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      if (option.extraPrice > 0)
                                        Text(
                                          '+${CurrencyFormatter.format(option.extraPrice)}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    }),
                  ],

                  // Special Instructions
                  const Text(
                    'Cooking Instructions for Stall',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _instructionController,
                    decoration: const InputDecoration(
                      hintText: 'e.g., Less spicy, no onions, extra sweet chutney...',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Reviews & Ratings Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Customer Reviews',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(width: 8),
                          Text('(${_reviews.length})', style: const TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.rate_review_outlined, size: 16),
                        label: const Text('Add Review'),
                        onPressed: _showAddReviewDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (_loadingReviews)
                    const Center(child: CircularProgressIndicator())
                  else if (_reviews.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('No reviews yet. Be the first to review!'),
                    )
                  else
                    ..._reviews.map((rev) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceWarm.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  rev.userName,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                ),
                                RatingBadge(rating: rev.rating),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              rev.comment,
                              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormatter.formatShortDate(rev.createdAt),
                              style: const TextStyle(fontSize: 10, color: AppColors.textLight),
                            ),
                          ],
                        ),
                      );
                    }),

                  const SizedBox(height: 100), // padding for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Add To Cart Bar
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
              // Quantity Counter
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceWarm,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary, width: 1.2),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18, color: AppColors.primary),
                      onPressed: () {
                        if (_quantity > 1) {
                          setState(() {
                            _quantity--;
                          });
                        }
                      },
                    ),
                    Text(
                      '$_quantity',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18, color: AppColors.primary),
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Add to Cart Button with dynamic total
              Expanded(
                child: CustomButton(
                  text: 'Add • ${CurrencyFormatter.format(_calculatedTotal)}',
                  icon: Icons.shopping_bag_rounded,
                  onPressed: () {
                    cartProvider.addItem(
                      food: widget.food,
                      quantity: _quantity,
                      selectedOptions: _flattenedSelectedOptionNames,
                      extraPricePerUnit: _extraOptionsTotalPerUnit,
                      specialInstructions: _instructionController.text.trim().isNotEmpty
                          ? _instructionController.text.trim()
                          : null,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added $_quantity × ${widget.food.name} to cart!'),
                        duration: const Duration(seconds: 2),
                        backgroundColor: AppColors.primaryDark,
                        action: SnackBarAction(
                          label: 'VIEW CART',
                          textColor: Colors.white,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
