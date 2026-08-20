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

  final List<TextEditingController> _pinControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _pinFocusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;

  bool _isHistoryLoading = true;
  List<Map<String, dynamic>> _apiTransfers = [];
  String _formattedTotalPoints = "0 pts";

  @override
  void initState() {
    super.initState();
    if (widget.initialPhone != null && widget.initialPhone!.isNotEmpty) {
      _phoneController.text = widget.initialPhone!;
    }
    _fetchTransferHistory();
  }

  Future<void> _fetchTransferHistory() async {
    try {
      final response = await ApiService().getAllHistory();

      final summary = response['summary'] ?? {};
      final data = response['data'] ?? [];

      setState(() {
        _apiTransfers = List<Map<String, dynamic>>.from(data);
        _formattedTotalPoints =
            summary['formatted_total_points']?.toString() ?? "0 pts";
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
                      const Text(
                        "ပွိုင့်များဖြည့်ရန်",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff0D6B80), Color(0xff0D6B80)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(0xff0D6B80).withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.analytics_rounded, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "ဒီနေ့ပွိုင့်ဖြည့်",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "စုစုပေါင်း",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _formattedTotalPoints,
                  style: const TextStyle(
                    color: Color(0xFF0D9488),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
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

              const Text(
                "လက်ခံမည့်ဖုန်းနံပါတ်",
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
                          hintText: "09xxxxxxx",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                "ဖြည့်သွင်းမည့်ပွိုင့်ပမာဏ",
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
                    backgroundColor: Color(0xff0D6B80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "ဆက်သွားမည်",
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
                "လတ်တလောပွိုင့်ဖြည့်သွင်းထားမှုများ",
                style: TextStyle(
                  fontSize: 16,
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
                              ? Color(0xff0D6B80)
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
                          color: Color(0xff0D6B80),
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
                              color: Color(0xff0D6B80),
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
                                  ? Color(0xff0D6B80)
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
            color: Color(0xff0D6B80),
          ),
          const SizedBox(height: 16),
          const Text(
            "Pinနံပါတ်ရိုက်ထည့်ပါ",
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
                        color: Color(0xff0D6B80),
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

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
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
                backgroundColor: Color(0xff0D6B80),
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
                      "အတည်ပြုမည်",
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
              color: Color(0xff0D6B80),
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
                backgroundColor: Color(0xff0D6B80),
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
