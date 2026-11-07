import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../models/food_item_model.dart';
import '../../providers/admin_provider.dart';
import '../../providers/food_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/validators.dart';

class AddEditFoodScreen extends StatefulWidget {
  final FoodItem? foodToEdit;

  const AddEditFoodScreen({super.key, this.foodToEdit});

  @override
  State<AddEditFoodScreen> createState() => _AddEditFoodScreenState();
}

class _AddEditFoodScreenState extends State<AddEditFoodScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _discountController;
  late TextEditingController _imageController;
  late TextEditingController _prepTimeController;

  String _selectedCategoryId = AppConstants.catChaat;
  String _selectedVendorId = 'vendor_sharma_chaat';
  String _selectedSpiceLevel = AppConstants.spiceMedium;
  bool _isVeg = true;
  bool _isBestSeller = false;
  bool _isTrending = false;
  bool _isRecommended = false;

  @override
  void initState() {
    super.initState();
    final f = widget.foodToEdit;

    _nameController = TextEditingController(text: f?.name ?? '');
    _descController = TextEditingController(text: f?.description ?? '');
    _priceController = TextEditingController(text: f != null ? f.price.toStringAsFixed(0) : '');
    _discountController = TextEditingController(text: f?.discountPrice != null ? f!.discountPrice!.toStringAsFixed(0) : '');
    _imageController = TextEditingController(text: f?.imageUrl ?? 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=800&q=80');
    _prepTimeController = TextEditingController(text: f != null ? '${f.preparationTimeMinutes}' : '12');

    if (f != null) {
      _selectedCategoryId = f.categoryId;
      _selectedVendorId = f.vendorId;
      _selectedSpiceLevel = f.spiceLevel;
      _isVeg = f.isVeg;
      _isBestSeller = f.isBestSeller;
      _isTrending = f.isTrending;
      _isRecommended = f.isRecommended;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _imageController.dispose();
    _prepTimeController.dispose();
    super.dispose();
  }

  void _saveFood() async {
    if (!_formKey.currentState!.validate()) return;

    final admin = Provider.of<AdminProvider>(context, listen: false);
    final foodProv = Provider.of<FoodProvider>(context, listen: false);

    final cat = admin.categories.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => admin.categories.first,
    );
    final vendor = admin.vendors.firstWhere(
      (v) => v.id == _selectedVendorId,
      orElse: () => admin.vendors.first,
    );

    final price = double.parse(_priceController.text.trim());
    final discountPrice = _discountController.text.trim().isNotEmpty
        ? double.tryParse(_discountController.text.trim())
        : null;
    final prepTime = int.tryParse(_prepTimeController.text.trim()) ?? 15;

    final foodItem = FoodItem(
      id: widget.foodToEdit?.id ?? 'food_${const Uuid().v4().substring(0, 8)}',
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      categoryId: cat.id,
      categoryName: cat.name,
      price: price,
      discountPrice: discountPrice,
      imageUrl: _imageController.text.trim(),
      isVeg: _isVeg,
      spiceLevel: _selectedSpiceLevel,
      vendorId: vendor.id,
      vendorName: vendor.name,
      rating: widget.foodToEdit?.rating ?? 4.8,
      ratingCount: widget.foodToEdit?.ratingCount ?? 25,
      preparationTimeMinutes: prepTime,
      isAvailable: widget.foodToEdit?.isAvailable ?? true,
      isBestSeller: _isBestSeller,
      isTrending: _isTrending,
      isRecommended: _isRecommended,
      customizations: widget.foodToEdit?.customizations ?? const [],
    );

    if (widget.foodToEdit != null) {
      await admin.updateFoodItem(foodItem);
    } else {
      await admin.addFoodItem(foodItem);
    }

    // Refresh public food provider
    await foodProv.loadInitialData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.foodToEdit != null ? 'Food item updated!' : 'New food item added to menu!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<AdminProvider>(context);
    final isEditing = widget.foodToEdit != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Street Food' : 'Add New Street Food'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Food Name',
                hint: 'e.g., Kurkuri Aloo Tikki Chaat',
                validator: (v) => Validators.validateRequired(v, 'Food Name'),
              ),
              const SizedBox(height: 14),

              CustomTextField(
                controller: _descController,
                label: 'Description',
                hint: 'Describe street preparation, chutneys, spices...',
                maxLines: 3,
                validator: (v) => Validators.validateRequired(v, 'Description'),
              ),
              const SizedBox(height: 14),

              // Category dropdown
              const Text('Street Food Category', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedCategoryId,
                    items: admin.categories.map((c) {
                      return DropdownMenuItem(
                        value: c.id,
                        child: Text('${c.iconEmoji} ${c.name}'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategoryId = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Vendor dropdown
              const Text('Street Vendor / Stall', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedVendorId,
                    items: admin.vendors.map((v) {
                      return DropdownMenuItem(
                        value: v.id,
                        child: Text(v.name),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedVendorId = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Price & Discount Price
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _priceController,
                      label: 'Price (₹)',
                      hint: 'e.g. 60',
                      keyboardType: TextInputType.number,
                      validator: Validators.validatePrice,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _discountController,
                      label: 'Discounted (₹)',
                      hint: 'e.g. 49 (Optional)',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Spice Level Dropdown
              const Text('Spice Level', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedSpiceLevel,
                    items: AppConstants.spiceLevels.map((lvl) {
                      return DropdownMenuItem(
                        value: lvl,
                        child: Text(lvl),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedSpiceLevel = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Preparation Time
              CustomTextField(
                controller: _prepTimeController,
                label: 'Preparation Time (Minutes)',
                hint: 'e.g. 10',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 14),

              // Image URL
              CustomTextField(
                controller: _imageController,
                label: 'Food Image URL (Unsplash or Firebase Storage)',
                hint: 'https://...',
                validator: (v) => Validators.validateRequired(v, 'Image URL'),
              ),
              const SizedBox(height: 14),

              // Switches
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Pure Veg (Green Dot Indicator)', style: TextStyle(fontWeight: FontWeight.w700)),
                value: _isVeg,
                activeColor: AppColors.veg,
                onChanged: (v) => setState(() => _isVeg = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Mark as Best Seller', style: TextStyle(fontWeight: FontWeight.w700)),
                value: _isBestSeller,
                activeColor: AppColors.primary,
                onChanged: (v) => setState(() => _isBestSeller = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Mark as Trending', style: TextStyle(fontWeight: FontWeight.w700)),
                value: _isTrending,
                activeColor: AppColors.primary,
                onChanged: (v) => setState(() => _isTrending = v),
              ),

              const SizedBox(height: 24),

              CustomButton(
                text: isEditing ? 'Save Changes' : 'Add Food to Menu',
                onPressed: _saveFood,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
