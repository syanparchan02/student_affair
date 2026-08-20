import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:student_affair/service/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'All';
  bool loading = true;
  List<Map<String, dynamic>> _allItems = [];

  double _totalTopUpAmount = 0.0;
  double _totalExchangeAmount = 0.0;
  String _selectedPeriod = '';

  PreferredSizeWidget _buildCustomAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70.0),
      child: Container(
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
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'မှတ်တမ်းများကြည့်ရန်',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      final response = await ApiService().getMonthlySummary();
      final data = response['data'];
      final totals = data['totals'];

      List<Map<String, dynamic>> temp = [];

      for (var item in data['top_up_list']) {
        bool isShop = item['role'] == 'shop';
        String roleText = isShop ? 'ဆိုင်ရှင်' : 'ကျောင်းသား/သူ';
        String shopName = item['shop_name'] ?? '';
        String userName = item['user_name'] ?? '';
        String displayName = isShop && shopName.isNotEmpty
            ? '$shopName ($userName)'
            : userName;

        temp.add({
          'transaction_id': item['transaction_id'],
          'user_id': item['user_id'],
          'user_name': userName,
          'shop_name': shopName,
          'display_name': displayName,
          'user_phone': item['user_phone'],
          'role': roleText,
          'raw_role': item['role'],
          'title': 'ပွိုင့်ဖြည့်သွင်းခြင်း',
          'date': item['date'],
          'time': item['time'],
          'amount': "+ ${item['amount']}",
          'numericAmount': (item['amount'] as num).toDouble(),
          'category': 'TopUp',
          'isTopUp': true,
          'month': data['selected_period'],
          'status': item['status'],
          'raw_amount': item['amount'],
        });
      }

      for (var item in data['exchange_list']) {
        bool isShop = item['role'] == 'shop';
        String roleText = isShop ? 'ဆိုင်ရှင်' : 'ကျောင်းသား/သူ';
        String shopName = item['shop_name'] ?? '';
        String userName = item['user_name'] ?? '';
        String displayName = isShop && shopName.isNotEmpty
            ? '$shopName ($userName)'
            : userName;

        temp.add({
          'transaction_id': item['transaction_id'],
          'user_id': item['user_id'],
          'user_name': userName,
          'shop_name': shopName,
          'display_name': displayName,
          'user_phone': item['user_phone'],
          'role': roleText,
          'raw_role': item['role'],
          'title': 'ငွေလဲလှယ်ခြင်း',
          'date': item['date'],
          'time': item['time'],
          'amount': "- ${item['exchange_amount']}",
          'numericAmount': (item['exchange_amount'] as num).toDouble(),
          'received_amount': item['received_amount'],
          'category': 'Withdraw',
          'isTopUp': false,
          'month': data['selected_period'],
          'status': item['status'],
          'raw_amount': item['exchange_amount'],
        });
      }

      setState(() {
        _allItems = temp;
        _totalTopUpAmount = (totals['top_up']['amount'] as num).toDouble();
        _totalExchangeAmount = (totals['exchange']['exchange_amount'] as num)
            .toDouble();
        _selectedPeriod = data['selected_period'] ?? '';
        loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _selectedFilter == 'All'
        ? _allItems
        : _allItems
              .where((item) => item['category'] == _selectedFilter)
              .toList();

    double displayInflow = 0.0;
    double displayOutflow = 0.0;

    if (_selectedFilter == 'All') {
      displayInflow = _totalTopUpAmount;
      displayOutflow = _totalExchangeAmount;
    } else if (_selectedFilter == 'TopUp') {
      displayInflow = _totalTopUpAmount;
      displayOutflow = 0.0;
    } else if (_selectedFilter == 'Withdraw') {
      displayInflow = 0.0;
      displayOutflow = _totalExchangeAmount;
    }

    final monthItems = filteredItems
        .where((item) => item['month'] == _selectedPeriod)
        .toList();

    return Scaffold(
      appBar: _buildCustomAppBar(),
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0).withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _buildFilterTab('အားလုံး', 'All'),
                  _buildFilterTab('ပွိုင့်ဖြည့်', 'TopUp'),
                  _buildFilterTab('ငွေထုတ်', 'Withdraw'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xff0D6B80)),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    children: [
                      if (_selectedPeriod.isNotEmpty) ...[
                        MonthCard(
                          month: _selectedPeriod,
                          inflow: displayInflow.toStringAsFixed(2),
                          outflow: displayOutflow == 0
                              ? "0.00"
                              : "-${displayOutflow.toStringAsFixed(2)}",
                          items: monthItems,
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (filteredItems.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 60),
                          child: Center(
                            child: Text(
                              'မှတ်တမ်း မရှိသေးပါ။',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, String value) {
    bool isSelected = _selectedFilter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = value;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xff0D6B80) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xff0D6B80).withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }
}

class MonthCard extends StatelessWidget {
  final String month;
  final String inflow;
  final String outflow;
  final List<Map<String, dynamic>> items;

  const MonthCard({
    super.key,
    required this.month,
    required this.inflow,
    required this.outflow,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 170, 192, 198),
                  Color.fromARGB(255, 150, 199, 211),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  month,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "ပွိုင့်ဖြည့်ပမာဏ",
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$inflow ပွိုင့်",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "ငွေထုတ်ပမာဏ",
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$outflow ကျပ်",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: items.asMap().entries.map((entry) {
                int index = entry.key;
                var item = entry.value;
                bool isLast = index == items.length - 1;

                return TransactionRow(itemData: item, showBorder: !isLast);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionRow extends StatelessWidget {
  final Map<String, dynamic> itemData;
  final bool showBorder;

  const TransactionRow({
    super.key,
    required this.itemData,
    required this.showBorder,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailScreen(itemData: itemData),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: showBorder
              ? const Border(bottom: BorderSide(color: Color(0xFFF1F5F9)))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_outward_rounded,
                color: Color(0xFF0D9488),
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemData['display_name'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 4,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 11,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            itemData['date'],
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 11,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            itemData['time'],
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
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
            const SizedBox(width: 8),
            Text(
              itemData['amount'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0D9488),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionDetailScreen extends StatelessWidget {
  final Map<String, dynamic> itemData;

  const TransactionDetailScreen({super.key, required this.itemData});

  @override
  Widget build(BuildContext context) {
    bool isTopUp = itemData['isTopUp'];
    bool isShop = itemData['raw_role'] == 'shop';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Color(0xFF0F172A),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ငွေစာရင်း အသေးစိတ်',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF64748B).withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0FDFA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_outward_rounded,
                  color: Color(0xFF0D9488),
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                itemData['title'],
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                itemData['amount'],
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'ID: #${itemData['transaction_id']}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(color: Color(0xFFF1F5F9), height: 1),
              const SizedBox(height: 10),
              _buildDetailRow('အမည်', '${itemData['user_name']}'),
              if (isShop &&
                  itemData['shop_name'] != null &&
                  itemData['shop_name'].toString().isNotEmpty)
                _buildDetailRow('ဆိုင်နာမည်', '${itemData['shop_name']}'),
              _buildDetailRow('ဖုန်းနံပါတ်', '${itemData['user_phone']}'),
              _buildDetailRow('အမျိုးအစား', '${itemData['role']}'),
              if (!isTopUp && itemData['received_amount'] != null)
                _buildDetailRow(
                  'လက်ခံရရှိငွေ',
                  '${itemData['received_amount']} ကျပ်',
                ),
              _buildDetailRow('အခြေအနေ', '${itemData['status']}'),
              _buildDetailRow('ရက်စွဲ', '${itemData['date']}'),
              _buildDetailRow('အချိန်', '${itemData['time']}', isLast: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
