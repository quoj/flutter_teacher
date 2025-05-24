import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart' as mlkit;
import 'package:qr_code_scanner/qr_code_scanner.dart' as qr;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  String studentName = "";
  int studentId = 0;  // sẽ gán từ QR code
  int classId = 101;  // Thay bằng ID lớp thực tế

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(qr.QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((qr.Barcode scanData) async {
      if (!scanned) {
        setState(() {
          scanned = true;
          result = scanData.code ?? '';
        });
        controller.pauseCamera();

        // Giả sử QR code chính là studentId dạng số
        if (result.isNotEmpty && int.tryParse(result) != null) {
          studentId = int.parse(result);
          // TODO: nếu cần lấy tên từ server, gọi API ở đây để gán studentName
        }

        await _showAttendanceStatusDialog();
        controller.resumeCamera();
        setState(() {
          scanned = false;
        });
      }
    });
  }

  Future<void> _showImagePickerDialog() async {
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
              // Nếu bạn có ảnh mẫu, thêm vào đây
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

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _scanImageFile(File(pickedFile.path));
    }
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

      // Xử lý tương tự ở trên
      if (code.isNotEmpty && int.tryParse(code) != null) {
        studentId = int.parse(code);
      }

      await _showAttendanceStatusDialog();
      setState(() {
        scanned = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy mã QR trong ảnh.')),
      );
    }
  }

  Future<void> _showAttendanceStatusDialog() async {
    final status = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Chọn trạng thái điểm danh'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'present'),
              child: const Text('Có mặt (present)'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'absent'),
              child: const Text('Vắng mặt (absent)'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'excused'),
              child: const Text('Có lý do (excused)'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'unmarked'),
              child: const Text('Chưa điểm danh (unmarked)'),
            ),
          ],
        );
      },
    );

    if (status != null) {
      await _updateAttendance(status);
    }
  }

  Future<void> _updateAttendance(String status) async {
    final url = Uri.parse('http://10.0.2.2:8080/attendance'); // Địa chỉ IP cho trình giả lập
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'attendance_day': DateTime.now().toIso8601String().split('T').first,
          'note': 'Cập nhật điểm danh qua QR',
          'status': status,
          'student_id': studentId,
          'name': studentName, // Đảm bảo gán giá trị này từ server nếu cần
          'class_id': classId,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật điểm danh thành công!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi cập nhật điểm danh: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi kết nối server: $e')),
      );
    }
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