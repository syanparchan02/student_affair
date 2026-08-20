import 'package:flutter/material.dart';
import 'package:student_affair/models/shop_model.dart';
import 'package:student_affair/screens/create_shop_screen.dart';

class ShopListView extends StatelessWidget {
  final TextEditingController searchController;
  final List<Shop> filteredShops;
  final Function(Shop) buildShopCard;
  final VoidCallback? onShopAdded;

  const ShopListView({
    super.key,
    required this.searchController,
    required this.filteredShops,
    required this.buildShopCard,
    this.onShopAdded,
  });

  void _showShopDetailsModal(BuildContext context, Shop shop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return _ShopDetailTabScreen(shop: shop);
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, top: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48.0,
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
                                vertical: 0.0,
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
                                  color: Color(0xff0D6B80),
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
                      SizedBox(
                        height: 48.0,
                        child: ElevatedButton(
                          onPressed: () async {
                            // ဆိုင်အသစ် မှတ်ပုံတင်သည့် စခရင်သို့ သွားမည်၊ ပြီးလျှင် true ပြန်လာမည်
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationScreen(),
                              ),
                            );

                            // ဆိုင်အသစ် အောင်မြင်စွာ ဖွင့်ပြီးပါက ဒေတာအသစ်ပြန်ဆွဲမည်
                            if (result == true && onShopAdded != null) {
                              onShopAdded!();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0D6B80),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
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
                                Container(
                                  width: 54,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff0D6B80),
                                    borderRadius: BorderRadius.circular(14.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      (shop.shopName != null &&
                                              shop.shopName!.isNotEmpty)
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
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        shop.shopName ?? '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        shop.userName ?? '',
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
                                              color: shop.isOpen == 1
                                                  ? const Color(0xFFECFDF5)
                                                  : Colors.red.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              shop.isOpen == 1
                                                  ? 'ဖွင့်သည်'
                                                  : 'ပိတ်သည်',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: shop.isOpen == 1
                                                    ? const Color(0xff0D6B80)
                                                    : Colors.red,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'SHOP_ID: ${shop.shopId}',
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
                                      color: Color(0xff0D6B80),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      shop.shopPhone ?? '',
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
                                    backgroundColor: const Color(0xff0D6B80),
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
                                    'အသေးစိတ်ကြည့်ရန်',
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

// class _ShopDetailTabScreen extends StatefulWidget {
//   final Shop shop;

//   const _ShopDetailTabScreen({required this.shop});

//   @override
//   State<_ShopDetailTabScreen> createState() => _ShopDetailTabScreenState();
// }

// class _ShopDetailTabScreenState extends State<_ShopDetailTabScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   late List<String> _categoryNames;
//   late Map<String, List<dynamic>> _categorizedMenus;

//   @override
//   void initState() {
//     super.initState();
//     _categorizedMenus = widget.shop.categories;
//     _categoryNames = _categorizedMenus.keys.toList();
//     _tabController = TabController(
//       length: _categoryNames.isEmpty ? 1 : _categoryNames.length,
//       vsync: this,
//     );

//     _tabController.addListener(() {
//       if (mounted) {
//         setState(() {});
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final shop = widget.shop;

//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.fromLTRB(10, 20, 20, 24),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFF0F4747), Color(0xff0D6B80)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(32),
//                   bottomRight: Radius.circular(32),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       IconButton(
//                         icon: const Icon(
//                           Icons.arrow_back_ios,
//                           color: Colors.white,
//                         ),
//                         onPressed: () => Navigator.pop(context),
//                         padding: EdgeInsets.zero,
//                         constraints: const BoxConstraints(),
//                       ),
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Colors.red.withOpacity(0.3),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: const Icon(
//                               Icons.delete_outline,
//                               color: Colors.redAccent,
//                               size: 20,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     shop.shopName ?? '',
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 14,
//                             vertical: 10,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'OWNER',
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white70,
//                                 ),
//                               ),
//                               const SizedBox(height: 2),
//                               Text(
//                                 shop.userName ?? '',
//                                 style: const TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 14,
//                             vertical: 10,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'PHONE',
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white70,
//                                 ),
//                               ),
//                               const SizedBox(height: 2),
//                               Text(
//                                 shop.shopPhone ?? '',
//                                 style: const TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 14),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           'SHOP_ID:${shop.shopId}',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Container(
//                             width: 8,
//                             height: 8,
//                             decoration: BoxDecoration(
//                               color: shop.isOpen == 1
//                                   ? const Color.fromARGB(255, 160, 179, 184)
//                                   : Colors.redAccent,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             shop.isOpen == 1 ? 'ဖွင့်ထားသည်' : 'ပိတ်ထားသည်',
//                             style: const TextStyle(
//                               fontSize: 13,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             if (_categoryNames.isNotEmpty)
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   children: _categoryNames.asMap().entries.map((entry) {
//                     int index = entry.key;
//                     String categoryName = entry.value;
//                     final bool isSelected = _tabController.index == index;

//                     return Padding(
//                       padding: const EdgeInsets.only(right: 10),
//                       child: GestureDetector(
//                         onTap: () {
//                           _tabController.animateTo(index);
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 10,
//                           ),
//                           decoration: BoxDecoration(
//                             color: isSelected
//                                 ? Color(0xff0D6B80)
//                                 : Colors.white,
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(
//                               color: isSelected
//                                   ? const Color(0xff0D6B80)
//                                   : const Color(0xFFE2E8F0),
//                             ),
//                             boxShadow: isSelected
//                                 ? [
//                                     BoxShadow(
//                                       color: const Color(
//                                         0xff0D6B80,
//                                       ).withOpacity(0.3),
//                                       blurRadius: 8,
//                                       offset: const Offset(0, 4),
//                                     ),
//                                   ]
//                                 : [],
//                           ),
//                           child: Text(
//                             categoryName,
//                             style: TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.bold,
//                               color: isSelected
//                                   ? Colors.white
//                                   : const Color(0xFF64748B),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: _categoryNames.isEmpty
//                   ? const Center(child: Text('No categories available'))
//                   : TabBarView(
//                       controller: _tabController,
//                       children: _categoryNames.map((categoryName) {
//                         final items = _categorizedMenus[categoryName] ?? [];
//                         return ListView.builder(
//                           physics: const BouncingScrollPhysics(),
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           itemCount: items.length,
//                           itemBuilder: (context, index) {
//                             final item = items[index];
//                             final itemName = item.itemName ?? '';
//                             final itemDesc = item.description ?? '';
//                             final itemPrice = '${item.itemPrice} ပွိုင့်';
//                             final quantity = item.quantity.toString();

//                             return Container(
//                               margin: const EdgeInsets.only(bottom: 12),
//                               padding: const EdgeInsets.all(14),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(20),
//                                 border: Border.all(
//                                   color: const Color(0xFFF1F5F9),
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: const Color(
//                                       0xff0D6B80,
//                                     ).withOpacity(0.04),
//                                     blurRadius: 12,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     width: 58,
//                                     height: 58,
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         colors: [
//                                           Colors.teal.shade50,
//                                           Colors.teal.shade100,
//                                         ],
//                                         begin: Alignment.topLeft,
//                                         end: Alignment.bottomRight,
//                                       ),
//                                       borderRadius: BorderRadius.circular(16),
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         'Qty: $quantity',
//                                         style: TextStyle(
//                                           fontSize: 11,
//                                           fontWeight: FontWeight.bold,
//                                           color: const Color(
//                                             0xff0D6B80,
//                                           ).withOpacity(0.8),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 14),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           itemName,
//                                           style: const TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.bold,
//                                             color: Color(0xFF0F172A),
//                                           ),
//                                         ),
//                                         if (itemDesc.isNotEmpty) ...[
//                                           const SizedBox(height: 3),
//                                           Text(
//                                             itemDesc,
//                                             style: const TextStyle(
//                                               fontSize: 12,
//                                               color: Color(0xFF94A3B8),
//                                             ),
//                                           ),
//                                         ],
//                                         const SizedBox(height: 6),
//                                         Text(
//                                           itemPrice,
//                                           style: const TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.bold,
//                                             color: Color(0xff0D6B80),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         );
//                       }).toList(),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class _ShopDetailTabScreen extends StatefulWidget {
  final Shop shop;

  const _ShopDetailTabScreen({required this.shop});

  @override
  State<_ShopDetailTabScreen> createState() => _ShopDetailTabScreenState();
}

class _ShopDetailTabScreenState extends State<_ShopDetailTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<String> _categoryNames;
  late Map<String, List<dynamic>> _categorizedMenus;

  @override
  void initState() {
    super.initState();
    _categorizedMenus = widget.shop.categories;
    _categoryNames = _categorizedMenus.keys.toList();
    _tabController = TabController(
      length: _categoryNames.isEmpty ? 1 : _categoryNames.length,
      vsync: this,
    );

    _tabController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shop = widget.shop;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F9),
        body: Column(
          children: [
            // Modern Floating-Edge Header with Depth Gradient
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF093838),
                    Color(0xFF0D6B80),
                    Color(0xFF118AB2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x260D6B80),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Bar / Top Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          onPressed: () => Navigator.pop(context),
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.redAccent.withOpacity(0.3),
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                          onPressed: () {},
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Shop Title & Status Badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          shop.shopName ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: shop.isOpen == 1
                                    ? const Color(0xFF10B981)
                                    : Colors.redAccent,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (shop.isOpen == 1
                                                ? const Color(0xFF10B981)
                                                : Colors.redAccent)
                                            .withOpacity(0.6),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 7),
                            Text(
                              shop.isOpen == 1 ? 'ဖွင့်ထားသည်' : 'ပိတ်ထားသည်',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Frosted Glass Info Cards (Owner & Phone)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'OWNER',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white60,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                shop.userName ?? '',
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
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'PHONE',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white60,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                shop.shopPhone ?? '',
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
                  const SizedBox(height: 12),

                  // Shop ID Subtext
                  Text(
                    'SHOP_ID: ${shop.shopId}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Elevated Modern Category Tabs
            if (_categoryNames.isNotEmpty)
              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categoryNames.length,
                  itemBuilder: (context, index) {
                    String categoryName = _categoryNames[index];
                    final bool isSelected = _tabController.index == index;

                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          _tabController.animateTo(index);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF0D6B80)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF0D6B80)
                                  : const Color(0xFFE2E8F0),
                              width: 1.2,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF0D6B80,
                                      ).withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                          ),
                          alignment: Alignment.center,
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
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),

            // Menu Items List View
            Expanded(
              child: _categoryNames.isEmpty
                  ? const Center(
                      child: Text(
                        'No categories available',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : TabBarView(
                      controller: _tabController,
                      children: _categoryNames.map((categoryName) {
                        final items = _categorizedMenus[categoryName] ?? [];
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final itemName = item.itemName ?? '';
                            final itemDesc = item.description ?? '';
                            final itemPrice = '${item.itemPrice} ပွိုင့်';
                            final quantity = item.quantity.toString();

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: const Color(0xFFF1F5F9),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF0F172A,
                                    ).withOpacity(0.04),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Quantity Badge Box
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(
                                            0xFF0D6B80,
                                          ).withOpacity(0.06),
                                          const Color(
                                            0xFF0D6B80,
                                          ).withOpacity(0.14),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'x$quantity',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF0D6B80),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Item Info Column
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          itemName,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                        if (itemDesc.isNotEmpty) ...[
                                          const SizedBox(height: 3),
                                          Text(
                                            itemDesc,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF94A3B8),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                        const SizedBox(height: 6),
                                        Text(
                                          itemPrice,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF0D6B80),
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
  }
}
