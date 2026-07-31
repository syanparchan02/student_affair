// screens/create_shop_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_affair/providers/auth_provider.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  // Text Editing Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopPhoneController = TextEditingController();
  final TextEditingController _userPhoneController = TextEditingController();
  final TextEditingController _walletPinController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _shopNameController.dispose();
    _shopPhoneController.dispose();
    _userPhoneController.dispose();
    _walletPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Color(0xFF0F172A),
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ဆိုင်အကောင့်သစ်ဖွင့်မည်",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "အကောင့်သစ်ဖွင့်ရန်အချက်အလက်များဖြည့်ပါ",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ===== BODY =====
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Info Section Card
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1.0,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _buildSection(
                        title: 'အသုံးပြုသူ အချက်အလက်',
                        icon: Icons.person_outline_rounded,
                        children: [
                          _buildInputField(
                            label: 'အမည်',
                            hintText: 'အမည်ရိုက်ထည့်ပါ',
                            prefixIcon: Icons.person_outline_rounded,
                            controller: _nameController,
                          ),
                          _buildInputField(
                            label: 'Email',
                            hintText: 'example@mail.com',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            controller: _emailController,
                          ),
                          _buildInputField(
                            label: 'Password',
                            hintText: '••••••••',
                            obscureText: true,
                            prefixIcon: Icons.lock_outline_rounded,
                            controller: _passwordController,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20.0),

                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1.0,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _buildSection(
                        title: 'ဆိုင် အချက်အလက်',
                        icon: Icons.store_rounded,
                        children: [
                          _buildInputField(
                            label: 'ဆိုင်အမည်',
                            hintText: 'ဆိုင်နာမည် ရိုက်ထည့်ပါ',
                            prefixIcon: Icons.storefront_rounded,
                            controller: _shopNameController,
                          ),
                          _buildInputField(
                            label: 'ဆိုင်ဖုန်းနံပါတ်',
                            hintText: '09xxxxxxxxx',
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icons.phone_android_rounded,
                            controller: _shopPhoneController,
                          ),
                          _buildInputField(
                            label: 'အသုံးပြုသူဖုန်းနံပါတ်',
                            hintText: '09xxxxxxxxx',
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icons.person_outline_rounded,
                            controller: _userPhoneController,
                          ),
                          _buildInputField(
                            label: 'Wallet PIN (6 digits)',
                            hintText: '123456',
                            obscureText: true,
                            maxLength: 6,
                            textAlign: TextAlign.center,
                            letterSpacing: 5.0,
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.pin_rounded,
                            controller: _walletPinController,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28.0),

                    // Error Message
                    if (authState.errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                authState.errorMessage!,
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Submit Button with gradient
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0D9488).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: authState.isLoading
                            ? null
                            : () async {
                                // Validate fields
                                if (_nameController.text.isEmpty ||
                                    _emailController.text.isEmpty ||
                                    _passwordController.text.isEmpty ||
                                    _shopNameController.text.isEmpty ||
                                    _shopPhoneController.text.isEmpty ||
                                    _userPhoneController.text.isEmpty ||
                                    _walletPinController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.warning_rounded,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "အချက်အလက်အားလုံးကို ဖြည့်သွင်းပါ။",
                                          ),
                                        ],
                                      ),
                                      backgroundColor: Color(0xFFF59E0B),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                // Validate wallet pin
                                if (_walletPinController.text.length != 6) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.warning_rounded,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Wallet PIN သည် ဂဏန်း ၆ လုံးဖြစ်ရမည်။",
                                          ),
                                        ],
                                      ),
                                      backgroundColor: Color(0xFFF59E0B),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                // Call register API
                                final success = await ref
                                    .read(authProvider.notifier)
                                    .registerShop(
                                      userName: _nameController.text.trim(),
                                      userEmail: _emailController.text.trim(),
                                      userPassword: _passwordController.text
                                          .trim(),
                                      shopName: _shopNameController.text.trim(),
                                      shopPhone: _shopPhoneController.text
                                          .trim(),
                                      userPhone: _userPhoneController.text
                                          .trim(),
                                      walletPin: _walletPinController.text
                                          .trim(),
                                    );

                                if (success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle_rounded,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "အကောင့်သစ် အောင်မြင်စွာ ဖွင့်လှစ်ပြီးပါပြီ။",
                                          ),
                                        ],
                                      ),
                                      backgroundColor: Color(0xFF0D9488),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        child: authState.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.app_registration_rounded,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text('မှတ်ပုံတင်မည်'),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 50.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF0D9488).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF0D9488), size: 16),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                letterSpacing: 0.3,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Required',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Column(
          children: children
              .map(
                (widget) => Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: widget,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    int? maxLength,
    TextAlign textAlign = TextAlign.start,
    double? letterSpacing,
    IconData? prefixIcon,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6.0),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLength: maxLength,
          textAlign: textAlign,
          style: TextStyle(
            letterSpacing: letterSpacing,
            fontSize: 14,
            color: const Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 14.0,
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: const Color(0xFF94A3B8), size: 20)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
              borderSide: const BorderSide(
                color: Color(0xFF0D9488),
                width: 1.5,
              ),
            ),
            counterText: '',
          ),
        ),
      ],
    );
  }
}
