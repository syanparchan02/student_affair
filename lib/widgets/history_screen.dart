import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _allItems = [
    {
      'title': 'KBZPay မှ ပွိုင့်ဖြည့်သွင်းခြင်း',
      'date': 'Today 09:50:16',
      'amount': '+ 10,000.00',
      'category': 'TopUp',
      'isTopUp': true,
      'month': 'August - 2026',
    },
    {
      'title': 'CB Bank သို့ ငွေထုတ်ယူခြင်း',
      'date': 'Today 09:29:12',
      'amount': '- 7,500.00',
      'category': 'Withdraw',
      'isTopUp': false,
      'month': 'August - 2026',
    },
    {
      'title': 'WaveMoney ဖြင့် ပွိုင့်ဖြည့်ခြင်း',
      'date': '01/08 15:57:43',
      'amount': '+ 3,100.00',
      'category': 'TopUp',
      'isTopUp': true,
      'month': 'August - 2026',
    },
    {
      'title': 'AYA Pay သို့ ငွေထုတ်ယူခြင်း',
      'date': '31/07 10:20:10',
      'amount': '- 50,000.00',
      'category': 'Withdraw',
      'isTopUp': false,
      'month': 'July - 2026',
    },
  ];

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
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDFA),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF99F6E4),
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.history_rounded,
                            color: Color(0xFF0D9488),
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'History',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'ငွေသွင်း/ငွေထုတ် မှတ်တမ်းများ',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF0D9488),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFBFDBFE),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.notifications_rounded,
                              size: 20,
                              color: Color(0xFF2563EB),
                            ),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFECACA),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.logout_rounded,
                          size: 20,
                          color: Color(0xFFDC2626),
                        ),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _selectedFilter == 'All'
        ? _allItems
        : _allItems
              .where((item) => item['category'] == _selectedFilter)
              .toList();

    final augustItems = filteredItems
        .where((item) => item['month'] == 'August - 2026')
        .toList();
    final julyItems = filteredItems
        .where((item) => item['month'] == 'July - 2026')
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
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              children: [
                if (augustItems.isNotEmpty) ...[
                  MonthCard(
                    month: "August - 2026",
                    inflow: "13,100.00",
                    outflow: "-21,500.00",
                    items: augustItems,
                  ),
                  const SizedBox(height: 16),
                ],
                if (julyItems.isNotEmpty) ...[
                  MonthCard(
                    month: "July - 2026",
                    inflow: "791,950.00",
                    outflow: "-967,020.00",
                    items: julyItems,
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
            color: isSelected ? const Color(0xFF0D9488) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF0D9488).withOpacity(0.25),
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
                colors: [Color(0xFFE0F2FE), Color(0xFFF0F9FF)],
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
                          "Inflow",
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$inflow (Ks)",
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
                          "Outflow",
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$outflow (Ks)",
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

                return TransactionRow(
                  title: item['title'],
                  date: item['date'],
                  amount: item['amount'],
                  isTopUp: item['isTopUp'],
                  showBorder: !isLast,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionRow extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final bool isTopUp;
  final bool showBorder;

  const TransactionRow({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.isTopUp,
    required this.showBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(bottom: BorderSide(color: Color(0xFFF1F5F9)))
            : null,
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isTopUp
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: isTopUp
                  ? const Color(0xFF0D9488)
                  : const Color(0xFF64748B),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isTopUp
                  ? const Color(0xFF0D9488)
                  : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
