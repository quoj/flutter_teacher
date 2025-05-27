import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../../api/api_service.dart';
import '../../../model/category.dart';
import '../../../models/menu.dart';
import '../../../models/schedule.dart';
import '../../../service/category_service.dart';
import 'package:t2305m_teacher/models/user.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

/// 1. BannerSlider: nhận thêm onQrTap
class BannerSlider extends StatelessWidget {
  final VoidCallback onQrTap;
  const BannerSlider({super.key, required this.onQrTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurpleAccent, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(8), // Giảm padding
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30, // Nhỏ hơn (mặc định là 30)
            backgroundImage: AssetImage('assets/images/teacher.jpg'),
          ),
          const SizedBox(width: 8), // Giảm khoảng cách
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Nguyễn Thị Hồng Anh",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), // Nhỏ hơn
              ),
              Text(
                "Giáo viên phụ trách",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                "Lớp Mầm 1",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            iconSize: 20, // Nhỏ icon
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
            onPressed: onQrTap,
          ),
        ],
      ),
    );
  }

}

/// 2. QRScannerSheet widget
class QRScannerSheet extends StatefulWidget {
  final Function(String) onScanned;
  const QRScannerSheet({super.key, required this.onScanned});

  @override
  State<QRScannerSheet> createState() => _QRScannerSheetState();
}

class _QRScannerSheetState extends State<QRScannerSheet> {
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
        scanned = true;
        widget.onScanned(scanData.code ?? '');
        Navigator.of(context).maybePop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text("Quét mã QR", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.blue,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 200,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text("Đưa mã QR vào khung để quét"),
        ],
      ),
    );
  }
}

/// 3. ProfileScreen hoàn chỉnh
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    final categoryService = CategoryService();
    final fetchedCategories = await categoryService.getCategories();
    setState(() {
      categories = fetchedCategories;
    });
  }

  void _showQRScanner() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return QRScannerSheet(
          onScanned: (code) {
            // Xử lý code QR tại đây, ví dụ: show snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('QR Đã quét: $code')),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BannerSlider(onQrTap: _showQRScanner), // truyền callback ở đây
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 18),
                child: BulletinWidget(),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 18),
                child: ScheduleWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 4. BulletinWidget giữ nguyên
class BulletinWidget extends StatefulWidget {
  const BulletinWidget({super.key});

  @override
  _BulletinWidgetState createState() => _BulletinWidgetState();
}

class _BulletinWidgetState extends State<BulletinWidget> {
  late ApiService apiService;
  List<Menu> menus = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio());
    fetchMenus();
  }

  void fetchMenus() async {
    try {
      List<Menu> data = await apiService.getMenus();
      setState(() {
        menus = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching menus: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      width: double.infinity,
      height: 450,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 10),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Thực đơn tuần",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (menus.isNotEmpty)
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: menus.length,
                      itemBuilder: (context, index) {
                        final menu = menus[index];
                        return Container(
                          width: 250,
                          margin: const EdgeInsets.only(right: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              if (menu.dayOfWeek != null)
                                Text(
                                  menu.dayOfWeek!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              const SizedBox(height: 12),
                              Text("🍳 Bữa sáng: ${menu.breakfast ?? 'Không có'}"),
                              const SizedBox(height: 8),
                              Text("🍳 Bữa phụ sáng: ${menu.secondBreakfast ?? 'Không có'}"),
                              const SizedBox(height: 8),
                              Text("🍛 Bữa trưa: ${menu.lunch ?? 'Không có'}"),
                              const SizedBox(height: 8),
                              Text("🍲 Bữa chiều: ${menu.dinner ?? 'Không có'}"),
                              const SizedBox(height: 8),
                              Text("🍳 Bữa phụ chiều: ${menu.secondDinner ?? 'Không có'}"),
                              const SizedBox(height: 8),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                ],
              ),
            )
          else
            const Center(child: Text("Không có thực đơn nào")),
        ],
      ),
    );
  }
}





/// 7. ScheduleWidget giữ nguyên
class ScheduleWidget extends StatelessWidget {
  const ScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu cho hoạt động cả ngày
    final List<Schedule> schedulesToday = [
      Schedule(
        id: 43,
        classId: 101,
        subjectId: "Đón trẻ & thể dục sáng",
        teacherId: 1,
        dayOfWeek: "Thứ 3",
        startTime: DateTime.parse("2025-05-20 08:00:00"),
        endTime: DateTime.parse("2025-05-20 08:30:00"),
      ),
      Schedule(
        id: 44,
        classId: 101,
        subjectId: "Hoạt động học",
        teacherId: 1,
        dayOfWeek: "Thứ 3",
        startTime: DateTime.parse("2025-05-20 08:30:00"),
        endTime: DateTime.parse("2025-05-20 09:30:00"),
      ),
      Schedule(
        id: 45,
        classId: 101,
        subjectId: "Ăn sáng",
        teacherId: 1,
        dayOfWeek: "Thứ 3",
        startTime: DateTime.parse("2025-05-20 09:30:00"),
        endTime: DateTime.parse("2025-05-20 10:00:00"),
      ),
      Schedule(
        id: 46,
        classId: 101,
        subjectId: "Chơi ngoài trời",
        teacherId: 1,
        dayOfWeek: "Thứ 3",
        startTime: DateTime.parse("2025-05-20 10:00:00"),
        endTime: DateTime.parse("2025-05-20 10:30:00"),
      ),
      Schedule(
        id: 47,
        classId: 101,
        subjectId: "Hoạt động góc",
        teacherId: 1,
        dayOfWeek: "Thứ 3",
        startTime: DateTime.parse("2025-05-20 10:30:00"),
        endTime: DateTime.parse("2025-05-20 11:30:00"),
      ),
      Schedule(
        id: 48,
        classId: 101,
        subjectId: "Ăn trưa",
        teacherId: 1,
        dayOfWeek: "Thứ 3",
        startTime: DateTime.parse("2025-05-20 11:30:00"),
        endTime: DateTime.parse("2025-05-20 12:00:00"),
      ),
      Schedule(
        id: 49,
        classId: 101,
        subjectId: "Ngủ trưa",
        teacherId: 1,
        dayOfWeek: "Thứ 3",
        startTime: DateTime.parse("2025-05-20 12:00:00"),
        endTime: DateTime.parse("2025-05-20 14:00:00"),
      ),
      Schedule(
        id: 50,
        classId: 101,
        subjectId: "Ăn xế",
        teacherId: 1,
        dayOfWeek: "Thứ 3",
        startTime: DateTime.parse("2025-05-20 14:00:00"),
        endTime: DateTime.parse("2025-05-20 14:30:00"),
      ),
      Schedule(
        id: 51,
        classId: 101,
        subjectId: "Hoạt động chiều",
        teacherId: 1,
        dayOfWeek: "Thứ 3",
        startTime: DateTime.parse("2025-05-20 14:30:00"),
        endTime: DateTime.parse("2025-05-20 15:30:00"),
      ),
      Schedule(
        id: 52,
        classId: 101,
        subjectId: "Trả trẻ",
        teacherId: 1,
        dayOfWeek: "Thứ 3",
        startTime: DateTime.parse("2025-05-20 15:30:00"),
        endTime: DateTime.parse("2025-05-20 16:00:00"),
      ),
    ];

    return Container(
      color: Colors.grey[100],
      width: double.infinity,
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.orange,
                ),
                SizedBox(width: 8),
                Text(
                  "Hoạt động ngày",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: schedulesToday.isEmpty
                ? const Center(child: Text("Không có hoạt động nào hôm nay"))
                : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: schedulesToday.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final schedule = schedulesToday[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "📚 ${schedule.subjectId}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "🕐 ${DateFormat('HH:mm').format(schedule.startTime)} - ${DateFormat('HH:mm').format(schedule.endTime)}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
