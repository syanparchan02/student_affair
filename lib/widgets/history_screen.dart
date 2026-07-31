import 'package:flutter/material.dart';
import 'package:student_affair/widgets/history_detail_screen.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

 
  String _selectedMonth = 'June 2026';


  final List<Map<String, String>> _months = [
    {'title': 'June 2026', 'subtitle': 'လက်ရှိလ'},
    {'title': 'May 2026', 'subtitle': 'ပြီးခဲ့သောလ'},
    {'title': 'April 2026', 'subtitle': '၃ လပိုင်း'},
  ];

  final List<Map<String, dynamic>> _transferHistory = [
    {
      'title': 'Wai Wai Aung (Shops)',
      'date': '29 Jun 2026, 04:15 PM',
      'amount': '- \$20.00',
      'numericAmount': -20.0,
      'isPositive': false,
      'status': 'အောင်မြင်သည်',
      'id': 'TRX-98231',
      'type': 'ငွေလွှဲပေးမှု',
      'fee': '\$0.50',
      'accountNo': 'KBZPay • *** 4210',
    },
    {
      'title': 'Daw Myat Su Nyi (Students)',
      'date': '28 Jun 2026, 11:30 AM',
      'amount': '+ \$10.00',
      'numericAmount': 10.0,
      'isPositive': true,
      'status': 'အောင်မြင်သည်',
      'id': 'TRX-98210',
      'type': 'ငွေလက်ခံရရှိမှု',
      'fee': 'အခမဲ့',
      'accountNo': 'WaveMoney • *** 8892',
    },
    {
      'title': 'THEIN AUNG (Shops)',
      'date': '27 Jun 2026, 09:45 AM',
      'amount': '- \$30.00',
      'numericAmount': -30.0,
      'isPositive': false,
      'status': 'အောင်မြင်သည်',
      'id': 'TRX-98155',
      'type': 'ငွေလွှဲပေးမှု ',
      'fee': '\$1.00',
      'accountNo': 'CB Bank • *** 1102',
    },
    {
      'title': 'PWINT NADI HLAING (Teachers)',
      'date': '25 Jun 2026, 02:20 PM',
      'amount': '- \$12.00',
      'numericAmount': -12.0,
      'isPositive': false,
      'status': 'စောင့်ဆိုင်းဆဲ',
      'id': 'TRX-98042',
      'type': 'ငွေလွှဲပေးမှု ',
      'fee': '\$0.30',
      'accountNo': 'AYA Pay • *** 5543',
    },
  ];

  final List<Map<String, dynamic>> _exchangeHistory = [
    {
      'title': 'MMK ကျပ်မှ USD ဒေါ်လာသို့',
      'date': '29 Jun 2026, 01:10 PM',
      'fromAmount': '21,000 MMK',
      'toAmount': '\$10.00 USD',
      'rate': 'Rate: 2,100.\$',
      'status': 'ပြီးမြောက်သည်',
      'id': 'EXC-43102',
      'type': 'ငွေလဲလှယ်မှု',
      'serviceFee': '0 MMK',
    },
    {
      'title': 'USD ဒေါ်လာမှ MMK ကျပ်သို့',
      'date': '26 Jun 2026, 10:05 AM',
      'fromAmount': '\$50.00 USD',
      'toAmount': '105,000 MMK',
      'rate': 'Rate: 2,100.0 MMK/\$',
      'status': 'ပြီးမြောက်သည်',
      'id': 'EXC-43019',
      'type': 'ငွေလဲလှယ်မှု',
      'serviceFee': '0 MMK',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double get _totalInflow {
    return _transferHistory
        .where((item) => item['isPositive'] == true)
        .fold(
          0.0,
          (sum, item) =>
              sum + ((item['numericAmount'] as num?)?.toDouble() ?? 0.0),
        );
  }

  double get _totalOutflow {
    return _transferHistory
        .where((item) => item['isPositive'] == false)
        .fold(
          0.0,
          (sum, item) =>
              sum + ((item['numericAmount'] as num?)?.toDouble().abs() ?? 0.0),
        );
  }


  void _openDetailScreen(Map<String, dynamic> item, {bool isTransfer = true}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FullScreenDetailView(item: item, isTransfer: isTransfer),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<int>(4),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'မှတ်တမ်းများ (History)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 14),

               
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _months.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final m = _months[index];
                      final bool isSelected = _selectedMonth == m['title'];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMonth = m['title']!;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF0D9488)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF0D9488)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                size: 14,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                m['title']!,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF475569),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

               
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ဝင်ငွေ (Inflow)',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '+ \$${_totalInflow.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0D9488),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 1,
                        color: const Color(0xFFCBD5E1),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ထွက်ငွေ (Outflow)',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '- \$${_totalOutflow.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFDC2626),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Container(
                  height: 48,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: const Color(0xFF0D9488),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0D9488).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: const Color(0xFF64748B),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    tabs: const [
                      Tab(
                        child: SizedBox(
                          width: double.infinity,
                          child: Center(child: Text('ငွေလွှဲမှတ်တမ်း')),
                        ),
                      ),
                      Tab(
                        child: SizedBox(
                          width: double.infinity,
                          child: Center(child: Text('ငွေလဲလှယ်မှု')),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTransferHistoryList(),
                _buildExchangeHistoryList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: _transferHistory.length,
      itemBuilder: (context, index) {
        final item = _transferHistory[index];
        final bool isPositive = item['isPositive'];
        final bool isPending = item['status'] == 'စောင့်ဆိုင်းဆဲ';

        return Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF64748B).withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(20.0),
              onTap: () => _openDetailScreen(item, isTransfer: true),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isPositive
                              ? [
                                  const Color(0xFFD1FAE5),
                                  const Color(0xFFA7F3D0),
                                ]
                              : [
                                  const Color(0xFFFFE4E6),
                                  const Color(0xFFFECDD3),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        isPositive
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: isPositive
                            ? const Color(0xFF0D9488)
                            : const Color(0xFFDC2626),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                item['id'],
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0D9488),
                                ),
                              ),
                              const Text(
                                ' • ',
                                style: TextStyle(color: Color(0xFFCBD5E1)),
                              ),
                              Expanded(
                                child: Text(
                                  item['date'],
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item['amount'],
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: isPositive
                                ? const Color(0xFF0D9488)
                                : const Color(0xFFDC2626),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isPending
                                ? const Color(0xFFFEF3C7)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item['status'],
                            style: TextStyle(
                              fontSize: 10,
                              color: isPending
                                  ? const Color(0xFFD97706)
                                  : const Color(0xFF475569),
                              fontWeight: FontWeight.w700,
                            ),
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
      },
    );
  }

  Widget _buildExchangeHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: _exchangeHistory.length,
      itemBuilder: (context, index) {
        final item = _exchangeHistory[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF64748B).withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(20.0),
              onTap: () => _openDetailScreen(item, isTransfer: false),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.currency_exchange_rounded,
                        color: Color(0xFF0284C7),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                item['rate'],
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0284C7),
                                ),
                              ),
                              const Text(
                                ' • ',
                                style: TextStyle(color: Color(0xFFCBD5E1)),
                              ),
                              Expanded(
                                child: Text(
                                  item['date'],
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item['fromAmount'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 12,
                              color: Color(0xFF0D9488),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item['toAmount'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13.5,
                                color: Color(0xFF0D9488),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

