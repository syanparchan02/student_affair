import 'package:flutter/material.dart';
import 'package:student_affair/models/shop.dart';

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
  int _currentIndex = 0;
  String _selectedTransferCategory = "All";

  // Exchange variables for Index 3
  String _fromCurrency = 'MMK (ကျပ်)';
  String _toCurrency = 'USD (ဒေါ်လာ)';
  final TextEditingController _exchangeController = TextEditingController();
  final double _exchangeRate = 2100.0;

  final List<Shop> _allShops = [
    Shop(
      id: "SHP-10293",
      name: "ရွှေမန်းသူ စားသောက်ဆိုင်",
      owner: "ဦးအောင်ကျော်",
      phone: "09 123 456 789",
      status: "open",
      img: "https://placehold.co/60x60/teal/white?text=Shop",
    ),
    Shop(
      id: "SHP-10294",
      name: "မြန်မာ့လက်ရာ",
      owner: "ဒေါ်ခင်မာ",
      phone: "09 987 654 321",
      status: "closed",
      img: "https://placehold.co/60x60/orange/white?text=Shop",
    ),
    Shop(
      id: "SHP-10295",
      name: "မင်္ဂလာ စားသောက်ဆိုင်",
      owner: "ကိုမျိုး",
      phone: "09 444 555 666",
      status: "open",
      img: "https://placehold.co/60x60/purple/white?text=Shop",
    ),
  ];

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
    _filteredShops = _allShops;
    _searchController.addListener(_filterShops);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _exchangeController.dispose();
    super.dispose();
  }

  void _filterShops() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredShops = _allShops.where((shop) {
        return shop.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _handleProfileTap() {
    print("Profile tapped");
  }

  void _handleDeleteShopTap() {
    print("Delete Shop tapped");
  }

  void _handleLogoutTap() {
    print("Logout tapped");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _currentIndex == 0 ? _buildCustomAppBar() : null,
        body: Stack(
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
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Logo & Title / Subtitle (Wrapped in Expanded to fix overflow)
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            color: Colors.white,
                            child: const Icon(
                              Icons.restaurant_menu,
                              color: Color(0xFF0D9488),
                              size: 24,
                            ),
                          ),
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
              // Right: Notification & Logout Buttons
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.notifications_outlined,
                            size: 20,
                            color: Color(0xFF334155),
                          ),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
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
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.logout,
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
        return _buildPlaceholderView("စကန်ဖတ်ရန် (QR Scan)");
      case 3:
        return HistoryView();
      case 4:
        return SettingsView();
      default:
        return ShopListView(
          searchController: _searchController,
          filteredShops: _filteredShops,
          buildShopCard: _buildShopCard,
        );
    }
  }

  Widget _buildPlaceholderView(String title) {
    return Container(
      color: const Color(0xFFF1F5F9),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D9488),
          ),
        ),
      ),
    );
  }

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
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  shop.img,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 56),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'ID: ${shop.id}',
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
                  color: shop.status == 'open'
                      ? const Color(0xFFD1FAE5)
                      : const Color(0xFFFFE4E6),
                  borderRadius: BorderRadius.circular(9999.0),
                ),
                child: Text(
                  shop.status == 'open' ? 'OPEN' : 'CLOSED',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: shop.status == 'open'
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
                '${shop.owner} (ပိုင်ရှင်)',
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
                    Icons.compare_arrows,
                    'လွှဲပြောင်း',
                    1,
                  ),
                ),
                const SizedBox(width: 55),
                Expanded(child: _buildNavBarItem(Icons.history, 'မှတ်တမ်း', 3)),
                Expanded(
                  child: _buildNavBarItem(Icons.settings, 'ဆက်တင်များ', 4),
                ),
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
