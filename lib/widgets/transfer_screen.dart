import 'package:flutter/material.dart';

class TransferView extends StatefulWidget {
  final VoidCallback onBackButtonPressed;
  final String selectedTransferCategory;
  final Function(String) onCategorySelected;
  final List<Map<String, dynamic>> filteredTransfers;

  const TransferView({
    super.key,
    required this.onBackButtonPressed,
    required this.selectedTransferCategory,
    required this.onCategorySelected,
    required this.filteredTransfers,
  });

  @override
  State<TransferView> createState() => _TransferViewState();
}

class _TransferViewState extends State<TransferView> {
  int _currentStep = 0;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    _pinController.dispose();
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
                      "Transfer Points",
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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(22),
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
                "Transfer From",
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9488),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Wallet",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          "\$ 25,000",
                          style: TextStyle(
                            color: Color(0xFF0D9488),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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

              // Amount Field (Added here so user can enter amount)
              const Text(
                "Transfer Amount",
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
                        _currentStep = 1; // Go to PIN step
                      });
                    } else {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   //constSnackBar(content: Text("Please fill phone number and amount")),
                      // );
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
                children: ["All", "Shops", "Teachers", "Students"].map((
                  category,
                ) {
                  bool selected = widget.selectedTransferCategory == category;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => widget.onCategorySelected(category),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
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
                            fontSize: 12,
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
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.filteredTransfers.length,
                separatorBuilder: (context, index) {
                  return const Divider(height: 20, color: Color(0xFFF1F5F9));
                },
                itemBuilder: (context, index) {
                  final transfer = widget.filteredTransfers[index];
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
                      transfer['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    subtitle: Text(
                      transfer['type'],
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                    trailing: Text(
                      transfer['amount'],
                      style: TextStyle(
                        color: transfer['amount'].contains('+')
                            ? const Color(0xFF0D9488)
                            : Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    onTap: () {
                      // Optionally autofill phone or details when clicking recent transfer
                      _phoneController.text = transfer['name'];
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

  // Step 1: PIN Verification & Transfer Button
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
            "Transferring \$${_amountController.text} to +95 ${_phoneController.text}",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
          ),
          const SizedBox(height: 30),

          // PIN Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                letterSpacing: 8,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                hintText: "••••",
                border: InputBorder.none,
                counterText: "",
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Confirm Transfer Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                if (_pinController.text.length >= 4) {
                  setState(() {
                    _currentStep = 2; // Go to Success View
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a valid PIN")),
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
            "Successfully sent \$${_amountController.text} to +95 ${_phoneController.text}",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                // Reset state to go back to main screen or home
                setState(() {
                  _currentStep = 0;
                  _phoneController.clear();
                  _amountController.clear();
                  _pinController.clear();
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
