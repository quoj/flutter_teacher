import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart' as mlkit;
import 'package:qr_code_scanner/qr_code_scanner.dart' as qr;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class BulletinWidget extends StatefulWidget {
  const BulletinWidget({super.key});

  @override
  State<BulletinWidget> createState() => _BulletinWidgetState();
}

class _BulletinWidgetState extends State<BulletinWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  qr.QRViewController? controller;
  bool scanned = false;
  String result = "";

  final List<String> assetImages = [
    'assets/images/noithat.jpg',
    'assets/images/be.jpg',
    'assets/images/bangtin.png',
    'assets/images/gopy.jpg',
    'assets/images/thuvienanh.jpg',
    'assets/images/suckhoe.png',
    'assets/images/hocphi.png',
    'assets/images/hoctap.png',
    'assets/images/thucdon.png',
    'assets/images/unnamed.png',
    'assets/images/task_9012120.png',
    'assets/images/basketball_7108306.png',
    'assets/images/QA.png',
    'assets/images/buasang.jpg',
    'assets/images/buatrua.jpg',
    'assets/images/buaphu.jpg',
    'assets/images/loinhan.jpg',
    'assets/images/nhatky.jpg',
    'assets/images/teacher.jpg',
    'assets/images/1.png',
  ];

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(qr.QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((qr.Barcode scanData) {
      if (!scanned) {
        setState(() {
          scanned = true;
          result = scanData.code ?? '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR Đã quét: ${scanData.code}')),
        );
        controller.pauseCamera();
      }
    });
  }

  Future<void> _scanImageFile(File file) async {
    final inputImage = mlkit.InputImage.fromFilePath(file.path);
    final barcodeScanner = mlkit.BarcodeScanner();
    final List<mlkit.Barcode> barcodes = await barcodeScanner.processImage(inputImage);

    if (barcodes.isNotEmpty) {
      final code = barcodes.first.rawValue ?? '';
      setState(() {
        scanned = true;
        result = code;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã quét từ ảnh: $code')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy mã QR trong ảnh.')),
      );
    }
  }

  Future<void> _scanAssetImage(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${assetPath.split('/').last}');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    await _scanImageFile(file);
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _scanImageFile(File(pickedFile.path));
    }
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Chọn ảnh"),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Column(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_library),
                label: const Text("Chọn từ thư viện"),
                onPressed: () async {
                  Navigator.pop(context);
                  await _pickImageFromGallery();
                },
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  itemCount: assetImages.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _scanAssetImage(assetImages[index]);
                      },
                      child: Image.asset(assetImages[index], fit: BoxFit.cover),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: qr.QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: qr.QrScannerOverlayShape(
                  borderColor: Colors.blue,
                  borderRadius: 20,
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
                onPressed: _showImagePickerDialog,
              ),
              IconButton(
                icon: const Icon(Icons.flash_on, color: Colors.white),
                onPressed: () async {
                  await controller?.toggleFlash();
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (scanned)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Kết quả quét: $result',
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}