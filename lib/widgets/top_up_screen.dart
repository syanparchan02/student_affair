import 'package:flutter/material.dart';
import 'package:student_affair/service/api_service.dart';

class TransferView extends StatefulWidget {
  final VoidCallback onBackButtonPressed;
  final String selectedTransferCategory;
  final Function(String) onCategorySelected;
  final List<Map<String, dynamic>> filteredTransfers;
  final String? initialPhone;

  const TransferView({
    super.key,
    required this.onBackButtonPressed,
    required this.selectedTransferCategory,
    required this.onCategorySelected,
    required this.filteredTransfers,
    this.initialPhone,
  });

  @override
  State<TransferView> createState() => _TransferViewState();
}

class _TransferViewState extends State<TransferView> {
  int _currentStep = 0;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // ၆ လုံးအတွက် Controllers များနှင့် FocusNodes များ (Pinput ပုံစံအတွက်)
  final List<TextEditingController> _pinControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _pinFocusNodes = List.generate(6, (_) => FocusNode());

  // API ခေါ်နေစဉ် Loading ဖြစ်နေသည်ကို ပြသရန် variable
  bool _isLoading = false;

  // API မှ ရလာမည့် History ဒေတာများကို သိမ်းရန်
  bool _isHistoryLoading = true;
  List<Map<String, dynamic>> _apiTransfers = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialPhone != null && widget.initialPhone!.isNotEmpty) {
      _phoneController.text = widget.initialPhone!;
    }
    _fetchTransferHistory();
  }

  // API ဖြင့် Recent Transfers များကို လှမ်းခေါ်သည့် Method
  Future<void> _fetchTransferHistory() async {
    try {
      final data = await ApiService().getAllHistory();
      setState(() {
        _apiTransfers = List<Map<String, dynamic>>.from(data);
        _isHistoryLoading = false;
      });
    } catch (e) {
      setState(() {
        _isHistoryLoading = false;
      });
      _showCustomSnackBar(
        message: "Failed to load history: ${e.toString()}",
        icon: Icons.error_outline_rounded,
        backgroundColor: const Color(0xFFEF4444),
      );
    }
  }

  // SnackBar ကို လှပစေရန် helper method
  void _showCustomSnackBar({
    required String message,
    required IconData icon,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        elevation: 6,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    for (var controller in _pinControllers) {
      controller.dispose();
    }
    for (var node in _pinFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<int>(1),
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          // App Header
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
                    if (_currentStep > 0)
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                        onPressed: () {
                          setState(() {
                            _currentStep--;
                          });
                        },
                      ),
                    const Text(
                      "Top Up Points",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.history_rounded,
                      color: Color(0xFF0D9488),
                      size: 20,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          // Body Content based on steps
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
              child: _currentStep == 0
                  ? _buildTransferInputView()
                  : _currentStep == 1
                  ? _buildPinVerificationView()
                  : _buildSuccessView(),
            ),
          ),
        ],
      ),
    );
  }

  // Step 0: Phone Number, Amount & Recent Transfers
  Widget _buildTransferInputView() {
    List<Map<String, dynamic>> displayedTransfers = _apiTransfers.where((
      transfer,
    ) {
      final role = transfer['role_name']?.toString().toLowerCase() ?? '';
      if (widget.selectedTransferCategory == "Students") {
        return role == 'student';
      } else if (widget.selectedTransferCategory == "Teachers") {
        return role == 'teacher';
      } else if (widget.selectedTransferCategory == "Shop") {
        return role == 'shop';
      }
      return true;
    }).toList();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 22,
            top: 0,
            right: 22,
            bottom: 22,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF64748B).withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Phone Number Field
              const Text(
                "Recipient Phone Number",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Text(
                      "+95",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: "Enter phone number",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Amount Field
              const Text(
                "Transfer Amount Point",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Text(
                      "\$",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D9488),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "0.00",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_phoneController.text.isNotEmpty &&
                        _amountController.text.isNotEmpty) {
                      setState(() {
                        _currentStep = 1;
                      });
                    } else {
                      _showCustomSnackBar(
                        message: "Please fill phone number and amount",
                        icon: Icons.error_outline_rounded,
                        backgroundColor: const Color(0xFFEF4444),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Recent Transfers Section
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF64748B).withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Recent Transfers",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: ["All", "Students", "Teachers", "Shop"].map((
                  category,
                ) {
                  bool selected = widget.selectedTransferCategory == category;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => widget.onCategorySelected(category),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFF0D9488)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          category,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? Colors.white
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              _isHistoryLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(
                          color: Color(0xFF0D9488),
                        ),
                      ),
                    )
                  : displayedTransfers.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "No transfer history found",
                          style: TextStyle(color: Color(0xFF64748B)),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayedTransfers.length,
                      separatorBuilder: (context, index) {
                        return const Divider(
                          height: 20,
                          color: Color(0xFFF1F5F9),
                        );
                      },
                      itemBuilder: (context, index) {
                        final transfer = displayedTransfers[index];

                        final name = transfer['user_name']?.toString() ?? '';
                        final roleName =
                            transfer['role_name']?.toString() ?? '';
                        final amount = transfer['amount']?.toString() ?? '';
                        final date = transfer['date']?.toString() ?? '';
                        final phone = transfer['user_phone']?.toString() ?? '';

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xFFF1F5F9),
                            child: Icon(
                              Icons.person,
                              color: Color(0xFF0D9488),
                              size: 20,
                            ),
                          ),
                          title: Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          subtitle: Text(
                            " $date",
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 11,
                            ),
                          ),
                          trailing: Text(
                            amount,
                            style: TextStyle(
                              color: amount.contains('+')
                                  ? const Color(0xFF0D9488)
                                  : Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          onTap: () {
                            _phoneController.text = phone;
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ],
    );
  }

  // Step 1: PIN Verification (6 Digits Individual Boxes) & Confirm Transfer Button
  Widget _buildPinVerificationView() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            size: 48,
            color: Color(0xFF0D9488),
          ),
          const SizedBox(height: 16),
          const Text(
            "Enter Security PIN",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Transferring point ${_amountController.text} to ${_phoneController.text}",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
          ),
          const SizedBox(height: 30),

          // 6-Digit Individual Pinput Boxes (Logic မပြောင်းဘဲ ပုံစံအသစ်ဖြင့်)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              return SizedBox(
                width: 42,
                height: 50,
                child: TextField(
                  controller: _pinControllers[index],
                  focusNode: _pinFocusNodes[index],
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF0D9488),
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty && index < 5) {
                      _pinFocusNodes[index + 1].requestFocus();
                    } else if (value.isEmpty && index > 0) {
                      _pinFocusNodes[index - 1].requestFocus();
                    }
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 30),

          // Confirm Transfer Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      // controllers ခြောက်ခုမှ pin များကို ပေါင်းယူခြင်း
                      String fullPin = _pinControllers
                          .map((c) => c.text)
                          .join();

                      if (fullPin.length == 6) {
                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          double amountValue =
                              double.tryParse(_amountController.text) ?? 0.0;

                          await ApiService().topupByPhone(
                            phone: _phoneController.text,
                            amount: amountValue,
                            pin: fullPin,
                          );

                          setState(() {
                            _currentStep = 2;
                          });

                          _showCustomSnackBar(
                            message: "Transfer successful!",
                            icon: Icons.check_circle_rounded,
                            backgroundColor: const Color(0xFF10B981),
                          );

                          _fetchTransferHistory();
                        } catch (e) {
                          _showCustomSnackBar(
                            message: e.toString(),
                            icon: Icons.error_outline_rounded,
                            backgroundColor: const Color(0xFFEF4444),
                          );
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      } else {
                        _showCustomSnackBar(
                          message: "Please enter a valid PIN",
                          icon: Icons.warning_amber_rounded,
                          backgroundColor: const Color(0xFFF59E0B),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      "Confirm Transfer",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Step 2: Success Screen
  Widget _buildSuccessView() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFF0FDF4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              size: 60,
              color: Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Transfer Successful!",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Successfully sent ${_amountController.text} Points to ${_phoneController.text}",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentStep = 0;
                  _phoneController.clear();
                  _amountController.clear();
                  for (var controller in _pinControllers) {
                    controller.clear();
                  }
                });
                widget.onBackButtonPressed();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Done",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
