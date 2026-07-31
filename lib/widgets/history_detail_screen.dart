import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FullScreenDetailView extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isTransfer;

  const FullScreenDetailView({
    super.key,
    required this.item,
    required this.isTransfer,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPositive = isTransfer ? (item['isPositive'] ?? false) : true;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0F172A),
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'အသေးစိတ် အချက်အလက်',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Header Amount & Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF64748B).withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isPositive
                            ? [const Color(0xFFD1FAE5), const Color(0xFFA7F3D0)]
                            : [
                                const Color(0xFFFFE4E6),
                                const Color(0xFFFECDD3),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isTransfer
                          ? (isPositive
                                ? Icons.arrow_downward_rounded
                                : Icons.arrow_upward_rounded)
                          : Icons.currency_exchange_rounded,
                      color: isPositive
                          ? const Color(0xFF0D9488)
                          : const Color(0xFFDC2626),
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isTransfer ? item['amount'] : item['toAmount'],
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: isPositive
                          ? const Color(0xFF0D9488)
                          : const Color(0xFFDC2626),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item['status'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Info Details Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF64748B).withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'အချက်အလက် အသေးစိတ်',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    'လုပ်ဆောင်ချက်အမျိုးအစား',
                    item['type'] ?? '-',
                  ),
                  const Divider(height: 24, color: Color(0xFFF1F5F9)),
                  _buildDetailRow('လုပ်ဆောင်ချက် ID', item['id']),
                  const Divider(height: 24, color: Color(0xFFF1F5F9)),
                  _buildDetailRow('အချိန်အတိအကျ', item['date']),
                  const Divider(height: 24, color: Color(0xFFF1F5F9)),
                  if (isTransfer) ...[
                    _buildDetailRow(
                      'အကောင့်အမျိုးအစား',
                      item['accountNo'] ?? 'Main Wallet',
                    ),
                    const Divider(height: 24, color: Color(0xFFF1F5F9)),
                    _buildDetailRow('ဝန်ဆောင်ခ (Fee)', item['fee'] ?? 'အခမဲ့'),
                  ] else ...[
                    _buildDetailRow('ပေးပို့ငွေ', item['fromAmount']),
                    const Divider(height: 24, color: Color(0xFFF1F5F9)),
                    _buildDetailRow('လဲလှယ်နှုန်း', item['rate']),
                    const Divider(height: 24, color: Color(0xFFF1F5F9)),
                    _buildDetailRow('ဝန်ဆောင်ခ', item['serviceFee'] ?? '0 MMK'),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'နောက်သို့',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13.5,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13.5,
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
