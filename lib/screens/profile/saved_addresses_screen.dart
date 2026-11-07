import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../constants/app_colors.dart';
import '../../models/address_model.dart';
import '../../providers/location_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/validators.dart';

class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  void _showAddAddressSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final labelOptions = ['Home', 'Work', 'Other'];
    String selectedLabel = 'Home';

    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final flatController = TextEditingController();
    final areaController = TextEditingController();
    final landmarkController = TextEditingController();
    final cityController = TextEditingController(text: 'Delhi');
    final pinController = TextEditingController();
    bool isDefault = false;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.user != null) {
      nameController.text = auth.user!.name;
      phoneController.text = auth.user!.phone;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add Delivery Address',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 10),

                      // Label selection
                      Row(
                        children: labelOptions.map((lbl) {
                          final isSelected = selectedLabel == lbl;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(lbl),
                              selected: isSelected,
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                              onSelected: (val) {
                                setSheetState(() {
                                  selectedLabel = lbl;
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 14),

                      CustomTextField(
                        controller: nameController,
                        label: 'Recipient Name',
                        validator: Validators.validateName,
                      ),
                      const SizedBox(height: 10),

                      CustomTextField(
                        controller: phoneController,
                        label: 'Contact Phone',
                        keyboardType: TextInputType.phone,
                        validator: Validators.validatePhone,
                      ),
                      const SizedBox(height: 10),

                      CustomTextField(
                        controller: flatController,
                        label: 'Flat / House / Stall Number',
                        validator: (v) => Validators.validateRequired(v, 'House/Flat'),
                      ),
                      const SizedBox(height: 10),

                      CustomTextField(
                        controller: areaController,
                        label: 'Area / Street / Colony',
                        validator: (v) => Validators.validateRequired(v, 'Area/Street'),
                      ),
                      const SizedBox(height: 10),

                      CustomTextField(
                        controller: landmarkController,
                        label: 'Landmark (Optional)',
                        hint: 'Near Metro / Temple / Market',
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: cityController,
                              label: 'City',
                              validator: (v) => Validators.validateRequired(v, 'City'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              controller: pinController,
                              label: 'Pincode',
                              keyboardType: TextInputType.number,
                              validator: (v) => Validators.validateRequired(v, 'Pincode'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Set as Default Delivery Address', style: TextStyle(fontWeight: FontWeight.w600)),
                        value: isDefault,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setSheetState(() {
                            isDefault = val;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      CustomButton(
                        text: 'Save Address',
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          final loc = Provider.of<LocationProvider>(context, listen: false);

                          final newAddress = AddressModel(
                            id: 'addr_${const Uuid().v4().substring(0, 8)}',
                            userId: auth.user?.uid ?? 'guest',
                            label: selectedLabel,
                            recipientName: nameController.text.trim(),
                            recipientPhone: phoneController.text.trim(),
                            houseFlatBlock: flatController.text.trim(),
                            areaColonyStreet: areaController.text.trim(),
                            landmark: landmarkController.text.trim().isNotEmpty
                                ? landmarkController.text.trim()
                                : null,
                            city: cityController.text.trim(),
                            pincode: pinController.text.trim(),
                            isDefault: isDefault,
                          );

                          await loc.addAddress(newAddress);
                          if (context.mounted) {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Address saved!')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Saved Addresses'),
      ),
      body: locationProvider.addresses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off_outlined, size: 54, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  const Text('No Saved Addresses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  const Text('Add your delivery address for fast checkout.', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Address'),
                    onPressed: () => _showAddAddressSheet(context),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: locationProvider.addresses.length,
              itemBuilder: (context, index) {
                final addr = locationProvider.addresses[index];
                final isDefault = addr.isDefault;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDefault ? AppColors.primary : Colors.grey.shade200,
                      width: isDefault ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                addr.label == 'Home' ? Icons.home_rounded : (addr.label == 'Work' ? Icons.work_rounded : Icons.location_on_rounded),
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                addr.label,
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                              ),
                              if (isDefault) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceWarm,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'DEFAULT',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                            onPressed: () {
                              locationProvider.deleteAddress(auth.user?.uid ?? 'guest', addr.id);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${addr.recipientName} • ${addr.recipientPhone}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        addr.fullAddress,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 8),
                      if (!isDefault)
                        TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () {
                            locationProvider.updateAddress(addr.copyWith(isDefault: true));
                          },
                          child: const Text('Set as Default Delivery Address'),
                        ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: CustomButton(
            text: 'Add New Address',
            icon: Icons.add_location_alt_rounded,
            onPressed: () => _showAddAddressSheet(context),
          ),
        ),
      ),
    );
  }
}
