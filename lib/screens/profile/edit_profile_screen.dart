import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/validators.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    _nameController = TextEditingController(text: auth.user?.name ?? '');
    _phoneController = TextEditingController(text: auth.user?.phone ?? '');
    _emailController = TextEditingController(text: auth.user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.updateProfile(
      _nameController.text.trim(),
      _phoneController.text.trim(),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          auth.user != null && auth.user!.name.isNotEmpty
                              ? auth.user!.name.substring(0, 1).toUpperCase()
                              : 'U',
                          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryDark,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  prefixIcon: Icons.person_outline,
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _phoneController,
                  label: 'Mobile Number',
                  prefixIcon: Icons.phone_android_rounded,
                  keyboardType: TextInputType.phone,
                  validator: Validators.validatePhone,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  label: 'Email (Primary Account)',
                  prefixIcon: Icons.email_outlined,
                  readOnly: true,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Save Changes',
                  isLoading: auth.isLoading,
                  onPressed: _saveProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
