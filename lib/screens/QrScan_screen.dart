import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:student_affair/service/api_service.dart';

class QrScanView extends StatefulWidget {
  final Function(String scannedData) onUserScanned;
  final Function(String phone, String mode)? onNavigateWithPhone;

  const QrScanView({
    super.key,
    required this.onUserScanned,
    this.onNavigateWithPhone,
  });

  @override
  State<QrScanView> createState() => _QrScanViewState();
}

class _QrScanViewState extends State<QrScanView>
    with SingleTickerProviderStateMixin {
  late MobileScannerController scannerController;
  late AnimationController animationController;
  bool scanned = false;
  bool _isLoadingApi = false;

  @override
  void initState() {
    super.initState();
    scannerController = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    scannerController.dispose();
    animationController.dispose();
    super.dispose();
  }

  Future<void> handleScan(String data) async {
    if (scanned || _isLoadingApi) return;

    String cleanedData = data.trim();

    String extractedData = cleanedData;
    final int uIndex = cleanedData.indexOf('U');
    if (uIndex != -1) {
      extractedData = cleanedData.substring(uIndex);
    }

    print("Original: '$cleanedData'");
    print("Extracted: '$extractedData'");

    setState(() {
      scanned = true;
      _isLoadingApi = true;
    });

    try {
      final response = await ApiService().getUserInfoByQr(extractedData);

      if (response['success'] == true && response['data'] != null) {
        final String role =
            response['data']['role']?.toString().toLowerCase() ?? '';
        final String userPhone =
            response['data']['user_phone']?.toString() ?? '';

        if (!mounted) return;

        if (role == 'student' || role == 'teacher') {
          if (widget.onNavigateWithPhone != null) {
            widget.onNavigateWithPhone!(userPhone, 'topup');
          } else {
            widget.onUserScanned(userPhone);
          }
        } else if (role == 'shop') {
          _showChoiceDialog(userPhone);
        } else {
          _showSnackBar("သတ်မှတ်ထားသော Role နှင့် မကိုက်ညီပါ။", Colors.red);
          setState(() {
            scanned = false;
          });
        }
      } else {
        _showSnackBar(
          response['message'] ?? 'အချက်အလက် ရယူရန် မအောင်မြင်ပါ။',
          Colors.red,
        );
        setState(() {
          scanned = false;
        });
      }
    } catch (e) {
      _showSnackBar(e.toString(), Colors.red);
      setState(() {
        scanned = false;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingApi = false;
        });
      }
    }
  }

  void _showChoiceDialog(String phone) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20.0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color(0xff0D6B80).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: Color(0xff0D6B80),
                  size: 48.0,
                ),
              ),
              const SizedBox(height: 16.0),
              // Title
              const Text(
                "ရွေးချယ်ပါ",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8.0),

              Text(
                "ဤ QR အတွက်လုပ်ဆောင်ချက်ရွေးချယ်ပါ",
                style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
              ),

              const SizedBox(height: 24.0),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);

                        if (widget.onNavigateWithPhone != null) {
                          widget.onNavigateWithPhone!(phone, 'withdraw');
                        } else {
                          widget.onUserScanned(phone);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.red, Colors.redAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 8.0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 18.0,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              "ငွေထုတ်",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);

                        if (widget.onNavigateWithPhone != null) {
                          widget.onNavigateWithPhone!(phone, 'topup');
                        } else {
                          widget.onUserScanned(phone);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xff0D6B80), Color(0xff0D6B80)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff0D6B80).withOpacity(0.3),
                              blurRadius: 8.0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                              size: 18.0,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              "ပွိုင့်ဖြည့်",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  Future<void> galleryScan() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final result = await scannerController.analyzeImage(image.path);
    if (result != null && result.barcodes.isNotEmpty) {
      final code = result.barcodes.first.rawValue;
      if (code != null) {
        handleScan(code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: scannerController,
            onDetect: (capture) {
              for (final barcode in capture.barcodes) {
                final value = barcode.rawValue;
                if (value != null) {
                  handleScan(value);
                  break;
                }
              }
            },
          ),
          Container(color: Colors.black.withOpacity(0.55)),
          if (_isLoadingApi)
            const Center(
              child: CircularProgressIndicator(color: Color(0xff0D6B80)),
            ),
          Center(
            child: SizedBox(
              width: 300.0,
              height: 300.0,
              child: CustomPaint(
                painter: ScannerPainter(),
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        Positioned(
                          top: animationController.value * 280.0,
                          left: 15.0,
                          right: 15.0,
                          child: Container(
                            height: 3.0,
                            decoration: BoxDecoration(
                              color: Color(0xff0D6B80),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xff0D6B80),
                                  blurRadius: 15.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 45.0,
            left: 20.0,
            right: 20.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 50),
                        child: Text(
                          "Scan QR Code",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.flash_on, color: Colors.white),
                        onPressed: () {
                          scannerController.toggleTorch();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 150.0,
            left: 20.0,
            right: 20.0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: galleryScan,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.photo_library,
                          color: Color(0xff0D6B80),
                          size: 18.0,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          "Gallery",
                          style: TextStyle(
                            color: Color(0xff0D6B80),
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
}

class ScannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xff0D6B80)
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    const double corner = 40.0;

    canvas.drawLine(const Offset(0.0, 0.0), const Offset(corner, 0.0), paint);
    canvas.drawLine(const Offset(0.0, 0.0), const Offset(0.0, corner), paint);
    canvas.drawLine(
      Offset(size.width, 0.0),
      Offset(size.width - corner, 0.0),
      paint,
    );
    canvas.drawLine(Offset(size.width, 0.0), Offset(size.width, corner), paint);
    canvas.drawLine(
      Offset(0.0, size.height),
      Offset(corner, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0.0, size.height),
      Offset(0.0, size.height - corner),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - corner, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - corner),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
