import 'package:flutter/material.dart';

import 'package:student_affair/models/shop_model.dart';
import 'package:student_affair/screens/QrScan_screen.dart';
import 'package:student_affair/service/api_service.dart';
import 'package:student_affair/widgets/withdraw_screen.dart';

import '../widgets/shop_list_screen.dart';
import '../widgets/transfer_screen.dart';
import '../widgets/setting_screen.dart';
import '../widgets/history_screen.dart';

class RestaurantAdminDashboardScreen extends StatefulWidget {
  const RestaurantAdminDashboardScreen({super.key});

  @override
  State<RestaurantAdminDashboardScreen> createState() =>
      _RestaurantAdminDashboardScreenState();
}

class _RestaurantAdminDashboardScreenState
    extends State<RestaurantAdminDashboardScreen> {
  final ApiService _apiService = ApiService();

  int _currentIndex = 0;
  String _selectedTransferCategory = "All";

  bool _isLoading = true;
  List<Shop> _allShops = [];
  List<Shop> _filteredShops = [];
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _recentTransfersWithMore = [
    {'name': 'Wai Wai Aung', 'type': 'Shops', 'amount': '- \$20'},
    {'name': 'San Thidar Hlaing', 'type': 'Shops', 'amount': '- \$15'},
    {'name': 'THEIN AUNG', 'type': 'Shops', 'amount': '- \$30'},
    {'name': 'U Aung Soe Moe', 'type': 'Other', 'amount': '- \$25'},
    {'name': 'Daw Myat Su Nyi', 'type': 'Students', 'amount': '+ \$10'},
    {'name': 'Ma Win Myat Thu', 'type': 'Shops', 'amount': '- \$18'},
    {'name': 'THAN THAN SOE', 'type': 'Other', 'amount': '+ \$22'},
    {'name': 'DAW THI THI MON', 'type': 'Shops', 'amount': '- \$35'},
    {'name': 'PWINT NADI HLAING', 'type': 'Teachers', 'amount': '- \$12'},
    {'name': 'PWINT NADI HLAING', 'type': 'Teachers', 'amount': '- \$12'},
  ];

  List<Map<String, dynamic>> get filteredTransfers {
    if (_selectedTransferCategory == "All") {
      return _recentTransfersWithMore;
    }
    return _recentTransfersWithMore
        .where((item) => item['type'] == _selectedTransferCategory)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchShopsData();
    _searchController.addListener(_filterShops);
  }

  Future<void> _fetchShopsData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedData = await _apiService.fetchAdminShopMenus();
      setState(() {
        _allShops = fetchedData.map((json) => Shop.fromJson(json)).toList();
        _filteredShops = _allShops;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterShops() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredShops = _allShops.where((shop) {
        return (shop.shopName ?? '').toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        resizeToAvoidBottomInset: false,
        appBar: _currentIndex == 0 ? _buildCustomAppBar() : null,
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.teal))
            : Stack(
                children: [
                  Positioned.fill(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _getSelectedScreen(),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _buildBottomNavBar(),
                  ),
                ],
              ),
      ),
    );
  }

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
                            Icons.restaurant_menu_rounded,
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
                              'ကျောင်းသားရေးရာဌာန',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'စီမံခန့်ခွဲရေးဝန်ထမ်း',
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

  Widget _getSelectedScreen() {
    switch (_currentIndex) {
      case 0:
        return ShopListView(
          searchController: _searchController,
          filteredShops: _filteredShops,
          buildShopCard: _buildShopCard,
        );
      case 1:
        return TransferView(
          // ပွိုင့်ဖြည့် (Top-up / Transfer)
          onBackButtonPressed: () {
            setState(() {
              _currentIndex = 0;
            });
          },
          selectedTransferCategory: _selectedTransferCategory,
          onCategorySelected: (category) {
            setState(() {
              _selectedTransferCategory = category;
            });
          },
          filteredTransfers: filteredTransfers,
        );
      case 2:
        return QrScanView(
          onUserScanned: (scannedData) {
            setState(() {
              _currentIndex = 1;
            });
          },
        );
      case 3:
        return WithdrawView(
          onBackButtonPressed: () {},
          selectedCategory: '',
          onCategorySelected: (String p1) {},
          filteredHistory: [],
        );
      case 4:
        return HistoryView(); // မှတ်တမ်း
      default:
        return ShopListView(
          searchController: _searchController,
          filteredShops: _filteredShops,
          buildShopCard: _buildShopCard,
        );
    }
  }

  // ✨ ပွိုင့်မှ ပိုက်ဆံထုတ်ယူခြင်း (Withdraw Point UI) နမူနာ

  Widget _buildShopCard(Shop shop) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Center(
                  child: Text(
                    (shop.shopName != null && shop.shopName!.isNotEmpty)
                        ? shop.shopName!.substring(
                            0,
                            shop.shopName!.length >= 3
                                ? 3
                                : shop.shopName!.length,
                          )
                        : 'SMT',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.shopName ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'SHOP_ID: ${shop.shopId}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: shop.isOpen == 1
                      ? const Color(0xFFD1FAE5)
                      : const Color(0xFFFFE4E6),
                  borderRadius: BorderRadius.circular(9999.0),
                ),
                child: Text(
                  shop.isOpen == 1 ? 'OPEN' : 'CLOSED',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: shop.isOpen == 1
                        ? Colors.teal
                        : const Color(0xFFDC2626),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          const Divider(color: Color(0xFFF1F5F9), thickness: 1.0),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${shop.userName ?? ''} (ပိုင်ရှင်)',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF475569),
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.phone, color: Colors.white, size: 16),
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  padding: const EdgeInsets.all(8.0),
                  shape: const CircleBorder(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✨ Bottom Nav Bar ကို အစဉ်လိုက်ပြင်ဆင်ပြီး ပရိုဖိုင်ဖြုတ်ထားသည် (ဆိုင်များ၊ ပွိုင့်ဖြည့်၊ ငွေထုတ်၊ မှတ်တမ်း)
  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 66,
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(33),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _buildNavBarItem(Icons.store, 'ဆိုင်များ', 0)),
                Expanded(
                  child: _buildNavBarItem(
                    Icons.compare_arrows_rounded,
                    'ပွိုင့်ဖြည့်',
                    1,
                  ),
                ),
                const SizedBox(width: 55), // Floating QR Button အတွက် နေရာလွတ်
                Expanded(
                  child: _buildNavBarItem(
                    Icons.account_balance_wallet,
                    'ငွေထုတ်',
                    3,
                  ),
                ),
                Expanded(child: _buildNavBarItem(Icons.history, 'မှတ်တမ်း', 4)),
              ],
            ),
          ),
          Positioned(top: -18, child: _buildFloatingScanButton()),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
            size: 20,
          ),
          const SizedBox(height: 2.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingScanButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = 2;
        });
      },
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: Colors.teal,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 26),
      ),
    );
  }
}
