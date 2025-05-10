import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class BulletinWidget extends StatefulWidget {
  const BulletinWidget({super.key});

  @override
  State<BulletinWidget> createState() => _BulletinWidgetState();
}

class _BulletinWidgetState extends State<BulletinWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool scanned = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!scanned) {
        setState(() {
          scanned = true;
        });
        // Xử lý dữ liệu quét được
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR Đã quét: ${scanData.code}')),
        );
        controller.pauseCamera(); // Tạm dừng camera sau khi quét xong
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Màu nền tối
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // Bo góc khung quét
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.blue,
                  borderRadius: 20, // Bo góc viền overlay
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.image, color: Colors.white),
                onPressed: () {
                  // Chức năng chụp ảnh hoặc chọn ảnh
                },
              ),
              IconButton(
                icon: const Icon(Icons.flash_on, color: Colors.white),
                onPressed: () {
                  // Chức năng bật/tắt đèn flash
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (scanned)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Kết quả quét: ${controller?.scannedDataStream}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}