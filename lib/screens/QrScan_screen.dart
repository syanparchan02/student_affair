import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanView extends StatefulWidget {
  final Function(String scannedData)
  onUserScanned; // 👈 Transfer Screen သို့မဟုတ် Main Screen သို့ Data ပို့ပေးရန် Callback

  const QrScanView({super.key, required this.onUserScanned});

  @override
  State<QrScanView> createState() => _QrScanViewState();
}

class _QrScanViewState extends State<QrScanView> {
  late final MobileScannerController _controller;
  bool _isScanned = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                            Icons.qr_code_scanner_rounded,
                            color: Color(0xFF0D9488),
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'QR စကင်နာ',
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
                              'ကုဒ်ဖတ်ရန် နေရာ',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildCustomAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "ကျောင်းသား သို့မဟုတ် ဆိုင် QR ကုဒ်ကို ဖတ်ပါ",
              style: TextStyle(
                color: Colors.teal,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF0D9488), width: 3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: MobileScanner(
                  controller: _controller,
                  onDetect: (capture) {
                    if (_isScanned) return;
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      if (barcode.rawValue != null) {
                        setState(() {
                          _isScanned = true;
                        });

                        final scannedData =
                            barcode.rawValue!; // ဥပမာ - "user-1"

                        // ✨ QR Data ထဲတွင် "user" ပါဝင်ခြင်း ရှိမရှိ စစ်ဆေးခြင်း
                        if (scannedData.startsWith("user-") ||
                            scannedData.contains("user")) {
                          // Transfer မျက်နှာပြင်သို့ သွားရန် သို့မဟုတ် Main Screen ၏ Transfer Tab (Index 1) သို့ ပို့ပေးရန်
                          widget.onUserScanned(scannedData);
                        } else {
                          // အခြား QR များအတွက် Dialog ပြရန်
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("QR Scan Result"),
                              content: Text(
                                "Data: $scannedData (User မဟုတ်ပါ)",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _isScanned = false;
                                    });
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
                        }
                        break;
                      }
                    }
                  },
                  errorBuilder: (context, error) {
                    return const Center(
                      child: Text(
                        'ကင်မရာ ဖွင့်၍မရပါ',
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
