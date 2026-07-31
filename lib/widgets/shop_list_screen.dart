import 'package:flutter/material.dart';
import 'package:student_affair/screens/create_shop_screen.dart';
import '../models/shop.dart';

class ShopListView extends StatelessWidget {
  final TextEditingController searchController;
  final List<Shop> filteredShops;
  final Function(Shop) buildShopCard;

  const ShopListView({
    super.key,
    required this.searchController,
    required this.filteredShops,
    required this.buildShopCard,
  });

  // ပိုမိုလှပပြီး ခေတ်မီဆန်းသစ်သော Full-Screen Shop Details & Categorized Menus
  void _showShopDetailsModal(BuildContext context, Shop shop) {
    // အမျိုးအစားအလိုက် Menu စာရင်းများနှင့် ဈေးနှုန်းများ
    final Map<String, List<Map<String, String>>> categorizedMenus = {
      'Main': [
        {
          'name': 'Special Fried Rice',
          'desc': 'Chicken, Seafood, Egg',
          'price': '8,500 Ks',
        },
        {
          'name': 'Chicken Curry',
          'desc': 'Traditional Style',
          'price': '6,000 Ks',
        },
      ],
      'Fried': [
        {'name': 'အာလူးကြော်', 'desc': 'Crispy Potato', 'price': '၁,၅၀၀ ကျပ်'},
        {
          'name': 'ပဲကျော်စုံ',
          'desc': 'Mixed Fried Bean',
          'price': '၁,၂၀၀ ကျပ်',
        },
      ],
      'Noodles': [
        {
          'name': 'ရခိုင်မုန့်တီ',
          'desc': 'Rakhine Style',
          'price': '၂,၀၀၀ ကျပ်',
        },
        {
          'name': 'ကျွဲထိုးခေါက်ဆွဲ',
          'desc': 'Special Noodle',
          'price': '၂,၅၀၀ ကျပ်',
        },
      ],
      'Salads': [
        {
          'name': 'ကြာဇံသုပ်',
          'desc': 'Glass Noodle Salad',
          'price': '၂,၀၀၀ ကျပ်',
        },
        {'name': 'ခေါက်ဆွဲသုပ်', 'desc': 'Noodle Salad', 'price': '၁,၈၀၀ ကျပ်'},
      ],
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return DefaultTabController(
            length: categorizedMenus.keys.length,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                children: [
                  // Top Header Section with curved/rounded bottom and Teal Gradient
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0F4747), Colors.teal],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back button and Action icons with clear yellow (block/power) and red (delete) colors
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.power_settings_new,
                                    color: Colors.amberAccent,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Shop Name
                        Text(
                          shop.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Owner & Phone boxes
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'OWNER',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      shop.owner,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'PHONE',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      shop.phone,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // ID and Open Status Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'ID: ${shop.id}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.greenAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Open Now',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category Pills / Tabs Bar
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: categorizedMenus.keys
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) {
                            int index = entry.key;
                            String categoryName = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Builder(
                                builder: (context) {
                                  final TabController? tabController =
                                      DefaultTabController.of(context);
                                  final bool isSelected =
                                      tabController?.index == index;
                                  return GestureDetector(
                                    onTap: () {
                                      tabController?.animateTo(index);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.teal
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.teal
                                              : const Color(0xFFE2E8F0),
                                        ),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: Colors.teal
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: Text(
                                        categoryName,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.white
                                              : const Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          })
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // TabBarView for Content with Modernized Menu Cards (Pencil removed, enhanced layout)
                  Expanded(
                    child: TabBarView(
                      children: categorizedMenus.entries.map((entry) {
                        final items = entry.value;
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFFF1F5F9),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.teal.withOpacity(0.04),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 58,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.teal.shade50,
                                          Colors.teal.shade100,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Menu',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal.shade800,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name']!,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                        if (item['desc'] != null &&
                                            item['desc']!.isNotEmpty) ...[
                                          const SizedBox(height: 3),
                                          Text(
                                            item['desc']!,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF94A3B8),
                                            ),
                                          ),
                                        ],
                                        const SizedBox(height: 6),
                                        Text(
                                          item['price']!,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.teal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey<int>(0),
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 110.0),
            child: Column(
              children: [
                // Search ဘားနှင့် Add Shop ခလုတ်ကို ဘေးချင်းယှဉ်ရန် Row ကိုသုံးထားပါသည်
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, top: 24),
                  child: Row(
                    children: [
                      // Search Bar
                      Expanded(
                        child: SizedBox(
                          height: 48.0, // အမြင့်ကို သင့်တော်ရုံ သတ်မှတ်ခြင်း
                          child: TextField(
                            controller: searchController,
                            style: const TextStyle(fontSize: 14.0),
                            decoration: InputDecoration(
                              hintText: 'ဆိုင်အမည်ရှာရန်...',
                              hintStyle: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 14.0,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Color(0xFF94A3B8),
                                size: 20,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0.0, // အမြင့်ညီစေရန် 0 ထားခြင်း
                                horizontal: 12.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE2E8F0),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE2E8F0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),

                      // Add Shop ခလုတ် (အမြင့်ကို Search ဘားနှင့် တထပ်တည်းဖြစ်စေရန်)
                      SizedBox(
                        height: 48.0,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                20.0,
                              ), // ပုံစံတူ ဝိုင်းစေရန်
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, size: 18, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'Add',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: filteredShops.map((shop) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      // ပုံပါအတိုင်း Card ပုံစံနှင့် အောက်ခြေ ဖုန်းနံပါတ်၊ View Details ခလုတ်ပါဝင်သော ပုံစံသို့ ပြင်ဆင်ထားပါသည်
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Shop Logo / Icon Box
                                Container(
                                  width: 54,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(14.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      shop.name.isNotEmpty
                                          ? shop.name.substring(
                                              0,
                                              shop.name.length >= 3
                                                  ? 3
                                                  : shop.name.length,
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
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        shop.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        shop.owner,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFECFDF5),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Text(
                                              'OPEN',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF059669),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'ID: ${shop.id}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF94A3B8),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Divider(
                                height: 1,
                                color: Color(0xFFF1F5F9),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.phone_outlined,
                                      size: 16,
                                      color: Colors.teal,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      shop.phone,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF334155),
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      _showShopDetailsModal(context, shop),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'VIEW DETAILS',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
